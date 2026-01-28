-- list of LSP servers
-- Set .manual_install = true on LSPs that you have installed locally,
-- otherwise that tool will be installed by Mason
local servers = {
	bashls = true,
	gopls = true,
	luas_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},
	rust_analyzer = { manual_install = true },
	-- python
	pyright = true,
	ruff = true,
	-- ocaml
	ocamllsp = { manual_install = true },
	-- C/C++
	cmake = true,
	clangd = { cmd = { "/usr/lib/llvm/21/bin/clangd" }, manual_install = true },
	-- LaTeX
	texlab = true,
	latexindent = true,
	-- PHP for work
	phpactor = true,
	-- fish
	fish_lsp = true,
}

-- extra servers installed by mason
local mason_tools = {
	"stylua", -- LUA formatter
	"codelldb", -- C++ dap
}

-- utility functions {{{
local with_border = function(f)
	return function()
		f({ border = "rounded" })
	end
end

-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method
---@param bufnr? integer some lsp support methods only in specific files
---@return boolean
local function client_supports_method(client, method, bufnr)
	if vim.fn.has("nvim-0.11") == 1 then
		return client:supports_method(method, bufnr)
	else
		return client.supports_method(method, { bufnr = bufnr })
	end
end
-- }}}

-- Does LSP setup really needs to be that huge?
return {
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			-- "hrsh7th/cmp-nvim-lsp",
			"saghen/blink.cmp",
			-- LSP breadcrumbs
			"SmiteshP/nvim-navic",
			-- LSP navigation
			{ "SmiteshP/nvim-navbuddy", dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" } },
		},
		config = function()
			local capabilities = nil
			if pcall(require, "cmp_nvim_lsp") then
				capabilities = require("cmp_nvim_lsp").default_capabilities()
			end

			-- Build list of tools to install via mason
			vim.list_extend(
				mason_tools,
				vim.tbl_filter(function(key)
					local t = servers[key]
					if type(t) == "table" then
						return t.manual_install
					else
						return t
					end
				end, vim.tbl_keys(servers))
			)
			require("mason-tool-installer").setup({ ensure_installed = mason_tools })

			-- Set global capabilities for all LSP servers
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Configure LSP servers
			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end

				-- Only call vim.lsp.config if there are server-specific settings
				if next(config) ~= nil then
					-- Remove manual_install flag as it's not an LSP config field
					local lsp_config = vim.tbl_deep_extend("force", {}, config)
					lsp_config.manual_install = nil
					vim.lsp.config(name, lsp_config)
				end

				vim.lsp.enable(name)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local client = assert(vim.lsp.get_client_by_id(event.data.client_id), "must have valid client")

					if client.server_capabilities.documentSymbolProvider then
						require("nvim-navic").attach(client, event.buf)
						require("nvim-navbuddy").attach(client, event.buf)
					end

					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local tsc = require("telescope.builtin")
					map("<leader>rj", tsc.lsp_definitions, "Goto Definition")
					map("rJ", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("<leader>rf", tsc.lsp_references, "Find References")
					map("<leader>rF", vim.lsp.buf.references, "Find References (quickfix)")
					map("<leader>rv", tsc.lsp_implementations, "Find [V]irtuals")
					map("<leader>rt", tsc.lsp_type_definitions, "[T]ype definition")
					map("<leader>rw", tsc.lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>rW", tsc.lsp_dynamic_workspace_symbols, "[W]orkspace Symbols")
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					-- map("<leader>ra", vim.lsp.buf.code_action, "Code [A]ction", { "n", "x" })
					map("<C-s>", with_border(vim.lsp.buf.signature_help), "[S]ignature help", "i")
					map("<leader>ri", with_border(vim.lsp.buf.hover), "LSP Info")
					map("<leader>rc", tsc.lsp_incoming_calls, "Called by")
					map("<leader>rC", tsc.lsp_incoming_calls, "Calls these")
					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).

					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client.name == "clangd" then
						vim.api.nvim_create_autocmd("LspTokenUpdate", {
							callback = function(args)
								local token = args.data.token
								if
									token.type == "variable"
									and (token.modifiers.globalScope or token.modifiers.fileScope)
									and token.modifiers.readonly
								then
									vim.lsp.semantic_tokens.highlight_token(
										token,
										args.buf,
										client.id,
										"String",
										{ priority = 130 }
									)
								end
							end,
						})
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = { mason = false },
				gopls = {},
				cmake = {},
				pyright = {},
				-- pyright = {},
				-- rust_analyzer = { mason = false },
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				-- ts_ls = {},
				--

				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			--
			-- `mason` had to be setup earlier: to configure its options see the
			-- `dependencies` table for `nvim-lspconfig` above.
			--
			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"codelldb", -- C++ debugger adaptor
				"phpactor", -- PHP LSP
				"texlab", -- Tex/LaTex LSP
				"latexindent", -- LaTex formatting
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et

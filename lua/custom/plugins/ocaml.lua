vim.api.nvim_create_autocmd("FileType", {
	pattern = { "ocaml" }, -- Add your specific filetypes here
	callback = function()
		-- Map ]] for the current buffer only
		vim.keymap.set("n", "]]", "<cmd>OCamlPhraseNext<CR>", { buffer = true })
		vim.keymap.set("n", "[[", "<cmd>OCamlPhrasePrev<CR>", { buffer = true })
	end,
})

return {
	{
		{
			"tarides/ocaml.nvim",
			config = function()
				require("ocaml").setup({
					params = { client = "ocamllsp" },
					keymaps = {
						switch_ml_mli = "<leader>ra",
						infer = "<leader>oi",
						construct = "<leader>oc",
					},
				})
			end,
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et

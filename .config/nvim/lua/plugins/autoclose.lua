return {
	"m4xshen/autoclose.nvim",
	version = false,
	config = function()
		require("autoclose").setup({
			keys = {
				["$"] = { escape = true, close = true, pair = "$", disabled_filetypes = {} },
			},
		})
	end,
}

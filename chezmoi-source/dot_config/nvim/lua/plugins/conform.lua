return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			go = { "gofumpt" },
		},
		formatters = {
			gofumpt = {
				command = "gofumpt",
				args = { "$FILENAME" },
				stdin = false,
			},
		},
	},
}

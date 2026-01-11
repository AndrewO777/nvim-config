return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"onsails/lspkind.nvim", -- Adds VS Code-like pictograms/icons to the completion menu
		"hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for LSP-based autocompletion
		"hrsh7th/cmp-buffer", -- nvim-cmp source for words from the current buffer
		"hrsh7th/cmp-path", -- nvim-cmp source for filesystem paths
		"hrsh7th/cmp-nvim-lsp-signature-help", -- function signatures
	},
	config = function()
		local cmp = require("cmp")
        local lspkind = require("lspkind")
		cmp.setup({
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol-text",
                    menu = {
                        -- Icons require a font that supports them, like Nerd Fonts
                        --codeium = "",
                        buffer = "",
                        path = "",
                        nvim_lsp = "🅻",
                    }
                }),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-y>'] = cmp.mapping.confirm({ select = false}),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
			sources = {
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "nvim_lsp_signature_help" },
			},
		})
	end,
}

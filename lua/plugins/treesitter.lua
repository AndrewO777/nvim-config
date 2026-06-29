return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "go", "c", "cpp", "rust", "python", "c_sharp", "java" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}

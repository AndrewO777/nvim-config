return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").install({
            "lua", "go", "c", "cpp", "rust", "python", "c_sharp", "java",
            "markdown", "markdown_inline",
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "lua", "go", "c", "cpp", "rust", "python", "cs", "java", "markdown" },
            callback = function()
                vim.treesitter.start()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}

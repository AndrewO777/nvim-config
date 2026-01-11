return {
    "mason-org/mason.nvim",
    opts = {},
    config = function()
        require("mason").setup({
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            }
        })
    end
}

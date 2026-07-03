return {
    "mason-org/mason.nvim",
    config = function()
        require("mason").setup({
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            }
        })

        local registry = require("mason-registry")
        registry.refresh(function()
            local pkg = registry.get_package("tree-sitter-cli")
            if not pkg:is_installed() then
                pkg:install()
            end
        end)
    end
}

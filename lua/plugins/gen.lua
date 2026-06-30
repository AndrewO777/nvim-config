return {
    "David-Kunz/gen.nvim",
    cmd = "Gen",
    keys = {
        { "<leader>ge", ":Gen Explain_Code<CR>", mode = "v", desc = "Gen: explain selection" },
        { "<leader>gr", ":Gen Review_Code<CR>", mode = "v", desc = "Gen: review selection" },
        { "<leader>gg", ":Gen<CR>", mode = { "n", "v" }, desc = "Gen: prompt menu" },
    },
    opts = {
        model = "qwen2.5-coder:3b",
        host = "localhost",
        port = "11434",
        display_mode = "float",
        show_prompt = true,
        show_model = true,
        no_auto_close = false,
    },
    config = function(_, opts)
        local gen = require("gen")
        gen.setup(opts)

        gen.prompts["Explain_Code"] = {
            prompt = "Explain what the following $filetype code does, clearly and "
                .. "concisely. Do not rewrite it.\n\n```$filetype\n$text\n```",
            replace = false,
        }
        gen.prompts["Review_Code"] = {
            prompt = "Review the following $filetype code. Point out bugs, edge cases, "
                .. "and possible improvements. Do not rewrite it.\n\n```$filetype\n$text\n```",
            replace = false,
        }
    end,
}

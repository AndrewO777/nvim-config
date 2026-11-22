local MODEL = "qwen3.5:9b-mlx"

return {
    "olimorris/codecompanion.nvim",
    version = "^20.0.0",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    keys = {
        { "<leader>gc", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "AI: toggle chat" },
        { "<leader>ga", "<cmd>CodeCompanionChat Add<CR>", mode = "v", desc = "AI: add selection to chat" },
        { "<leader>gi", ":CodeCompanion ", mode = { "n", "v" }, desc = "AI: inline prompt" },
        { "<leader>ge", "<cmd>CodeCompanion /explain<CR>", mode = "v", desc = "AI: explain selection" },
        { "<leader>gr", "<cmd>CodeCompanion /review<CR>", mode = "v", desc = "AI: review selection" },
        { "<leader>gg", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "AI: action palette" },
    },
    opts = {
        adapters = {
            http = {
                ollama = function()
                    local adapter = require("codecompanion.adapters").extend("ollama", {
                        -- Uses $OLLAMA_HOST if set, otherwise localhost:11434.
                        schema = {
                            model = { default = MODEL },
                            -- Ollama's default context is small; long chats would
                            -- silently drop the start of the conversation.
                            num_ctx = { default = 16384 },
                            -- Keep the model loaded between messages.
                            keep_alive = { default = "10m" },
                        },
                    })

                    -- Qwen's chat template only accepts a single system message, and
                    -- only as the first message. CodeCompanion sends several (base
                    -- prompt, tool groups like @{files}, rules), so merge them into
                    -- one at the top before the request goes to Ollama.
                    local form_messages = adapter.handlers.form_messages
                    adapter.handlers.form_messages = function(self, messages)
                        local utils = require("codecompanion.adapters.utils")
                        return form_messages(self, utils.merge_system_messages(messages))
                    end

                    return adapter
                end,
                opts = {
                    -- Only list our Ollama adapter when switching with `ga`.
                    show_presets = false,
                },
            },
            acp = {
                opts = { show_presets = false },
            },
        },
        -- Every interaction points at Ollama (the plugin defaults to Copilot).
        interactions = {
            chat = { adapter = "ollama" },
            inline = { adapter = "ollama" },
            cmd = { adapter = "ollama" },
            background = { adapter = "ollama" },
        },
        prompt_library = {
            ["Review Code"] = {
                interaction = "chat",
                description = "Review the selected code for bugs and improvements",
                opts = {
                    alias = "review",
                    auto_submit = true,
                    is_slash_cmd = true,
                    modes = { "v" },
                    stop_context_insertion = true,
                },
                prompts = {
                    {
                        role = "system",
                        content = "You are a careful senior engineer doing a code review.",
                    },
                    {
                        role = "user",
                        content = "Review the following ${context.filetype} code. Point out bugs, "
                            .. "edge cases, and possible improvements. Do not rewrite it.\n\n"
                            .. "```${context.filetype}\n${context.code}\n```",
                    },
                },
            },
        },
    },
}

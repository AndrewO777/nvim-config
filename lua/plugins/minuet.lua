return {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        -- Windows workaround: as you type, minuet cancels its in-flight request to
        -- start a fresh one. A killed curl exits with code 1 on Windows, which minuet
        -- misreports as "Request failed with exit code 1". Drop only that false
        -- positive; all genuine errors/warnings still come through.
        local mutils = require("minuet.utils")
        local orig_notify = mutils.notify
        mutils.notify = function(msg, level, vim_level, opts)
            if type(msg) == "string" and msg:find("Request failed with exit code 1", 1, true) then
                return
            end
            return orig_notify(msg, level, vim_level, opts)
        end

        require("minuet").setup({
            -- One suggestion per trigger: less GPU contention and far fewer cancelled
            -- jobs than the default of 3.
            n_completions = 1,
            -- Local models can be slow to first token on a cold start; the 3s default
            -- truncates legit completions and fires spurious timeouts.
            request_timeout = 5,
            -- Use Ollama's OpenAI-compatible fill-in-the-middle endpoint.
            provider = "openai_fim_compatible",
            provider_options = {
                openai_fim_compatible = {
                    -- Ollama ignores the key, but minuet requires a non-empty one.
                    -- Return a literal dummy via a function so it works on every OS
                    api_key = function() return "ollama" end,
                    name = "Ollama",
                    end_point = "http://localhost:11434/v1/completions",
                    model = "qwen2.5-coder:3b",
                    optional = {
                        max_tokens = 256,
                        top_p = 0.9,
                    },
                },
            },
            -- Inline ghost-text suggestions (Copilot-style) instead of a popup.
            virtualtext = {
                auto_trigger_ft = { "lua", "go", "c", "cpp", "rust", "python", "cs", "java" },
                keymap = {
                    accept = "<C-f>",        -- accept the whole suggestion
                    accept_line = "<C-l>",   -- accept one line
                    accept_n_lines = "<C-b>",
                    dismiss = "<C-e>",
                },
            },
        })
    end,
}

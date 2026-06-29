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
                    -- Return a literal dummy via a function so it works on every OS --
                    -- an env-var name like "APPDATA" only exists on Windows and would
                    -- leave minuet disabled on Linux/macOS.
                    api_key = function() return "ollama" end,
                    name = "Ollama",
                    end_point = "http://localhost:11434/v1/completions",
                    -- Best FIM model per machine. Uncomment the line for the box you're
                    -- on (and `ollama pull` it there first) -- keep only one active.
                    --
                    -- Sapphire Nitro+ 7900XTX 24GB: Codestral -- highest FIM accuracy of
                    -- any local model (#1 on Copilot Arena), 22B / ~13GB fits easily.
                    -- Fallback for snappier MoE latency over peak quality: qwen3-coder:30b.
                    -- model = "codestral",
                    -- GTX 1660 6GB: JetBrains Mellum -- 4B model built purely for code
                    -- completion, fits 6GB. If FIM output looks off (template quirks via
                    -- Ollama), fall back to qwen2.5-coder:3b.
                    model = "qwen2.5-coder:1.5b",
                    -- M5 MacBook Pro (16GB unified): qwen2.5-coder:7b -- light (~5GB),
                    -- fast, FIM-specialized, and leaves headroom for the OS. (Codestral
                    -- would only fit comfortably here with 32GB+ unified RAM.)
                    -- model = "qwen2.5-coder:7b",
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

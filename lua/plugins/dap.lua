return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "williamboman/mason.nvim",
    },
    config = function()
        local dap = require("dap")
        -- Configure Delve (Go debugger)
        dap.adapters.go = {
            type = "server",
            port = "${port}",
            executable = {
                command = "dlv",
                args = { "dap", "-l", "127.0.0.1:${port}" },
            },
        }
        -- C, C++, Rust
        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
        }

        dap.configurations.go = {
            {
                type = "go",
                name = "Debug test",
                program = "${file}",
            },
            {
                type = "go",
                name = "Debug package",
                program = "${workspaceFolder}/**/*.go",
            },
        }
        dap.configurations.c = {
            {
                name = "Launch",
                type = "gdb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                args = {},
                cwd = "${workspaceFolder}",
                stopAtBeginningOfMainSubprogram = false,
            },
            {
                name = "Attach to process",
                type = "gdb",
                request = "attach",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                pid = function()
                    local name = vim.fn.input("Executable name (filter): ")
                    return require("dap.utils").pick_process({filter = name})
                end,
                cwd = "${workspaceFolder}",
            },
        }
        dap.configurations.cpp = dap.configurations.c
        dap.configurations.rust = dap.configurations.c
    end,
}

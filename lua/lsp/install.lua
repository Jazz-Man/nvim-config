local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then return end

local util = require("utils")

local M = {}

function M.install_missing(servers)
    for name, _ in pairs(servers) do
        local server_is_found, server = lsp_installer.get_server(name)

        if server_is_found and not server:is_installed() then
            print("Installing " .. name)
            server:install()
        end
    end
end

function M.setup(servers, options)

    lsp_installer.on_server_ready(function(server)
        local opts = vim.tbl_deep_extend("force", options,
                                         servers[server.name] or {})

        server:setup(opts)
    end)

    M.install_missing(servers)
end

return M

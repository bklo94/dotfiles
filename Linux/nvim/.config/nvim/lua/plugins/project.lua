return {
    "ahmedkhalf/project.nvim",
    init = function()
        require("project_nvim").setup {
            -- your configuration comes her
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }


        -- project.nvim is unmaintained; its find_lsp_root calls the deprecated
        -- vim.lsp.buf_get_clients() (nvim 0.12+), which errors on every BufEnter.
        -- Override with a modern-API equivalent until the plugin is replaced.
        local project_config = require("project_nvim.config")
        local project = require("project_nvim.project")
        project.find_lsp_root = function()
            local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.tbl_contains(filetypes, buf_ft) then
                    if not vim.tbl_contains(project_config.options.ignore_lsp, client.name) then
                        return client.config.root_dir, client.name
                    end
                end
            end
            return nil
        end

        -- Absolutely minimal implementation of fzf-lua based project finder
        -- for fzf-lua, due to request from @KrisWilliams1 (Maybe extended to a
        -- full blown port from the original selector in the future)
        local history = require("project_nvim.utils.history")
        local project = require("project_nvim.project")

        vim.api.nvim_create_user_command("FzfProjects", function()
            local projects = history.get_recent_projects()

            require("fzf-lua").fzf_exec(projects, {
                prompt = "Projects> ",
                actions = {
                    ["default"] = function(selected)
                        if selected and #selected > 0 then
                            local project_path = selected[1]
                            if project.set_pwd(project_path, "fzf-lua") then
                                require("fzf-lua").files()
                            end
                        end
                    end
                }
            })
        end, {})
    end,
    keys = {
        {
            "<leader>fp", "<cmd>FzfProjects<CR>", desc="Find Recent Projects"
        }
    }
}

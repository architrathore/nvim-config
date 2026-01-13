return {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    config = function()
        local orgMenu = require("org-modern.menu")
        -- Setup orgmode
        require("orgmode").setup({

            org_agenda_files = "~/orgfiles/**/*",
            org_default_notes_file = "~/orgfiles/refile.org", -- Default capture location

            ui = {
                input = {
                    use_vim_ui = true,
                },
                menu = {
                    handler = function(data)
                        -- local options = {}
                        -- local options_by_label = {}
                        --
                        -- for _, item in ipairs(data.items) do
                        --     -- Only MenuOption has `key`
                        --     -- Also we don't need `Quit` option because we can close the menu with ESC
                        --     if item.key and item.label:lower() ~= "quit" then
                        --         table.insert(options, item.label)
                        --         options_by_label[item.label] = item
                        --     end
                        -- end
                        --
                        -- local handler = function(choice)
                        --     if not choice then
                        --         return
                        --     end
                        --
                        --     local option = options_by_label[choice]
                        --     if option.action then
                        --         option.action()
                        --     end
                        -- end
                        --
                        -- vim.ui.select(options, {
                        --     propmt = data.propmt,
                        -- }, handler)
                        orgMenu
                            :new({
                                window = { border = "rounded" },
                            })
                            :open(data)
                    end,
                },
            },
            -- workflow states
            org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAITING(w)", "|", "DONE(d)", "CANCELLED(c)" },

            org_capture_templates = {
                -- 1. General Inbox / Refile (The "Dump" location)
                t = {
                    description = "Task (Refile)",
                    template = "* TODO %?\n  %U",
                    target = "~/orgfiles/refile.org",
                },

                -- 2. Immediate TODOs (Straight to todo.org)
                T = {
                    description = "Todo (Immediate)",
                    template = "* TODO %?\n  DEADLINE: %T",
                    target = "~/orgfiles/todo.org",
                },

                -- 3. Meeting Notes / General Notes
                n = {
                    description = "Note",
                    template = "* %? :note:\n  %u",
                    target = "~/orgfiles/notes.org",
                },

                -- 4. Journaling (Date-tree based)
                j = {
                    description = "Journal",
                    template = "* %?\n  %U",
                    target = "~/orgfiles/journal.org",
                    datetree = true, -- Auto-creates Year -> Month -> Day structure
                },

                -- 5. Waiting For (Delegated tasks)
                w = {
                    description = "Waiting For",
                    template = "* WAITING %? :waiting:\n  %U",
                    target = "~/orgfiles/refile.org",
                },
            },
        })
    end,
}

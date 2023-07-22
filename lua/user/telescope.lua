local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

telescope.setup {
  defaults = {

    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    file_ignore_patterns = { ".git/", "node_modules" },

    mappings = {
      n = {
        ["<C-d>"] = actions.delete_buffer,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-x>"] = actions.select_tab,
        ["<Esc>"] = actions.close,
      },
      i = {
        ["<C-d>"] = actions.delete_buffer,
        ["<Down>"] = actions.cycle_history_next,
        ["<Up>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true
    }
  }
}

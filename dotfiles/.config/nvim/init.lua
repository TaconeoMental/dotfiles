vim.g.python3_host_prog = vim.fn.expand("~/.venvs/nvim/bin/python")

vim.g.mapleader = ","

vim.opt.encoding = "utf-8"
vim.opt.termguicolors = true
vim.cmd("syntax on")

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.showmode = false
vim.opt.ruler = true
vim.opt.visualbell = true

vim.opt.textwidth = 79
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.laststatus = 3

if vim.fn.exists("+guioptions") == 1 then
  vim.opt.guioptions:remove({ "r", "R", "l", "L" })
end

-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Navegación splits
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Tabs
map("n", ">", "gt", opts)
map("n", "<", "gT", opts)

map("n", "<leader>1", "1gt", opts)
map("n", "<leader>2", "2gt", opts)
map("n", "<leader>3", "3gt", opts)
map("n", "<leader>4", "4gt", opts)
map("n", "<leader>5", "5gt", opts)
map("n", "<leader>6", "6gt", opts)
map("n", "<leader>7", "7gt", opts)
map("n", "<leader>8", "8gt", opts)
map("n", "<leader>9", "9gt", opts)
map("n", "<leader>0", ":tablast<CR>", opts)

-- Buffers vacíos
map("n", "<leader>os", ":vnew<CR>", opts)
map("n", "<leader>oi", ":new<CR>", opts)

-- Bloquear flechas
map("n", "<Up>", "<nop>", opts)
map("n", "<Down>", "<nop>", opts)
map("n", "<Left>", "<nop>", opts)
map("n", "<Right>", "<nop>", opts)

-- jj para salir
map("i", "jj", "<Esc>", opts)
map("v", "jj", "<Esc><Esc>", opts)

-- Autocmds
-- Números relativos solo en buffer activo
local aug = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = aug,
  callback = function()
    vim.wo.number = true
    vim.wo.relativenumber = true
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = aug,
  callback = function()
    vim.wo.relativenumber = false
  end,
})

-- Python tweaks
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.completeopt:remove("preview")
    vim.opt_local.colorcolumn = "80"
  end,
})

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("n", "<leader>tw", function()
  vim.wo.wrap = not vim.wo.wrap
  -- esto hace que el wrap se vea más “humano”
  vim.wo.linebreak = vim.wo.wrap
  vim.notify("wrap: " .. (vim.wo.wrap and "ON" or "OFF"))
end, { noremap = true, silent = true })

-- Plugins
require("lazy").setup({
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
        update_focused_file = { enable = true },
        renderer = { icons = { show = { git = true, file = true, folder = true, folder_arrow = true } } },
      })
      vim.keymap.set("n", "<leader>n", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
      -- salir si el árbol es la última ventana
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          local wins = vim.api.nvim_list_wins()
          if #wins == 1 then
            local buf = vim.api.nvim_get_current_buf()
            local ft = vim.bo[buf].filetype
            if ft == "NvimTree" then
              vim.cmd("quit")
            end
          end
        end,
      })
    end
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local theme = {
        normal = {
          a = { fg = "#ffffff", bg = "#2b1f3a", bold = true },
          b = { fg = "#cbd3e3", bg = "#141824" },
          c = { fg = "#a8b0c0", bg = "#0f121a" },
        },
        insert  = { a = { fg = "#ffffff", bg = "#224b3a", bold = true } },
        visual  = { a = { fg = "#ffffff", bg = "#4b2244", bold = true } },
        replace = { a = { fg = "#ffffff", bg = "#4b2a22", bold = true } },
        inactive = {
          a = { fg = "#7e8698", bg = "#0f121a", bold = true },
          b = { fg = "#7e8698", bg = "#0f121a" },
          c = { fg = "#7e8698", bg = "#0f121a" },
        },
      }

      require("lualine").setup({
        options = {
          theme = theme,
          icons_enabled = true,
          section_separators = "",
          component_separators = "",
        },
      })
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "¦" },
        scope = { enabled = false },
      })
    end
  },

  {
    'jesseleite/nvim-noirbuddy',
    dependencies = {
      { 'tjdevries/colorbuddy.nvim' }
    },
    lazy = false,
    opts = {
      colors = {
        background = '#0a0e14',
      }
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end
  },

  "yuttie/comfortable-motion.vim",
  "matze/vim-move",
  "mg979/vim-visual-multi",
  "NoahTheDuke/vim-just",
  "Chiel92/vim-autoformat",

  -- Lenguajes
  "hynek/vim-python-pep8-indent",
  "vim-python/python-syntax",
  "vim-ruby/vim-ruby",
  "sudar/vim-arduino-syntax",
  "sheerun/vim-polyglot",

  { "junegunn/fzf", build = "./install --bin" },
  "junegunn/fzf.vim",
})

-- python-syntax
vim.g.python_highlight_all = 1

-- vim-move
vim.g.move_key_modifier = "S"
vim.g.move_key_modifier_visualmode = "S"

-- autoformat
vim.keymap.set("n", "<F5>", ":Autoformat<CR>", { noremap = true, silent = true })

-- FZF mappings
vim.keymap.set("n", "<leader>sf", ":Files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sl", ":Lines<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sw", ":Windows<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sb", ":Buffers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ss", ":Rg<CR>", { noremap = true, silent = true })

vim.g.fzf_action = {
  ["ctrl-t"] = "tab split",
  ["ctrl-i"] = "split",
  ["ctrl-s"] = "vsplit",
}

-- Colorscheme
-- vim.cmd("colorscheme pseudopink")

local function ui_colors()
  vim.api.nvim_set_hl(0, "TabLine",     { fg = "#a8b0c0", bg = "#141824" })
  vim.api.nvim_set_hl(0, "TabLineSel",  { fg = "#ffffff", bg = "#2b1f3a", bold = true })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#0f121a" })

  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#23283a" })
end

ui_colors()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = ui_colors,
})


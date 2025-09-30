local M = {}

-- Default workspaces configuration
M.config = {
  default = "Mahadev",
  spaces = {
    {
      name = "Mahadev",
      path = os.getenv("HOME") .. "/Desktop",
    },
    -- Add your projects here:
    -- {
    --   name = "dotfiles",
    --   path = os.getenv("HOME") .. "/.dotfiles"
    -- },
    -- {
    --   name = "work",
    --   path = os.getenv("HOME") .. "/Work",
    --   tabs = { "frontend", "backend", "docs" }
    -- },
  }
}

return M

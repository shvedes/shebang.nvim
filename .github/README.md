# shebang.nvim

A simple Neovim plugin written in Lua that automatically inserts a shebang line
when editing a new file.

## Installation

Lazy:
```lua
{
    "shvedes/shebang.nvim",
    event = "BufNewFile"
}
```

## Customization

You can set custom shells by setting the global variables `shebang_shells`,
`shebang_commands` and `shebang_ignore_dirs`:

### lua

```lua
vim.g.shebang_ignore_dirs = {
    "~/.config/nvim"
    "ignored_dir_2"
}

vim.g.shebang_commands = {
    py = '/usr/bin/python3.9'
}

vim.g.shebang_shells = {
    py = 'python3.9'
}
```

The difference between the two is that the executables in `shebang_shells` have
must be in the `PATH` environment variable, while the in `shebang_commands` you
can use full paths to the executable.

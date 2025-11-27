local function get_var(var_name)
  local s, v = pcall(function()
    return vim.api.nvim_get_var(var_name)
  end)
  if s then return v else return nil end
end

local function normalize_path(path)
  local expanded = vim.fn.expand(path)
  return vim.fn.fnamemodify(expanded, ":p")
end

local function is_ignored_dir(filepath, ignore_dirs)
  if not ignore_dirs then
    return false
  end

  local abs_file = normalize_path(filepath)

  for _, dir in ipairs(ignore_dirs) do
    local abs_dir = normalize_path(dir)

    if not abs_dir:match("/$") then
      abs_dir = abs_dir .. "/"
    end

    if vim.startswith(abs_file, abs_dir) then
      return true
    end
  end

  return false
end

local function insert_shebang()
  local shells = {
    awk = "awk",
    hs = "runhaskell",
    jl = "julia",
    lua = "lua",
    m = "octave",
    mak = "make",
    php = "php",
    pl = "perl",
    py = "python3",
    r = "Rscript",
    rb = "ruby",
    scala = "scala",
    sh = "bash",
    tcl = "tclsh",
    tk = "wish",
  }

  local ext = vim.fn.expand("%:e")
  local filepath = vim.fn.expand("%:p")

  local ignore_dirs = get_var("shebang_ignore_dirs")

  if is_ignored_dir(filepath, ignore_dirs) then
    return
  end

  local custom_commands = get_var("shebang_commands")
  local custom_shells = get_var("shebang_shells")

  local shebang = nil

  if custom_commands and custom_commands[ext] then
    shebang = custom_commands[ext]
  elseif custom_shells and custom_shells[ext] then
    shebang = "/usr/bin/env " .. custom_shells[ext]
  elseif shells[ext] then
    shebang = "/usr/bin/env " .. shells[ext]
  end

  if shebang then
    vim.cmd [[ autocmd BufWritePost *.* :autocmd VimLeave * :!chmod u+x % ]]
    vim.api.nvim_put({ "#!" .. shebang }, "", true, true)
    vim.fn.append(1, "")
    vim.fn.cursor(2, 0)
  end
end

return {
  insert_shebang = insert_shebang,
}

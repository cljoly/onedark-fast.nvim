local function common()
  vim.api.nvim_set_hl(0, "grp1", {fg = "#AA222", bg = "#BB9999"})
  vim.api.nvim_set_hl(0, "grp2", {fg = "#AA333", bg = "#BB9999"})
  vim.api.nvim_set_hl(0, "grp3", {fg = "#AA444", bg = "#BB9999"})
  vim.api.nvim_set_hl(0, "grp4", {fg = "#AA555", bg = "#BB9999"})
  vim.api.nvim_set_hl(0, "grp5", {fg = "#AA666", bg = "#BB9999"})
  vim.api.nvim_set_hl(0, "grp6", {fg = "#AA777", bg = "#BB9999"})
  return true
end
local function colorscheme()
  print(common, 4)
  common()
  return print("Hi")
end
return {colorscheme = colorscheme}

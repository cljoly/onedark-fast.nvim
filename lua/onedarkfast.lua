local function common()
  print("grp1", "red2")
  print("grp2", "red3")
  print("grp3", "red4")
  print("grp4", "red5")
  print("grp5", "red6")
  print("grp6", "red7")
  return true
end
local function colorscheme()
  print(common, 4)
  common()
  return print("Hi")
end
return {colorscheme = colorscheme}

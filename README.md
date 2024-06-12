<!-- insert
---
title: "onedark-fast.nvim"
date: 2024-06-12T22:02:37
description: "Fast OneDark colorscheme for neovim"
repo_url: "https://github.com/cljoly/onedark-fast.nvim"
aliases:
- /onedark-fast.nvim
tags:
- NeoVim
- Lua
- Plugin
- Colorscheme
---
{{< github_badge >}}

{{< rawhtml >}}
<div class="badges">
{{< /rawhtml >}}
end_insert -->
<!-- remove -->
# onedark-fast.nvim
<!-- end_remove -->

![Neovim version](https://img.shields.io/badge/Neovim-0.7+-57A143?style=flat&logo=neovim) [![](https://img.shields.io/badge/powered%20by-riss-lightgrey)](https://cj.rs/riss)

<!-- insert
{{< rawhtml >}}
</div>
{{< /rawhtml >}}
end_insert -->

Port of [onedark](https://github.com/navarasu/onedark.nvim) to [Fennel][], so that we generate fast Lua code.

## Work in Progress

I have been daily driving this for a few years, but there may still be bugs. A number of plugins are not supported (mostly because I don’t use them). At some point, I would like to provide easier personnalisation, but it’s not quite there yet. If you want to customize this colorscheme, you will have to change the [Fennel][] code and recompile it.

A few highlight group might still refer to NVim default colorscheme. They can be found by running `:highlight` and then searching the output for `Nvim`.

[Fennel]: https://fennel-lang.org/

;; The GPLv3 License (GPLv3)
;;
;; Copyright (c) 2022 Clément Joly
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Lesser General Public License as published
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This library is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Lesser General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(macro family-function [hl-family-name hl-family]
  (local color-defs (require :color-definitions))
  (local utils (require :utils))
  ;; Basic checks
  (assert-compile (sym? hl-family-name) "Require a hl-family-name string"
                  hl-family-name)
  (assert-compile (and (table? hl-family) (not (sequence? hl-family)))
                  "Require a hl-family list" hl-family)
  ;; Build the list of highlight definitions
  (let [code (icollect [hl-group hl-def (pairs hl-family)]
               (do
                 (each [_ hl-key (pairs [:fg :bg :sp])]
                   (-?>> (. hl-def hl-key)
                         ;; TODO make the palette configurable
                         (color-defs.find-color :dark)
                         (tset hl-def hl-key)))
                 (utils.check-hl-def hl-def)
                 `(vim.api.nvim_set_hl 0 ,hl-group ,hl-def)))]
    (table.insert code true) ; Returning a boolean is probably cheaper
    `(fn ,hl-family-name
       []
       ,(unpack code))))

(family-function common {;; TODO Put the transparent & ending_tildes support back?
              :Normal {:fg :fg :bg :bg0}
              :Terminal {:fg :fg :bg :bg0}
              :EndOfBuffer {:fg :bg0 :bg :bg0}
              :FoldColumn {:fg :fg :bg :bg1}
              :Folded {:fg :fg :bg :bg1}
              :SignColumn {:fg :fg :bg :bg0}
              :ToolbarLine {:fg :fg}
              :Cursor {:reverse true}
              :vCursor {:reverse true}
              :iCursor {:reverse true}
              :lCursor {:reverse true}
              :CursorIM {:reverse true}
              :CursorColumn {:bg :bg1}
              :CursorLine {:bg :bg1}
              :ColorColumn {:bg :bg1}
              :CursorLineNr {:fg :fg}
              :LineNr {:fg :grey}
              :Conceal {:fg :grey :bg :bg1}
              :DiffAdd {:fg :none :bg :diff_add}
              :DiffChange {:fg :none :bg :diff_change}
              :DiffDelete {:fg :none :bg :diff_delete}
              :DiffText {:fg :none :bg :diff_text}
              :DiffAdded {:fg :green}
              :DiffRemoved {:fg :red}
              :DiffFile {:fg :cyan}
              :DiffIndexLine {:fg :grey}
              :Directory {:fg :blue}
              :ErrorMsg {:fg :red :bold true}
              :WarningMsg {:fg :yellow :bold true}
              :MoreMsg {:fg :blue :bold true}
              :IncSearch {:fg :bg0 :bg :orange}
              :Search {:fg :bg0 :bg :bg_yellow}
              :Substitute {:fg :bg0 :bg :green}
              :MatchParen {:fg :none :bg :grey}
              :NonText {:fg :grey}
              :Whitespace {:fg :grey}
              :SpecialKey {:fg :grey}
              :Pmenu {:fg :fg :bg :bg1}
              :PmenuSbar {:fg :none :bg :bg1}
              :PmenuSel {:fg :bg0 :bg :bg_blue}
              :WildMenu {:fg :bg0 :bg :blue}
              :PmenuThumb {:fg :none :bg :grey}
              :Question {:fg :yellow}
              :SpellBad {:fg :red :underline true :sp :red}
              :SpellCap {:fg :yellow :underline true :sp :yellow}
              :SpellLocal {:fg :blue :underline true :sp :blue}
              :SpellRare {:fg :purple :underline true :sp :purple}
              :StatusLine {:fg :fg :bg :bg2}
              :StatusLineTerm {:fg :fg :bg :bg2}
              :StatusLineNC {:fg :grey :bg :bg1}
              :StatusLineTermNC {:fg :grey :bg :bg1}
              :TabLine {:fg :fg :bg :bg1}
              :TabLineFill {:fg :grey :bg :bg1}
              :TabLineSel {:fg :bg0 :bg :fg}
              :VertSplit {:fg :bg3}
              :Visual {:bg :bg3}
              :VisualNOS {:fg :none :bg :bg2 :underline true}
              :QuickFixLine {:fg :blue :underline true}
              :Debug {:fg :yellow}
              :debugPC {:fg :bg0 :bg :green}
              :debugBreakpoint {:fg :bg0 :bg :red}
              :ToolbarButton {:fg :bg0 :bg :bg_blue}
              :FloatBorder {:fg :grey :bg :bg1}
              :NormalFloat {:fg :fg :bg :bg1}})

(macro unroll2 [hl-group]
  `(print ,hl-group 4))

(fn colorscheme []
  (unroll2 common)
  (common)
  (print :OnedarkLoaded))

{: colorscheme}


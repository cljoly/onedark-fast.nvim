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

(macro family-lambda [hl-family-name hl-family palette]
  (local color-defs (require :color-definitions))
  (local utils (require :utils))
  ;; Basic checks
  (-> hl-family-name (sym?)
      (assert-compile "Require a hl-family-name sym" hl-family-name))
  (assert-compile (and (table? hl-family) (not (sequence? hl-family)))
                  "Require a hl-family list" hl-family)
  ;; Build the list of highlight definitions
  (let [code (icollect [hl-group hl-def (pairs hl-family)]
               (do
                 (assert-compile (-?> hl-group (type) (= :string))
                                 "Require a string for hl-group" hl-group)
                 (assert-compile (or (table? hl-def) (list? hl-def))
                                 "Require a table or code list for hl-def"
                                 hl-def)
                 (each [_ hl-key (pairs [:fg :bg :sp])]
                   (-?>> (. hl-def hl-key)
                         (color-defs.find-color palette)
                         (tset hl-def hl-key)))
                 (utils.check-hl-def hl-def)
                 `(vim.api.nvim_set_hl 0 ,hl-group ,hl-def)))]
    (table.insert code true) ; Returning a boolean is probably cheaper
    `(fn []
       ,(unpack code))))

(macro μ [data]
  "μ stands for module.
  This macro defines the module for this whole file, listing families in functions and adding a function to call them all"
  (-> data (table?) (assert-compile "μ requires a table"))
  (let [{: palette : families} data]
    ;; Basic checks
    (-> palette (type) (= :string)
        (assert-compile "Require a palette string" palette))
    (-> families (table?) (and (not (sequence? families)))
        (assert-compile "Require a families list" families))
    `(values (do
               ;; First collect all the hl-famlies in a module
               (local M#
                      ,(collect [hl-family-name hl-def (pairs families)]
                         (values hl-family-name
                                 `(family-lambda hl-family-name# ,hl-def
                                                 ,palette))))
               ;; Then add the colorscheme function that calls every hl-family
               (tset M# :colorscheme
                     (fn []
                       ,(unpack (icollect [hl-family-name _ (pairs families)]
                                  `((. M# ,hl-family-name))))))
               M#))))

(μ {:palette :dark
     :families {:common {:Normal {:fg :fg :bg :bg0}
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
                         :NormalFloat {:fg :fg :bg :bg1}}
                :common {:Normal {:fg :fg :bg :bg0}
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
                         :NormalFloat {:fg :fg :bg :bg1}}
                :syntax {:String {:fg :green}
                         :Character {:fg :orange}
                         :Number {:fg :orange}
                         :Float {:fg :orange}
                         :Boolean {:fg :orange}
                         :Type {:fg :yellow}
                         :Structure {:fg :yellow}
                         :StorageClass {:fg :yellow}
                         :Identifier {:fg :red}
                         :Constant {:fg :cyan}
                         :PreProc {:fg :purple}
                         :PreCondit {:fg :purple}
                         :Include {:fg :purple}
                         :Keyword {:fg :purple}
                         :Define {:fg :purple}
                         :Typedef {:fg :purple}
                         :Exception {:fg :purple}
                         :Conditional {:fg :purple}
                         :Repeat {:fg :purple}
                         :Statement {:fg :purple}
                         :Macro {:fg :red}
                         :Error {:fg :purple}
                         :Label {:fg :purple}
                         :Special {:fg :red}
                         :SpecialChar {:fg :red}
                         :Function {:fg :blue}
                         :Operator {:fg :purple}
                         :Title {:fg :cyan}
                         :Tag {:fg :green}
                         :Delimiter {:fg :light_grey}
                         :Comment {:fg :grey :italic true}
                         :SpecialComment {:fg :grey :italic true}
                         :Todo {:fg :red :italic true}}
                :treesitter {:TSAnnotation {:fg :fg}
                             :TSAttribute {:fg :cyan}
                             :TSBoolean {:fg :orange}
                             :TSCharacter {:fg :orange}
                             :TSComment {:fg :grey :italic true}
                             :TSConditional {:fg :purple}
                             :TSConstant {:fg :orange}
                             :TSConstBuiltin {:fg :orange}
                             :TSConstMacro {:fg :orange}
                             :TSConstructor {:fg :yellow :bold true}
                             :TSError {:fg :fg}
                             :TSException {:fg :purple}
                             :TSField {:fg :cyan}
                             :TSFloat {:fg :orange}
                             :TSFunction {:fg :blue}
                             :TSFuncBuiltin {:fg :cyan}
                             :TSFuncMacro {:fg :cyan}
                             :TSInclude {:fg :purple}
                             :TSKeyword {:fg :purple}
                             :TSKeywordFunction {:fg :purple}
                             :TSKeywordOperator {:fg :purple}
                             :TSLabel {:fg :red}
                             :TSMethod {:fg :blue}
                             :TSNamespace {:fg :yellow}
                             :TSNone {:fg :fg}
                             :TSNumber {:fg :orange}
                             :TSOperator {:fg :fg}
                             :TSParameter {:fg :red}
                             :TSParameterReference {:fg :fg}
                             :TSProperty {:fg :cyan}
                             :TSPunctDelimiter {:fg :light_grey}
                             :TSPunctBracket {:fg :light_grey}
                             :TSPunctSpecial {:fg :red}
                             :TSRepeat {:fg :purple}
                             :TSString {:fg :green}
                             :TSStringRegex {:fg :orange}
                             :TSStringEscape {:fg :red}
                             :TSSymbol {:fg :cyan}
                             :TSTag {:fg :red}
                             :TSTagDelimiter {:fg :red}
                             :TSText {:fg :fg}
                             :TSStrong {:fg :fg :bold true}
                             :TSEmphasis {:fg :fg :italic true}
                             :TSUnderline {:fg :fg :underline true}
                             :TSStrike {:fg :fg :strikethrough true}
                             :TSTitle {:fg :orange :bold true}
                             :TSLiteral {:fg :green}
                             :TSURI {:fg :cyan :underline true}
                             :TSMath {:fg :fg}
                             :TSTextReference {:fg :blue}
                             :TSEnviroment {:fg :fg}
                             :TSEnviromentName {:fg :fg}
                             :TSNote {:fg :fg}
                             :TSWarning {:fg :fg}
                             :TSDanger {:fg :fg}
                             :TSType {:fg :yellow}
                             :TSTypeBuiltin {:fg :orange}
                             :TSVariable {:fg :fg}
                             :TSVariableBuiltin {:fg :red}}
                :lsp {:LspCxxHlGroupEnumConstant {:fg :orange}
                      :LspCxxHlGroupMemberVariable {:fg :orange}
                      :LspCxxHlGroupNamespace {:fg :blue}
                      :LspCxxHlSkippedRegion {:fg :grey}
                      :LspCxxHlSkippedRegionBeginEnd {:fg :red}
                      ;;
                      :DiagnosticError {:fg :red}
                      :DiagnosticHint {:fg :purple}
                      :DiagnosticInfo {:fg :cyan}
                      :DiagnosticWarn {:fg :yellow}
                      ;;
                      :DiagnosticVirtualTextError {:bg :extra_dark_red
                                                   :fg :dark_red}
                      :DiagnosticVirtualTextWarn {:bg :extra_dark_yellow
                                                  :fg :dark_yellow}
                      :DiagnosticVirtualTextInfo {:bg :extra_dark_cyan
                                                  :fg :dark_cyan}
                      :DiagnosticVirtualTextHint {:bg :extra_dark_purple
                                                  :fg :dark_purple}
                      ;;
                      :DiagnosticUnderlineError {:undercurl true :sp :red}
                      :DiagnosticUnderlineHint {:undercurl true :sp :purple}
                      :DiagnosticUnderlineInfo {:undercurl true :sp :blue}
                      :DiagnosticUnderlineWarn {:undercurl true :sp :yellow}
                      ;;
                      :LspReferenceText {:bg :bg2}
                      :LspReferenceWrite {:bg :bg2}
                      :LspReferenceRead {:bg :bg2}
                      ;;
                      :LspCodeLens {:fg :grey :italic true}
                      :LspCodeLensSeparator {:fg :grey}
                      ;;
                      :LspDiagnosticsDefaultError {:link :DiagnosticError}
                      :LspDiagnosticsDefaultHint {:link :DiagnosticHint}
                      :LspDiagnosticsDefaultInformation {:link :DiagnosticInfo}
                      :LspDiagnosticsDefaultWarning {:link :DiagnosticWarn}
                      :LspDiagnosticsUnderlineError {:link :DiagnosticUnderlineError}
                      :LspDiagnosticsUnderlineHint {:link :DiagnosticUnderlineHint}
                      :LspDiagnosticsUnderlineInformation {:link :DiagnosticUnderlineInfo}
                      :LspDiagnosticsUnderlineWarning {:link :DiagnosticUnderlineWarn}
                      :LspDiagnosticsVirtualTextError {:link :DiagnosticVirtualTextError}
                      :LspDiagnosticsVirtualTextWarning {:link :DiagnosticVirtualTextWarn}
                      :LspDiagnosticsVirtualTextInformation {:link :DiagnosticVirtualTextInfo}
                      :LspDiagnosticsVirtualTextHint {:link :DiagnosticVirtualTextHint}}
                ;; Languages
                :markdown {:markdownBlockquote {:fg :grey}
                           :markdownBold {:fg :none :bold true}
                           :markdownBoldDelimiter {:fg :grey}
                           :markdownCode {:fg :green}
                           :markdownCodeBlock {:fg :green}
                           :markdownCodeDelimiter {:fg :yellow}
                           :markdownH1 {:fg :red :bold true}
                           :markdownH2 {:fg :purple :bold true}
                           :markdownH3 {:fg :orange :bold true}
                           :markdownH4 {:fg :red :bold true}
                           :markdownH5 {:fg :purple :bold true}
                           :markdownH6 {:fg :orange :bold true}
                           :markdownHeadingDelimiter {:fg :grey}
                           :markdownHeadingRule {:fg :grey}
                           :markdownId {:fg :yellow}
                           :markdownIdDeclaration {:fg :red}
                           :markdownItalic {:fg :none :italic true}
                           :markdownItalicDelimiter {:fg :grey :italic true}
                           :markdownLinkDelimiter {:fg :grey}
                           :markdownLinkText {:fg :red}
                           :markdownLinkTextDelimiter {:fg :grey}
                           :markdownListMarker {:fg :red}
                           :markdownOrderedListMarker {:fg :red}
                           :markdownRule {:fg :purple}
                           :markdownUrl {:fg :blue :underline true}
                           :markdownUrlDelimiter {:fg :grey}
                           :markdownUrlTitleDelimiter {:fg :green}}
                ;; Plugins
                :cmp {:CmpItemAbbr {:fg :fg}
                      :CmpItemAbbrDeprecated {:fg :light_grey
                                              :strikethrough true}
                      :CmpItemAbbrMatch {:fg :cyan}
                      :CmpItemAbbrMatchFuzzy {:fg :cyan :underline true}
                      :CmpItemMenu {:fg :light_grey}
                      :CmpItemKind {:fg :purple}
                      :CmpItemKindDefault {:fg :purple}
                      :CmpItemKindClass {:fg :yellow}
                      :CmpItemKindColor {:fg :green}
                      :CmpItemKindConstant {:fg :orange}
                      :CmpItemKindConstructor {:fg :blue}
                      :CmpItemKindEnum {:fg :purple}
                      :CmpItemKindEnumMember {:fg :yellow}
                      :CmpItemKindEvent {:fg :yellow}
                      :CmpItemKindField {:fg :purple}
                      :CmpItemKindFile {:fg :blue}
                      :CmpItemKindFolder {:fg :orange}
                      :CmpItemKindFunction {:fg :blue}
                      :CmpItemKindInterface {:fg :green}
                      :CmpItemKindKeyword {:fg :cyan}
                      :CmpItemKindMethod {:fg :blue}
                      :CmpItemKindModule {:fg :orange}
                      :CmpItemKindOperator {:fg :red}
                      :CmpItemKindProperty {:fg :cyan}
                      :CmpItemKindReference {:fg :orange}
                      :CmpItemKindSnippet {:fg :red}
                      :CmpItemKindStruct {:fg :purple}
                      :CmpItemKindText {:fg :light_grey}
                      :CmpItemKindTypeParameter {:fg :red}
                      :CmpItemKindUnit {:fg :green}
                      :CmpItemKindValue {:fg :orange}
                      :CmpItemKindVariable {:fg :purple}}
                :gitsigns {:GitSignsAdd {:fg :green}
                           :GitSignsAddLn {:fg :green}
                           :GitSignsAddNr {:fg :green}
                           :GitSignsChange {:fg :blue}
                           :GitSignsChangeLn {:fg :blue}
                           :GitSignsChangeNr {:fg :blue}
                           :GitSignsDelete {:fg :red}
                           :GitSignsDeleteLn {:fg :red}
                           :GitSignsDeleteNr {:fg :red}}
                :telescope {:TelescopeBorder {:fg :red}
                            :TelescopePromptBorder {:fg :cyan}
                            :TelescopeResultsBorder {:fg :cyan}
                            :TelescopePreviewBorder {:fg :cyan}
                            :TelescopeMatching {:fg :orange :bold true}
                            :TelescopePromptPrefix {:fg :green}
                            :TelescopeSelection {:bg :bg2}
                            :TelescopeSelectionCaret {:fg :yellow}}}})


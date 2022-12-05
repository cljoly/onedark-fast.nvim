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

(macro Ψ [hl-family-name hl-family]
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
                         (color-defs.find-color)
                         (tset hl-def hl-key)))
                 (utils.check-hl-def hl-def)
                 `(vim.api.nvim_set_hl 0 ,hl-group ,hl-def)))]
    (table.insert code true) ; Returning a boolean is probably cheaper
    `(fn ,hl-family-name
       []
       ,(unpack code))))

(Ψ common {:grp1 {:fg :red2 :bg :bg0 :blend 99}
            :grp2 {:fg :red3 :bg :bg0 :italic true}
            :grp3 {:fg :red4 :bg :bg0}
            :grp4 {:fg :red5 :bg :bg0}
            :grp5 {:fg :red6 :bg :bg0}
            :grp6 {:fg :red7 :bg :bg0}})

(macro unroll2 [hl-group]
  `(print ,hl-group 4))

(fn colorscheme []
  (unroll2 common)
  (common)
  (print :Hi))

{: colorscheme}


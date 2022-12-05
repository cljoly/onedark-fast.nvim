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

;; Module imported in Fennel, there should be no corresponding Lua module
;; emitted for this file

(local hl-map-key-constraints
       {:blend "between 0 and 100"
        :bold "a boolean"
        :standout "a boolean"
        :underline "a boolean"
        :undercurl "a boolean"
        :underdouble "a boolean"
        :underdotted "a boolean"
        :underdashed "a boolean"
        :strikethrough "a boolean"
        :italic "a boolean"
        :reverse "a boolean"
        :nocombine "a boolean"})

(fn perform-check [map key constraint]
  "Check for a particular constraint"
  (let [map-val (?. map key)]
    (if (= map-val nil) true
        ((match constraint
           "a boolean" #(or (= $1 true) (= $1 false))
           "between 0 and 100" #(<= 0 $1 100) _
           (assert #false "Unknown constraint")) map-val))))

(lambda check-hl-def [map]
  "Checks that the map follows the constraints given in `:help nvim_set_hl` for {vals}. Does not check for fg, bg, sp however."
  (each [key constraint (pairs hl-map-key-constraints)]
    (assert (perform-check map key constraint) (.. key " must be " constraint))))

{: check-hl-def}


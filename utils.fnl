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
    (if (= map-val nil)
        true
        ((match constraint
           "a boolean" #(-> (type $1) (= :boolean))
           "between 0 and 100" #(<= 0 $1 100)
           _ (assert #false "Unknown constraint")) map-val))))

(lambda check-hl-def [map]
  "Checks that the map follows the constraints given in `:help nvim_set_hl` for {vals}. Does not check for fg, bg, sp however."
  (each [key constraint (pairs hl-map-key-constraints)]
    (assert (perform-check map key constraint) (.. key " must be " constraint))))

(fn hex-parse [hex_string]
  "Expects an hexadecimal number, starting with a # and acceptable to tonumber
  once the # is removed. Returns nil when given nil"
  (-?> hex_string (string.sub 2) (tonumber 16)))

(lambda blend [fg bg α]
  "Takes fg and bg as numbers, and blend them with α.
  0 <= α <= 1, α == 1 => fg, α == 0 => bg"
  (-?> (+ (* α fg) (* (- 1 α) bg)) ; TODO Correct for blue “overflowing” into green? (it’s not a problem as
       ; long as bg == 0000, and in other cases)
       (math.max 0)
       (math.min 16777215) ; max 0xFFFFFF
       (math.floor)))

{: check-hl-def : hex-parse : blend }

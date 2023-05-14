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

(local palette (require :palette))

(fn acceptable-color [color]
  "Return nil if the color is an acceptable bare color"
  (match color
    :none color
    :fg color
    :bg color
    _ nil))

(lambda find-color [palette-name color-name]
  "Inline color values"
  (assert-compile (= (type palette-name) :string)
                  "palette-name should be a string" palette-name)
  (assert-compile (= (type palette-name) :string)
                  "palette-name should be a string" palette-name)
  (or (?. palette palette-name color-name) (acceptable-color color-name)
      (assert-compile false (.. "Unknown color: " color-name) color-name)))

{: find-color}


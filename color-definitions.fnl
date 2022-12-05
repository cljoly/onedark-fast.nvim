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

(lambda find-color [color-name]
  "Inline color values
  TODO support variants"
  (match color-name
    :red2 "#AA222"
    :red3 "#AA333"
    :red4 "#AA444"
    :red5 "#AA555"
    :red6 "#AA666"
    :red7 "#AA777"
    :bg0 "#BB9999"
    _ (assert-compile false (.. "Unknown color: " color-name))))

{: find-color}


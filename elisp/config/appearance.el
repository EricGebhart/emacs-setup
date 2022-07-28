;;; package --- Summary
;;; Commentary:
;;; Code:

;;make sure ansi colour character escapes are honoured
(require 'ansi-color)
(ansi-color-for-comint-mode-on)

(setq font-lock-maximum-decoration t
      color-theme-is-global t)

;; Line-wrapping
(set-default 'fill-column 72)

;;get rid of clutter, menus, scrollbars, etc.
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;remove bells
(setq ring-bell-function 'ignore)

;; font settng functions
(require 'cl-lib)

(set-frame-font "-*-Source Code Pro-normal-normal-normal-*-32-*-*-*-m-0-iso10646-1")

;;make fringe bigger
(if (fboundp 'fringe-mode)
    (fringe-mode 10))
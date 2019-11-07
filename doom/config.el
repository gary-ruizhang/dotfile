;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;;;;;;;;;;;;;;;;;;;;;
;;; Basic Settings ;;;
;;;;;;;;;;;;;;;;;;;;;;

;; delete trailing space after save
(add-hook! 'before-save-hook 'delete-trailing-whitespace)

;; maximize screen on start up
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;;;;;;;;;
;;; UI ;;;
;;;;;;;;;;

(setq doom-font (font-spec :family "Operator Mono SSm Lig" :size 30))

(load-theme 'doom-solarized-light)

;;;;;;;;;;;;;;;;;;;;
;;; Key Mappings ;;;
;;;;;;;;;;;;;;;;;;;;

;; s map to evil-snipe by default in doom emacs, disable this to make
;; s remapping work
(after! evil-snipe
  (evil-snipe-mode -1))

(map! :n ";" 'evil-ex
      :n "/" 'swiper
      :n "'" 'evil-goto-mark
      :n "`" 'evil-goto-mark-line
      ;; enable only when line wrap set
      ;; :n "j" 'evil-next-visual-line
      ;; :n "k" 'evil-previous-visual-line
      :n "s" 'avy-goto-char-2
      :gi "C-h" 'backward-delete-char)

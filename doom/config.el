;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;;;;;;;;;;;;;;;;;;;;;
;;; Basic Settings ;;;
;;;;;;;;;;;;;;;;;;;;;;

;; delete trailing space after save
(add-hook! 'before-save-hook 'delete-trailing-whitespace)

;; maximize screen on start up
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq-default indent-tabs-mode nil)

(remove-hook 'tty-setup-hook 'doom-init-clipboard-in-tty-emacs-h)

;;;;;;;;;;
;;; UI ;;;
;;;;;;;;;;

(+global-word-wrap-mode t)

;; emacs doesn't support ligature natively
(setq doom-font (font-spec :family "Operator Mono SSm" :size 30))

(load-theme 'doom-nord t)

;;;;;;;;;;;;;
;;; Shell ;;;
;;;;;;;;;;;;;

(setq eshell-cmpl-ignore-case t)

;;;;;;;;;;;;;;;;;;;;
;;; Key Mappings ;;;
;;;;;;;;;;;;;;;;;;;;

;; s map to evil-snipe by default in doom emacs, disable this to make
;; s remapping work
(after! evil-snipe
  (evil-snipe-mode -1))

;; ; -> ; when enter f start evil-snipe, otherwise ; -> :
(map! :n ";" 'evil-ex
      ;; use swiper to replace default search
      ;; esc clear highlight when finish search
      :n "/" 'swiper
      :n "'" 'evil-goto-mark
      :n "`" 'evil-goto-mark-line
      ;; enable only when line wrap set
      :n "j" 'evil-next-visual-line
      :n "k" 'evil-previous-visual-line
      :n "s" 'avy-goto-char-2
      :gi "C-h" 'backward-delete-char)

;;;;;;;;;;;;;;;;;;;
;;; programming ;;;
;;;;;;;;;;;;;;;;;;;

; company-mode
(setq company-idle-delay 0
      company-minimum-prefix-length 2)

;;;;;;;;;;;;;;;;
;;; language ;;;
;;;;;;;;;;;;;;;;

; racket
(setq racket-racket-program "/Applications/Racket v7.8/bin/racket")
(setq racket-raco-program "/Applications/Racket v7.8/bin/raco")

;;;;;;;;;;;;;;;
;;; Package ;;;
;;;;;;;;;;;;;;;

; avy
(setq avy-all-windows t)

; evil

; org-mode

;; disable company in org
(add-hook! 'org-mode-hook (company-mode -1))

;; change the ...ellipsis that use to hidden content
;; (setq org-ellipsis "...")

;; org-bullets

;; yinyang bullets
;; (setq org-bullets-bullet-list '("☯" "☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷"))

;; org-todo
(after! org
  (setq org-todo-keywords '((sequence "TODO(t)" "INPROGRESS(i)" "|" "DONE(d)" "CANCELLED(c)"))
        org-log-done 'time
        org-agenda-files (directory-files-recursively "~/org/" "\.org$")
        org-todo-keyword-faces '(("TODO" :foreground "#7c7c75" :weight normal :underline t )
                                 ("INPROGRESS" :foreground "#0098dd" :weight normal :underline t)
                                 ("DONE" :foreground "#50a14f" :weight normal :underline t)
                                 ("CANCELLED" :foreground "#ff6480" :weight normal :underline t))))

;; org-super-agenda
(setq  org-super-agenda-groups '((:name "Today"
                                  :time-grid t
                                  :scheduled today)
                                (:name "Due today"
                                        :deadline today)
                                (:name "Important"
                                        :priority "A")
                                (:name "Overdue"
                                        :deadline past)
                                (:name "Due soon"
                                        :deadline future)
                                (:name "Big Outcomes"
                                        :tag "bo")))

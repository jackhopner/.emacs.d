;;; rk-go.el --- Configuration for golang.  -*- lexical-binding: t; -*-

;; Copyright (C) 2017 Raghuvir Kasturi

;; Author: Raghuvir Kasturi <raghuvir.kasturi@gmail.com>

;;; Commentary:

;;; Code:

(eval-when-compile
  (require 'use-package))

(require 'dash)
(require 's)
(require 'definers)
(require 'lsp)

(use-package go-mode
  :straight t
  :mode ("\\.go\\'" . go-mode)
  :preface
  (defun rk-go--modules-p ()
    "Return non-nil if this buffer is part of a Go Modules project."
    (locate-dominating-file default-directory "go.mod"))

  (defun rk-go--setup-flycheck ()
    "Adds gofmt & golint to flycheck checker list for go-mode."
    (when lsp-mode
      (progn
        (setq-local flycheck-disabled-checkers '(go-build go-errcheck go-vet go-test))
        (flycheck-add-next-checker 'lsp-ui 'go-golint))))

  (defun rk-go--setup-go ()
    "Run setup for Go buffers."
    (progn
      (if (rk-go--modules-p)
          (setenv "GO111MODULE" "on")
        (setenv "GO111MODULE" "auto"))
      (setq gofmt-command "goimports")
      (lsp)
      (rk-go--setup-flycheck)))
  :hook
  (go-mode . rk-go--setup-go))

(use-package rk-go-run
  :after go-mode
  :config
  (progn
    (rk-local-leader-def :keymaps 'go-mode-map
      "."   '(gofmt :wk "fmt")
      "t"   '(:ignore t :wk "test")
      "t t" '(rk-go-run-test-current-function :wk "current fn")
      "t s" '(rk-go-run-test-current-suite :wk "current suite")
      "t p" '(rk-go-run-package-tests :wk "package")
      "t P" '(rk-go-run-package-tests-nested :wk "package (nested)")
      "x"   '(rk-go-run-main :wk "run"))
    (add-to-list 'display-buffer-alist
                 `(,(rx bos "*go " (or "test" "run") "*" eos)
                   (display-buffer-reuse-window
                    display-buffer-in-side-window)
                   (reusable-frames . visible)
                   (side            . bottom)
                   (slot            . 0)
                   (window-height   . 0.2)))))

(use-package go-tag
  :straight t
  :after go-mode
  :custom
  (go-tag-args '("-transform" "camelcase"))
  :config
  (rk-local-leader-def :keymaps 'go-mode-map
    "k"   '(:ignore t :wk "keyify")
    "k a" '(go-tag-add :wk "add")
    "k r" '(go-tag-remove :wk "remove")))

(provide 'rk-go)

;;; rk-go.el ends here

;;; rk-auto-save.el --- Configure auto-save features.  -*- lexical-binding: t; -*-

;; Copyright (C) 2017 Raghuvir Kasturi

;; Author: Raghuvir Kasturi <raghuvir.kasturi@gmail.com>

;;; Commentary:

;;; Code:

(require 'paths)
(autoload 'f-join "f")

(defconst rk-auto-save-dir (concat paths-cache-directory "/auto-save"))
(defconst rk-auto-save-local-dir (concat rk-auto-save-dir "/local"))
(defconst rk-auto-save-remotes-dir (concat rk-auto-save-dir "/remotes"))
(defconst rk-auto-save-sessions-dir (concat rk-auto-save-dir "/sessions"))

(dolist (dir (list rk-auto-save-local-dir rk-auto-save-remotes-dir))
  (unless (file-directory-p dir)
    (make-directory dir t)))

(setq auto-save-file-name-transforms
      `(
        ;; Tramp URLs got to remotes dir.
        ("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'" ,(f-join rk-auto-save-remotes-dir "\\2") t)
        ;; Otherwise files go to local dir.
        ("\\`/?\\([^/]*/\\)*\\([^/]*\\)\\'" ,(f-join rk-auto-save-local-dir "\\2") t)))

(setq auto-save-list-file-prefix (concat rk-auto-save-sessions-dir "/.saves-"))

(provide 'rk-auto-save)

;;; rk-auto-save.el ends here

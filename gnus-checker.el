;;; gnus-checker.el --- Mode line mail indicator for gnus

;; Copyright (C) 2008 Philip Jackson

;; Author: Philip Jackson <phil@shellarchive.co.uk>

;; This file is not currently part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program ; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Set `gnus-checker-groups' to an alist of (group . face) pairs and
;; then you will get an indicator for those groups in their respective
;; faces.

;; for example:

;; (setq gnus-checker-groups
;;       '(("nnmaildir:inbox" . font-lock-warning-face)
;;         ("nnmaildir:porn-casting" . font-lock-too-small-face)))

(defvar gnus-checker-groups '())

(defvar gnus-checker-mode-string ""
  "The string to display in the modeline")

(defun gnus-checker-modeline-entry ()
  (when (length gnus-checker-groups)
    (concat "["
            (mapconcat
             (lambda (g)
               (let ((unread (number-to-string
                              (or (gnus-group-unread (car g)) 0))))
                 (propertize unread 'face (cdr g))))
             gnus-checker-groups " ")
            "] ")))

(defun gnus-checker-add-to-modeline ()
  (unless (memq 'gnus-checker-mode-string global-mode-string)
    (put 'gnus-checker-mode-string 'risky-local-variable t)
    (setcdr global-mode-string
            (cons 'gnus-checker-mode-string (cdr global-mode-string)))))

;; startup
(add-hook 'gnus-started-hook
          (lambda ()
            (setq gnus-checker-mode-string
             (gnus-checker-modeline-entry))
             (gnus-checker-add-to-modeline)))

;; update the string after fetch
(add-hook 'gnus-after-getting-new-news-hook
          (lambda ()
            (setq gnus-checker-mode-string
             (gnus-checker-modeline-entry))))

;; remove it from the modeline
(add-hook 'gnus-exit-gnus-hook
          (lambda ()
            (delete 'gnus-checker-mode-string
             global-mode-string)))

;; this will reset the values when a group is exited
(add-hook 'gnus-summary-exit-hook
          (lambda ()
            (setq gnus-checker-mode-string
             (gnus-checker-modeline-entry))))

(provide 'gnus-checker)
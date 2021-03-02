;; **Filename: yawtb-code-comment.el
;;
;; **License:
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
;;
;; **Keywords: YAW Toolbox, mfiles, c, header, GPL
;;
;; **Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library) 
;;
;; **Description:
;;
;; This is just a little emacs macro to load appropriate header
;; for mfiles developpement. It adds also the GPL license at 
;; the end of the buffer.
;;
;; **Commentary: 
;; 
;; This file is for development stage only. I mean, it is written for developpers.
;;
;; **Warning: 
;;
;; You must load the matlab mode before in your .emacs file !!!!
;; (see: ftp://ftp.mathworks.com/pub/contrib/emacs_add_ons/matlab.el)
;;
;; **Installation:
;;         
;; Add the following lines to your .emacs file after the matlab mode 
;; loading lines:
;; (load "yawtb-code-comment")
;;

;; WARNING "source-path" must be adapeted to you configuration
(setq myhome (getenv "HOME"))
(setq source-path (concat myhome "/matlab/yawtb/tools/devel/xemacs_macro/")) 

(setq yawtb-mfile-header (concat source-path "mfile_header_part.txt"))
(setq yawtb-mfile-gpl    (concat source-path "mfile_gpl_part.txt"))

(setq yawtb-cfile-header (concat source-path "cfile_header_part.txt"))
(setq yawtb-cfile-gpl    (concat source-path "cfile_gpl_part.txt"))


;; Handling mfiles
(defun add-yawtb-mfile () (interactive)
  (beginning-of-buffer)
  (setq base-bufname
       (substring (buffer-name) 0 (string-match "\\.m" (buffer-name))))
  (insert-file-contents yawtb-mfile-header nil nil nil)
  (end-of-buffer)
  (insert-string "\n\n\n\n")
  (insert-file-contents yawtb-mfile-gpl nil nil nil)
  (beginning-of-buffer)
  (perform-replace "%FILE_NAME%" base-bufname nil nil nil)
  (perform-replace "%HEADER%" (concat "$" "Header" "$") nil nil nil)
  )

(add-hook 'matlab-mode-hook
          (function
           (lambda () 
             ;; insert boilerplate in new files
             (if (= 1 (point-max)) 
                 (progn
		   (add-yawtb-mfile)
                   (goto-char (point-max)))))))

;; Handling c file (mex files and others)
(defun add-yawtb-cfile () (interactive)
  (beginning-of-buffer)
  (setq base-bufname
       (substring (buffer-name) 0 (string-match "\\.c" (buffer-name))))
  (insert-file-contents yawtb-cfile-header nil nil nil)
  (end-of-buffer)
  (insert-string "\n\n\n\n")
  (insert-file-contents yawtb-cfile-gpl nil nil nil)
  (beginning-of-buffer)
  (perform-replace "%FILE_NAME%" base-bufname nil nil nil)
  (perform-replace "%HEADER%" (concat "$" "Header" "$") nil nil nil)
  )


;; uncomment for automatic use of add-yawtb-file with all cfiles

;;(add-hook 'c-mode-hook
;;          (function
;;           (lambda () 
;;             ;; insert boilerplate in new files
;;             (if (= 1 (point-max)) 
;;                 (progn
;;		   (add-yawtb-cfile)
;;                   (goto-char (point-max)))))))

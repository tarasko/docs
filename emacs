;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

; Colors
(custom-set-faces
 '(default ((t (:inherit nil :stipple nil :background "gray15" :foreground "gray85" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :widt\
h normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(diff-added ((t (:inherit diff-changed :foreground "Green"))))
 '(diff-removed ((t (:inherit diff-changed :foreground "Red"))))
 '(diff-changed ((t (:inherit diff-changed :foreground "Blue")))))


; Turn off X scroll cause it is ugly.
(scroll-bar-mode nil)
(tool-bar-mode nil)

; ?? Stolen from Rita`s config
(setenv "LC_MESSAGES" "C")

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

; Set offset and use spaces instead of tabs
(setq c-basic-offset 4)
(setq c++-basic-offset 4)
(setq-default indent-tabs-mode nil)

; Show line and columns
(line-number-mode 1)
(column-number-mode 1)

; Highlight selection
(transient-mark-mode t)

; Highlight symbols beyond 80 column
(defun font-lock-width-keyword (width)
  "Return a font-lock style keyword for a string beyond width WIDTH
   that uses 'font-lock-warning-face'."
  `((,(format "^%s\\(.+\\)" (make-string width ?.))
     (1 font-lock-warning-face t))))
(font-lock-add-keywords 'c++-mode (font-lock-width-keyword 79))

; Setup correct indentation according to BDE rules

(c-set-offset 'innamespace 0)
(c-set-offset 'substatement-open 0)
(c-set-offset 'access-label -2)
(c-set-offset 'member-init-intro 4)
(c-set-offset 'arglist-intro 4)
(c-set-offset 'brace-list-open 0)
(c-set-offset 'inher-intro 0)

; Store temporary files to special folder
(custom-set-variables
  '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
  '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))

(make-directory "~/.emacs.d/autosaves/" t)

; Show trailing whitespace
(setq-default show-trailing-whitespace t)

; M-g M-g goto line
(global-set-key "\M-g\M-g" 'goto-line)

; M-g M-w delete trailing whitespace
(global-set-key "\M-g\M-w" 'delete-trailing-whitespace)

; Define rule for switching between header and source
; Check ff-find-other-file command
(setq cc-other-file-alist
      '(("\\.cpp$" (".hpp" ".h"))
        ("\\.h$" (".cpp" ".c"))
        ("\\.hpp$" (".cpp" ".c"))))

; M-g M-f to switch between header and source
(global-set-key "\M-g\M-f" 'ff-find-other-file)

; Path to file where you wish to put all tags
(setq tag-file "~/.emacs.d/tags/TAGS")

; Enter here list of directories you want to tag
(setq dirs-to-tag
      '("/first/include/dir"
        "/second/include/dir"
        "/third/include/dir"))

; Rest stuff to generate tags.
; Leave it as is
(defun append-tags-to-tag-file (dir-name)
  "Create tags file."
  (shell-command
    (format "find %s \\( -name '*.h' -o -name '*.cpp' -o -name '*.hpp' \\) | xargs ctags -e --extra=+q --fields=+fksaiS --c++-kinds=+px --append -f %s" dir-name tag-file)))

(defun create-tags ()
  "Create tags for directories specified in dirs-to-tag list"
  (interactive)
  (shell-command (concat "rm " tag-file))
  (let (value)
    (dolist (element dirs-to-tag value)
      (append-tags-to-tag-file element))))

(setq tags-table-list (cons tag-file ()))
(create-tags)

; Define command that insert bde style header with redundant include guard
(defun bde-include (name)
  "insert bde style header with redundant include guard"
  (interactive "sEnter component name: ")
  (insert (format "#ifndef INCLUDED_%s\n#include <%s.h>\n#endif\n" (upcase name) (downcase name))))

; M-g M-i to add include with redundant include guard
(global-set-key "\M-g\M-i" 'bde-include)

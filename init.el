(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes
   (quote
    ("b0e6f38facd8c591991db60389b8b4a98885e7750ed5761ce987bff0588472d3" "afbb40954f67924d3153f27b6d3399df221b2050f2a72eb2cfa8d29ca783c5a8" "9459d3fdc79216e60b509ee3e9d09aa7baff71b032fd9fc94a8957e8c749d8de" default)))
 '(inhibit-startup-screen t)
 '(org-startup-truncated nil)
 '(package-selected-packages
   (quote
    (pyenv-mode ac-clang rtags python-docstring py-autopep8 org-babel-eval-in-repl org-ac org ob-ipython material-theme jedi-direx helm-swoop helm-fuzzier helm-company fuzzy flycheck-irony elpy ein darkroom company-jedi company-irony-c-headers company-irony company-c-headers cmake-ide clang-format cl-format better-defaults babel-repl auto-complete-clang auto-complete-c-headers auto-complete-auctex auto-compile atom-dark-theme aggressive-indent ac-math ac-helm ac-c-headers))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

;; Standard package.el + MELPA setup
;; (See also: https://github.com/milkypostman/melpa#usage)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; INSTALL PACKAGES
;; --------------------------------------
;; list the packages you want
(setq package-list
      '(epc better-defaults ein material-theme py-autopep8
            flycheck jedi concurrent company elpy 
            yasnippet))

;; activate all the packages
(package-initialize)

;; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
(when (not package-archive-contents)
  (package-refresh-contents))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/") 

;; following 2 lines include auto-complete
;;(require 'auto-complete)  
;;(global-auto-complete-mode t)

;; following 5 lines include auto-complete and make it so that tab no longer activates auto-complete
;;(require 'auto-complete-config) 
;;(ac-config-default)
;;(add-to-list 'ac-modes 'vhdl-mode) ;; add vhdl mode to modes in which autocomplete is active
;;(define-key ac-mode-map (kbd "TAB") nil)
;;(define-key ac-completing-map (kbd "TAB") nil)
;;(define-key ac-completing-map [tab] nil)
;;
;;(ac-set-trigger-key "`") ;; sets the auto-complete key
;;
;;(require 'auto-complete-config)
;;(ac-config-default)

(add-to-list 'auto-mode-alist '("\\.pyx\\'" . python-mode)) ;; for Cython files

(defun dot-emacs (relative-path)
  "Return the full path of a file in the user's emacs directory."
  (expand-file-name (concat user-emacs-directory relative-path)))

(add-to-list 'load-path
	                   "~/.emacs.d/elpa/yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory
  (dot-emacs "elpa/yasnippet/snippets"))

;; Remove Yasnippet's default tab key binding
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
;; Set Yasnippet's key binding to shift+tab
(define-key yas-minor-mode-map (kbd "§") 'yas-expand)

(setq column-number-mode t) ;; emacs displays column number as well

(load-theme 'zenburn)

(setq show-paren-delay 0)
(show-paren-mode 1)

(global-aggressive-indent-mode 1) ;; enable aggressive-indent-mode everywhere

(add-hook 'after-init-hook 'global-company-mode) ;; enable company-mode everywhere

(global-set-key "`" 'company-complete-common)

;; Standard Jedi.el setting
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;;Emacs Python configuration taken from https://realpython.com/blog/python/emacs-the-best-python-editor/
;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
;;(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; PYTHON CONFIGURATION
;; --------------------------------------

;;(setq elpy-modules nil)
(elpy-enable)
(elpy-use-ipython)
;;fix formattings
(setq ansi-color-for-comint-mode t)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i")

;;the following is maybe useful at some point in time, but for now just start your conda virtaula environment before starting emacs to use it in your python IDE
;;automatically activate python3 env, taken from http://emacs.stackexchange.com/questions/18059/how-to-activate-python-virtual-environment-in-init-file
;;(require 'pyvenv)
;;(pyvenv-activate "python3")
;;choose between conda environments with M-x pyvenv-workon, taken from http://emacs.stackexchange.com/questions/20092/using-conda-environments-in-emacs
;;(setenv "WORKON_HOME" "/Users/markusrademacher/anaconda3/envs")
;;(pyvenv-mode 1)

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; warnings-fix for elpy, taken from https://github.com/jorgenschaefer/elpy/issues/887
(setq python-shell-completion-native-enable nil)

;;helps to get rid of all the warnings when running python, taken from http://emacs.stackexchange.com/questions/30082/your-python-shell-interpreter-doesn-t-seem-to-support-readline
(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))

;; Helm Install, taken from Muddassar's init-file
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x) ;; binds M-x to helm
(setq helm-ff-file-name-history-use-recentf t)
(helm-mode 1) ;; Starts helm-mode with Emacs
(global-set-key (kbd "C-x C-f") #'helm-find-files) ;; Helm-find file
(require 'helm-swoop)

;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)

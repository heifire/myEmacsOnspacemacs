;;;  my emacs config on spacemacs
;;; turn off evil

  (defun turn-evil-mode (&optional arg)
    "Turn off Evil in the current buffer."
    (interactive)
    (if evil-local-mode
        (evil-local-mode -1)
      (evil-local-mode  1)))

  (global-set-key (kbd "C-S-i") 'turn-evil-mode)


  (global-set-key (kbd "C-S-s") 'sr-speedbar-toggle)

;;; tabbar
  (require 'tabbar)
  (tabbar-mode)
  (global-set-key (kbd "<C-tab>") 'tabbar-forward)
  (global-set-key (kbd "<C-iso-lefttab>") 'tabbar-backward)

;;; python excute shellscript
  (global-set-key (kbd "<C-S-f10>") 'spacemacs/python-execute-file)
  (global-set-key (kbd "<C-S-f11>") 'python-shell-send-buffer-switch)

;;; chezScheme
;;;;;;;;;;;;
;; Scheme 
;;;;;;;;;;;;
  (autoload 'paredit-mode "paredit"
    "Minor mode for pseudo-structurally editing Lisp code."
    t)

  (require 'cmuscheme)
  (setq scheme-program-name "scheme")         ;; 编译器程序


  ;; bypass the interactive question and start the default interpreter
  (defun scheme-proc ()
    "Return the current Scheme process, starting one if necessary."
    (unless (and scheme-buffer
                 (get-buffer scheme-buffer)
                 (comint-check-proc scheme-buffer))
      (save-window-excursion
        (run-scheme scheme-program-name)))
    (or (scheme-get-process)
        (error "No current process. See variable `scheme-buffer'")))


  (defun scheme-split-window ()
    (cond
     ((= 1 (count-windows))
      (delete-other-windows)
      (split-window-vertically (floor (* 0.68 (window-height))))
      (other-window 1)
      (switch-to-buffer "*scheme*")
      (other-window 1))
     ((not (find "*scheme*"
                 (mapcar (lambda (w) (buffer-name (window-buffer w)))
                         (window-list))
                 :test 'equal))
      (other-window 1)
      (switch-to-buffer "*scheme*")
      (other-window -1))))


  (defun scheme-send-last-sexp-split-window ()
    (interactive)
    (scheme-split-window)
    (scheme-send-last-sexp))


  (defun scheme-send-definition-split-window ()
    (interactive)
    (scheme-split-window)
    (scheme-send-definition))

  (add-hook 'scheme-mode-hook
            (lambda ()
              (paredit-mode 1)
              (define-key scheme-mode-map (kbd "<f5>") 'scheme-send-last-sexp-split-window)
              (define-key scheme-mode-map (kbd "<f10>") 'scheme-send-region)
              (define-key scheme-mode-map (kbd "<f6>") 'scheme-send-definition-split-window)))

(provide 'myconfig)

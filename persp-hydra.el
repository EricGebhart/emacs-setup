(defmacro hfj/make-tab (name &rest body)
  "Select an existing tab, or create one and configure it."
  `(cond
    ((persp-with-name-exists-p ,name)
     (persp-switch ,name))
    (t
     (persp-switch ,name)
     ,@body)))

(defun hfj/make-tab-f (name setup-actions)
  "Select an existing tab, or create one and configure it."
  (cond
   ((persp-with-name-exists-p name)
    (persp-switch name))
   (t
    (persp-switch name)
    (funcall setup-actions))))

(defun define-layout-inner (name f)
  "Add layout config to hfj/predefined-layouts"
  (setq hfj/predefined-layouts
        (delete-if (lambda (a) (string-equal (car a) name))
                   hfj/predefined-layouts))
  (push (list* name (cons name f)) hfj/predefined-layouts)
  (setq hfj/predefined-layouts
        (sort hfj/predefined-layouts
              (lambda (a b) (string< (car a) (car b))))))

(defmacro hfj/define-layout (name &rest body)
  "Add layout config to hfj/predefined-layouts"
  `(define-layout-inner ,name (lambda () ,@body)))

(defun hfj/pick-layout ()
  "Switch to a new or existing layout."
  (interactive)
  (let* ((names (persp-names))
         (name (completing-read "Switch to layout: " names))
         (exists (persp-with-name-exists-p name)))
    (persp-switch name)
    (unless exists
      (switch-to-buffer "*scratch*"))))

(defvar hfj/predefined-layouts '())

(defun hfj/pick-predefined-layout ()
  "Create a predefined layout to be selectable from list."
  (interactive)
  (when (null hfj/predefined-layouts)
    (error "No layouts configured."))

  (let ((layout-name-and-actions (helm :sources (helm-build-sync-source "layout"
                                                  :candidates hfj/predefined-layouts))))

    (when layout-name-and-actions
      (hfj/make-tab-f (car layout-name-and-actions) (cdr layout-name-and-actions)))))

(defun hfj/persp-kill-current ()
  (interactive)
  (let ((persp (get-current-persp)))
    (cond ((null persp) (error "Unable to kill default layout."))
          (t (persp-kill (persp-name persp))))))

(defun hfj/persp-switch-to-n (n)
  (let ((names (persp-names-current-frame-fast-ordered))
        (count 1))
    (dolist (name names)
      (when (= count n)
        (persp-switch name))
      (cl-incf count))))
(defun hfj/persp-switch-to-1 () (interactive) (hfj/persp-switch-to-n 1))
(defun hfj/persp-switch-to-2 () (interactive) (hfj/persp-switch-to-n 2))
(defun hfj/persp-switch-to-3 () (interactive) (hfj/persp-switch-to-n 3))
(defun hfj/persp-switch-to-4 () (interactive) (hfj/persp-switch-to-n 4))
(defun hfj/persp-switch-to-5 () (interactive) (hfj/persp-switch-to-n 5))
(defun hfj/persp-switch-to-6 () (interactive) (hfj/persp-switch-to-n 6))
(defun hfj/persp-switch-to-7 () (interactive) (hfj/persp-switch-to-n 7))
(defun hfj/persp-switch-to-8 () (interactive) (hfj/persp-switch-to-n 8))
(defun hfj/persp-switch-to-9 () (interactive) (hfj/persp-switch-to-n 9))
(defun hfj/persp-switch-to-10 () (interactive) (hfj/persp-switch-to-n 10))

(defun hydra-perse-names ()
  (let ((names (persp-names-current-frame-fast-ordered))
        (current-name (safe-persp-name (get-current-persp)))
        (parts '())
        (count 1))
    (dolist (name names (s-join " | " (nreverse parts)))
      (cond ((eq name current-name)
             (push (format "[%d:%s]" count name) parts))
            (t
             (push (format "%d:%s" count name) parts)))
      (cl-incf count))))

(defhydra hydra-persp (:hint nil)
  "
Layouts %s(hydra-perse-names)

^Navigation^      ^Selection^       ^Actions^        ^Buffers^
^-^---------------^-^---------------^-^--------------^-^------------
_n_: next         _l_: choose       _d_: delete      _a_: add buffer
_p_: previous     _L_: predefined   _r_: rename
"
  ("q" nil)
  ("a" persp-add-buffer :exit t)
  ("d" hfj/persp-kill-current)
  ("l" hfj/pick-layout :exit t)
  ("L" hfj/pick-predefined-layout :exit t)
  ("r" persp-rename :exit t)
  ("n" persp-next)
  ("p" persp-prev)
  ("1" hfj/persp-switch-to-1 :exit t)
  ("2" hfj/persp-switch-to-2 :exit t)
  ("3" hfj/persp-switch-to-3 :exit t)
  ("4" hfj/persp-switch-to-4 :exit t)
  ("5" hfj/persp-switch-to-5 :exit t)
  ("6" hfj/persp-switch-to-6 :exit t)
  ("7" hfj/persp-switch-to-7 :exit t)
  ("8" hfj/persp-switch-to-8 :exit t)
  ("9" hfj/persp-switch-to-9 :exit t)
  ("0" hfj/persp-switch-to-10 :exit t))
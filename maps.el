;;; maps.el --- A plists utils libary

;; Copyright (C) 2013 Patrik Kårlin

;; Author: Patrik Kårlin <patrik.karlin@gmail.com>
;; Version: 1.0.0
;; Keywords: maps plist

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A plists utils libery
;;
;; See documentation on https://github.com/magnars/dash.el#functions

;;; Code:

(defun m/alist->plist (alist)
  (-flatten (--map
	     (list (m/symbol->keyword (car it)) (cdr it))
	     alist)))

(defalias 'm/get 'plist-get)

(defun m/eq (a b)
  (-all?
   (lambda (pair)
     (equal (cadr pair) (m/get b (car pair))))
   (-partition 2 a)))

(defun m/keys (plist)
  (->> plist
    (-partition 2)
    (-map 'first)))

(defun m/vals (plist)
  (->> plist
    (-partition 2)
    (-map 'second)))

(defun m/merge (plist-a &rest plist-b)
  (-reduce-from
   (lambda (plist-a plist-b)
     (->> (-partition 2 plist-b)
       (--reduce-from
	(let ((key (first it))
	      (val (second it)))
	  (plist-put acc key val))
	plist-a)))
   plist-a
   plist-b))

(defun m/dissoc (plist key)
  (-flatten
   (--reject (eq (first it) key) (-partition 2 plist))))

(defun m/assoc (plist &rest pairs)
  (m/merge plist pairs))

(defun m/update-in (plist index f &rest args)
  (let ((key (first index)))
    (if (eq 1 (length index))
	(m/assoc plist key (apply f (m/get plist key) args))
      (m/assoc plist key (apply 'm/update-in (m/get plist key) (rest index) f args)))))

(defun m/merge-with (f plist-a plist-b)
  (-reduce-from
   (lambda (accu input-pair)
     (let* ((key (first input-pair))
	    (old-val (plist-get accu key))
	    (new-val
	     (if old-val
		 (funcall f old-val (second input-pair))
	       (second input-pair))))
       (plist-put accu key new-val)))
   plist-a
   (-partition 2 plist-b)))

(defun m/assoc-in (plist index &rest keyvals)
  (m/update-in plist index 'm/merge keyvals))

(defun m/map-vals (f plist)
  (->> (-partition 2 plist)
    (-map (lambda (pair)
	    (list (first pair) (funcall f (second pair)))))
    (-flatten)))

(defun m/keyword->symbol (keyword)
  (intern (substring (symbol-name keyword) 1)))

(defun m/symbol->keyword (symbol)
  (intern (concat ":" (symbol-name symbol))))

(defun m/key-lookup-pair (keys map-name)
  (-map
   (lambda (key)
     `(,key (m/get ,map-name ,(m/symbol->keyword key))))
   keys))

(defmacro m/letm (form &rest code)
  ""
  (declare (indent defun))
  (let* ((map (gensym))
	 (keys (first form))
	 (val-exp (second form))
	 (remaining (rest (rest form)))
	 (next-code
	  (if (null remaining)
	      `(progn .,code)
	    `(m/letm ,remaining .,code))))
    `(let* ((,map ,val-exp)
	    .,(m/key-lookup-pair keys map))
       ,next-code)))

(defvar m/keywords-added nil)
(unless m/keywords-added
  (font-lock-add-keywords
   'emacs-lisp-mode
   `((,(concat "(\\s-*" (regexp-opt '("m/letm" "m/defm" "m/defk") 'paren) "\\>")
      1 font-lock-keyword-face)) 'append)

  (font-lock-refresh-defaults)
  (setq m/keywords-added t))

(defmacro m/defm
  (name bindings &rest code)
  (declare (indent defun))
  (let ((map-arg (gensym)))
    `(defun ,name (,map-arg)
       (m/letm (,bindings ,map-arg)
	 .,code))))

(defmacro m/defk
  (name bindings &rest code)
  (declare (indent defun))
  (let ((map-arg (gensym)))
    `(defun ,name (&rest ,map-arg)
       (m/letm (,bindings ,map-arg)
	 .,code))))

(provide 'maps)

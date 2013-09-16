
(ert-deftest m/test-alist->plist ()
  (should (equal (m/alist->plist `((a . b) (c . d)))
		 `(:a b :c d))))

(ert-deftest m/test-keys ()
  (should (equal (m/keys `(:a b :c d))
		 `(:a :c))))

(ert-deftest m/test-vals ()
  (should (equal (m/vals `(:a b :c d))
		 `(b d))))

(ert-deftest m/test-eq ()
  (should (m/eq `(:a b :c d :e f)
		`(:c d :e f :a b)))
  (should (not (m/eq `(:a b :c d :e f)
		     `(:c d :e f :a 2)))))

(ert-deftest m/test-merge ()
  (should (m/eq
	   (m/merge `(:a b :c d :e f)
		    `(:b q :a e))
	   `(:a e :b q :c d :e f))))

(ert-deftest m/test-dissoc ()
  (should (m/eq
	   (m/dissoc `(:a b :c d :e f)
		     :a)
	   `(:c d :e f))))

(ert-deftest m/test-assoc ()
  (should (m/eq
	   (m/assoc `(:a b :c d :e f)
		    :a 2 :b 3)
	   `(:a 2 :b 3 :c d :e f))))

(ert-deftest m/test-map-vals ()
  (should (m/eq (m/map-vals '1+ `(:a 1 :b 2 :c 3))
		`(:a 2 :b 3 :c 4))))

(ert-deftest m/test-keyword->symbol ()
  (should (eq (m/keyword->symbol :hej) 'hej)))

(ert-deftest m/test-symbol->keyword ()
  (should (eq (m/symbol->keyword 'hej) :hej)))

(ert-deftest m/test-letm ()
  (should (eq 6
	      (m/letm ((a b c) (list :a 1 :b 2 :c 3))
		(+ a b c)))))

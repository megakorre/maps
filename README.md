# maps.el A emacs lisp plist utils libary

Notice nothing in this libary is written to be effitiant its intended for small records with properties.

Depends on [dash.el](https://github.com/magnars/dash.el)

* `m/alist->plist`
  converts a alist of style ((a . b) (c . d)) to (:a b :c d)
* `m/get`
  alias for plist-get
* `m/eq`
  plist equality
* `m/keys`
  returns a list with the keys
* `m/vals`
  returns a list with the vals
* `m/merge`        (`plist-a` &rest `plist-b`)
  takes anny number of plist's and merges them left to right
* `m/dissoc`       (`plist` `key`)
  removes a key value pair with the key `key`
* `m/assoc`        (`plist` &rest `pairs`)
  adds key value pairs to the plist
* `m/update-in`    (`plist` `index` `f` &rest `args`)
* `m/merge-with`   (`f` `plist-a` `plist-b`)
* `m/assoc-in`     (`plist` `index` &rest `keyvals`)
* `m/map-vals`     (`f` `plist`)
* `m/keyword->symbol` (`keyword`)
* `m/symbol->keyword` (`symbol`)
* `m/letm` (`form` &rest `code`)

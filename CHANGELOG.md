# CHANGELOG

## 0.3.0 (in progress)

* Use of Redis hashes to store data.
* Added `remove_statistics(id)` method to remove all streak data for a given ID.

## 0.2.0 (2012-07-02)

* You can now pass a custom set of keys to be used in the `aggregate` call if you want to
use a different set of positive/negative things than what is setup in the configuration.

## 0.1.0

* Key-space is now separated by a single `:` instead of `::`

## 0.0.2

* Fix +total_key+ configuration.

## 0.0.1

* Initial release.
(ns utilities
  (:require [clojure.java.io :as io]))

(defn read-file [filename]
  (with-open [reader (io/reader filename)]
    (->> reader
         (line-seq)
         (reduce conj []))))

(defn get-lines [[filename & _rest]]
  (->> filename
       (read-file)))

(def day_4_pattern #"(?x) # whitespace flag
\[
(?<year>\d++)
-(?<month>\d++)
-(?<day>\d++)
[^\d]
(?<hour>\d++)
:
(?<minute>\d++)
\]
\s
(?<type>
(?:w.++)
|
(?:f.++)
|
(?:G\w++\s\#(?<id>\d++).++)
)")

(defn matcher_for [pattern]
  (fn [line] (re-matcher pattern line))
)

(def day_3_pattern #"#(?<id>\d++)[^\d]++(?<x>\d++)[^\d]++(?<y>\d++)[^\d]++(?<width>\d++)[^\d]++(?<height>\d++)")

(defn day_3_matcher [line]
  (re-matcher day_3_pattern line))

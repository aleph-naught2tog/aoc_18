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

(def pattern #"#(?<id>\d++)[^\d]++(?<x>\d++)[^\d]++(?<y>\d++)[^\d]++(?<width>\d++)[^\d]++(?<height>\d++)")

(defn matcher [line]
  (re-matcher pattern line))

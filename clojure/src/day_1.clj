(ns day_1
  (:require [clojure.java.io :as io]))

(defn read-file [filename]
  ;; with-open is ye olde autocloseable
  (with-open [reader (io/reader filename)]
    ;; reduce how_to_reduce_fun start_val what_to_reduce
    (reduce conj [] (line-seq reader))))

(defn get-lines [[filename & _rest]]
  (println filename)
  (read-file filename))

(defn sum-lines [lines]
  (loop [[line & rest_lines] lines
         sum 0]
    (if (some? line)
      (recur rest_lines (+ sum (Integer/parseInt line)))
      sum
      )))

(defn -main [& args] ;; & for variadic
  (let [lines (get-lines args)]
    (println (sum-lines lines)))
)

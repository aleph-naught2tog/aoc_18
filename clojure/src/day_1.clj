(ns day_1
  (:require [clojure.java.io :as io]))

(defn read-file [filename]
  (with-open [reader (io/reader filename)]
    (->> reader
         (line-seq)
         (reduce conj []))))

(defn get-lines [[filename & _rest]]
  (->> filename
       (read-file)
       (map #(Integer/parseInt %))))

(defn sum-lines [lines]
  (loop [[line & rest_lines] lines
         sum 0]
    (if (some? line)
      (recur rest_lines (+ sum line))
      sum)))

(defn add-at-key [map_target
                  key-list
                  value]
  (let [bucket (get-in map_target key-list)]
    (if (contains? bucket value)
      value
      (assoc-in map_target key-list (conj bucket value)))))

(defn check-existing [existing updated]
  (cond
    (and (even? updated) (pos? updated)) (add-at-key existing [:even :pos] updated)
    (and (odd? updated) (pos? updated)) (add-at-key existing [:odd :pos] updated)
    (and (even? updated) (neg? updated)) (add-at-key existing [:even :neg] updated)
    (and (odd? updated) (neg? updated)) (add-at-key existing [:odd :neg] updated)))

(defn get-repeated-value [numbers]
  (loop [existing {:even {:neg #{} :pos #{}}
                   :odd {:neg #{} :pos #{}}}
         [current & to_go] numbers
         done []
         sum 0]

    (if (nil? current)
      (recur existing done [] sum)

      (let [updated (+ current sum)
            result (check-existing existing updated)]

        (if (number? result)
          result
          (recur result to_go (conj done current) updated))))))

(defn -main [& args] ;; & for variadic
  (let [lines (get-lines args)]
    (println "\nTotal:" (sum-lines lines))
    (println "--- --- --- --- --- ---")
    (println "Value:" (get-repeated-value lines))))

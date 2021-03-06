(ns day_3
  (:require [utilities :as utils])
  (:require [clojure.pprint :as p]))

(defn parse [line]
  (let [line_matcher (utils/day_3_matcher line)]
    (if (.matches line_matcher)
      {:id (Integer/parseInt (.group line_matcher "id"))
       :x (Integer/parseInt (.group line_matcher "x"))
       :y (Integer/parseInt (.group line_matcher "y"))
       :width (Integer/parseInt (.group line_matcher "width"))
       :height (Integer/parseInt (.group line_matcher "height"))})))

(defn cartesian [collections]
  (if (empty? collections)
    '(())
    (for [x (first collections)
          more (cartesian (rest collections))]
      (cons x more))))

(defn explode [{:keys [id x width y height] :as m}]
  (let [xs (take width (iterate inc x))
        ys (take height (iterate inc y))]
    (for [x-value xs]
      (->> ys
           (map (fn [y-value] [x-value, y-value]))))))

(defn -main [& args]
  (let [lines (utils/get-lines args)]
    (p/pprint (->> lines
                   (map parse)
                   (map explode)))))

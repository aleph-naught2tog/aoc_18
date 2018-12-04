(ns day_4
  (:require [utilities :as utils])
  (:require [clojure.pprint :as p]))

(defn parse [matcher_maker line]
  (let [matcher (matcher_maker line)]
    (if (.matches matcher)
      (println "matches")
      (println "no matches"))))


(defn -main [& args]
  (println "day 4?")
  (p/pprint utils/day_4_pattern)
  (let [matcher (utils/matcher_for utils/day_4_pattern)]
    (p/pprint (->> args
                   (utils/get-lines)
                   (map #(parse matcher %))))))

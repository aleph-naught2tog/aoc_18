(ns day_4
  (:require [utilities :as utils])
  (:require [clojure.pprint :as p]))

(defn parse [matcher_maker line]
  (let [matcher (matcher_maker line)]
    (if (.matches matcher)
      {:year (Integer/parseInt (.group matcher "year"))
       :month (Integer/parseInt (.group matcher "month"))
       :day (Integer/parseInt (.group matcher "day"))
       :hour (Integer/parseInt (.group matcher "hour"))
       :minute (Integer/parseInt (.group matcher "minute"))
       :type (.group matcher "type")})))

(defn roller [key]
  (fn [values]
    (->> values
         (sort-by key)
         (group-by key))))

(defn map_hours [[hour h_group]]
  [hour (group-by :minute (sort-by :minute h_group))])

(defn split-roll-mapper [roller_fn mapper_fn]
  (fn [[key value_group]]
    [key (->> value_group
              (roller_fn)
              (map mapper_fn))]))

(defn roll-up [parsed_lines]
  (let [year_roller (roller :year)
        month_roller (roller :month)
        day_roller (roller :day)
        hour_roller (roller :hour)
        minute_roller (roller :minute)]
    (->> parsed_lines
         (year_roller)
         (map
          (split-roll-mapper month_roller
                             (split-roll-mapper day_roller
                                                (split-roll-mapper hour_roller
                                                                   (split-roll-mapper minute_roller (fn [x] x)))))))))

(defn -main [& args]
  (let [matcher (utils/matcher_for utils/day_4_pattern)]
    (p/pprint (->> args
                   (utils/get-lines)
                   (map #(parse matcher %))
                   (roll-up)))))

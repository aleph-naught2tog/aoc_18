(ns day_4
  (:require [utilities :as utils])
  (:require [clojure.pprint :as p]))

(defn pick-type [[first_letter]]
  (case first_letter
    \f :start_sleep
    \w :end_sleep
    \G :start_shift
    :other))

(def int-fn #(Integer/parseInt %))

(defn do-process [matcher]
  (letfn [(key-matcher
            ([key] (.group matcher key))
            ([key, func] (func (.group matcher key))))]
    {:year (key-matcher "year" int-fn)
     :month (key-matcher "month" int-fn)
     :day (key-matcher "day" int-fn)
     :hour (* -1 (key-matcher "hour" int-fn))
     :minute (key-matcher "minute" int-fn)
     :type (key-matcher "type" pick-type)
     :id (key-matcher "id")}))

(defn parse [matcher_maker line]
  (let [matcher (matcher_maker line)]
    (if (.matches matcher)
      (let [result (do-process matcher)]
        (if (neg? (get result :hour))
          (update result :day + 1)
          result)))))

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

(defn mega-roller []
  (let [month_roller (roller :month)
        day_roller (roller :day)
        hour_roller (roller :hour)
        minute_roller (roller :minute)]
    (->> (fn [x] x)
        ;  (split-roll-mapper minute_roller)
         (split-roll-mapper hour_roller)
         (split-roll-mapper day_roller)
         (split-roll-mapper month_roller))))

(defn roll-up [parsed_lines]
  (map (mega-roller) ((roller :year) parsed_lines)))

(defn -main [& args]
  (let [matcher (utils/matcher_for utils/day_4_pattern)]
    ; (p/pprint
    (->> args
         (utils/get-lines)
         (map #(parse matcher %))
         (roll-up)
         (run! (fn [v] (p/pprint v) (println "-----"))))))
                  ;  )

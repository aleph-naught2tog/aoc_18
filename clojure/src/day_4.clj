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

(defn roll-up [parsed_lines]
  (let [year_roller (roller :year)
        month_roller (roller :month)
        day_roller (roller :day)
        hour_roller (roller :hour)
        minute_roller (roller :minute)]
    (->> parsed_lines
         (year_roller)
         (map (fn [[year y_group]]
                [year (->> y_group
                           (month_roller)
                           (map (fn [[month m_group]]
                                  [month (->> m_group
                                              (day_roller)
                                              (map (fn [[day d_group]]
                                                     [day (->> d_group
                                                               (hour_roller)
                                                               (map (fn [[hour h_group]]
                                                                      [hour (->> h_group
                                                                                 (sort-by :minute))])))])))])))])))))

(defn -main [& args]
  (let [matcher (utils/matcher_for utils/day_4_pattern)]
    (p/pprint (->> args
                   (utils/get-lines)
                   (map #(parse matcher %))
                   (roll-up)))))

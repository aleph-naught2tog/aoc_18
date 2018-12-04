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


(defn -main [& args]
  (let [matcher (utils/matcher_for utils/day_4_pattern)]
    (p/pprint (->> args
                   (utils/get-lines)
                   (map #(parse matcher %))
                   (sort-by :year)
                   (group-by :year)
                   (map (fn [[year y_group]]
                          [year (->> y_group
                                     (sort-by :month)
                                     (group-by :month)
                                     (map (fn [[month m_group]]
                                            [month (->> m_group
                                                        (sort-by :day)
                                                        (group-by :day)
                                                        (map (fn [[day d_group]]
                                                               [day (->> d_group
                                                                         (sort-by :hour)
                                                                         (group-by :hour)
                                                                         (map (fn [[hour h_group]]
                                                                                [hour (->> h_group
                                                                                           (sort-by :minute))])))])))])))]))))))

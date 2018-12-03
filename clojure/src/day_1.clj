(ns day_1)

(require '(clojure.java.io :as io))

(defn read-file [filename]
  ;; with-open is ye olde autocloseable
  (with-open [rdr (io/reader filename)]
    (reduce conj [] (line-seq rdr))
  )
)

(defn -main [& args] ;; & for variadic
  ;; filename & args destructures the head off
  (let [[filename & args] args]
    (println filename)
    (read filename)
  )
)

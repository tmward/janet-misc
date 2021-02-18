(import argparse :prefix "")

(defn in-range? [n [l r]] (<= l n r))
(defn in-ranges?  [ranges] (fn [n] (any? (map (partial in-range? n) ranges))))
(defn char-ranges [chars]
  (let [rs @{"[:digit:]" [[48 57]]
            "[:upper:]" [[65 90]]
            "[:lower:]" [[97 122]]
            "[:punct:]" [[33 37] [58 64] [91 96] [123 126]]}]
    (put rs "[:alpha:]" (tuple ;(rs "[:upper:]") ;(rs "[:lower:]")))
    (put rs "[:alnum:]" (tuple ;(rs "[:alpha:]") ;(rs "[:digit:]")))
    (put rs "[:word:]" (tuple ;(rs "[:alnum:]") [95 95]))
    (put rs "[:xdigit:]" [[48 57] [65 70] [97 102]])
    (put rs "[:graph:]" (tuple ;(rs "[:alnum:]") ;(rs "[:punct:]")))
    (put rs "[:graph:]" (tuple ;(rs "[:alnum:]") ;(rs "[:punct:]")))
    (put rs "[:print:]" (tuple ;(rs "[:graph:]") [32 32]))
    (rs chars)))

(def random-chars (generate [_ :iterate true] (first (os/cryptorand 1))))
(defn filtered-chars [pred] (generate [c :in random-chars :when (pred c)] c))
(defn random-str
  [n &opt pred]
  (default pred (in-ranges? (char-ranges "[:graph:]")))
  (let [chars (filtered-chars pred)]
    (string/from-bytes ;(seq [_ :range [0 n]] (resume chars)))))

(def params
  ["Generates a random string from OS-provided high-quality random data."
   "chars" {:kind :option
            :short "c"
            :default "[:graph:]"
            :help "POSIX character class: \"[:class:]\"."}
   "count" {:kind :option
            :short "n"
            :default "15"
            :help "Positive decimal integer."}])
(defn num-chars [n] (if-let [num (scan-number n) _ (and (pos? num) (int? num))] num))
(defn char-pred [chars] (if-let [rs (char-ranges chars)] (in-ranges? rs)))
(defn parse-args
  [{"count" cnt "chars" chars}]
  (if-let [n (num-chars cnt)
           pred (char-pred chars)]
    (tuple n pred)))

(defn main [& args]
  (if-let [raw-args (argparse ;params)
           args (parse-args raw-args)]
    (print (random-str ;args))
    ((eprint "Invalid arguments")
     (os/exit 2))))

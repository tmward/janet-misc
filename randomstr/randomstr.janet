#!/usr/bin/env janet
# this works on the CLI and does not need to be compiled
# when I used jpm build with this (moving things to (main)), it did not
# work. I suspect due to the "eval-string" so methods were not being
# picked up?

(import argparse :prefix "")

# the flatten allows us to accept 2 arguments [n (l, r)] or 3 [n, l, r]
(defn between? [n & lr] (let [[l r] (flatten lr)] (<= l n r)))
(defn digit? [n] (between? n 48 57))
(defn upper? [n] (between? n 65 90))
(defn lower? [n] (between? n 97 122))
(defn alpha? [n] (or (lower? n) (upper? n)))
(defn alnum? [n] (or (alpha? n) (digit? n)))
(defn word? [n] (or (alnum? n) (= n 95)))
(defn xdigit? [n] (or (digit? n) (between? n 65 70) (between? n 97 102)))
(defn punct?
  [n]
  (let [betwixt? (partial between? n)]
    (any? (map betwixt? [[33 37] [58 64] [91 96] [123 126]]))))
(defn graph? [n] (or (alnum? n) (punct? n)))
(defn print? [n] (or (graph? n) (= n 32)))

(def random-chars (generate [_ :iterate true] (first (os/cryptorand 1))))
(defn filtered-chars [pred] (generate [c :in random-chars :when (pred c)] c))
(defn random-str
  [n &opt char-pred]
  (default char-pred graph?)
  (let [chars (filtered-chars char-pred)]
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
(defn parse-count [n] (if-let [num (scan-number n) _ (and (pos? num) (int? num))] num))
(defn parse-chars [chars] (protect (eval-string (string (string/trim chars "[:]") "?"))))
(defn parse-args
  [{"count" cnt "chars" chars}]
  (let [n (parse-count cnt)
        [ok c] (parse-chars chars)]
    (if (and n ok)
      (tuple n c))))

(if-let [raw-args (argparse ;params)
         args (parse-args raw-args)]
  (print (random-str ;args))
  ((eprint "Invalid arguments")
   (os/exit 2)))

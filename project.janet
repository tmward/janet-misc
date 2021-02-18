(declare-project
 :name "tmw-misc-janet"
 :description "Collection of miscellaneous tools written in janet."
 :dependencies ["https://github.com/janet-lang/argparse"])

(declare-executable
 :name "randomstr"
 :entry "randomstr/randomstr-for-compilation.janet")

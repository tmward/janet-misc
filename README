# `janet-misc`

This repo holds a collection of small programs I've developed using
the [Janet Language](https://janet-lang.org/).

# Programs

## `randomstr`

Program that outputs a random string to stdout. It uses high-quality
random data provided by the operating system (e.g., /dev/urandrom on
Linux and BSD). Run with no arguments it prints out 15 characters in the
POSIX `graph` character class. I mainly use it to generate passwords. It
accepts any printable POSIX character classes as arguments (just like
[`tr(1)`](https://man.openbsd.org/tr)), such as the default "[:graph:]".

You can either make a statically-compiled executable of it (using `jpm build`)
or run it directly with `janet randomstr/randomstr.janet`). Run
`randomstr -h` for a full help message.

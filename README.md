# sitediff.sh

diff websites

# how it works

sitediff.sh will download a web page using curl, and check it against a
previously downloaded copy, reporting whether it has changed or not.

# home dir files

sitediff needs a folder to store copies of the web pages it's stalking, and
by default that folder is ~/.sitediff_prev. It also needs a config file,
which by default is ~/.sitediff_config.

# config file

The config file is a list of valid URLs, each on its own line, with a
newline at the end.
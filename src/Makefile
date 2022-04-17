#        _                 
#  _ __ (_)_ __   ___  ___ 
# | '_ \| | '_ \ / _ \/ __|
# | |_) | | |_) |  __/\__ \
# | .__/|_| .__/ \___||___/
# |_|     |_|              

HERE=$(shell git rev-parse --show-toplevel)
DATA=$(HERE)/data
SRC=$(HERE)/src

help: ## show help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| gawk 'BEGIN {FS = ":.*?## "}; \
               {printf "make \033[36m %-10s\033[0m : %s\n", $$1, $$2}'

bye:	## save to github
	git add *;git commit -am save;git push;git status

copyright: ## show copyright
	@cat $(HERE)/LICENSE

h1:; @figlet -W -flarry3d     $(read) | sed 's/^/#  /' ## large heading
h2:; @figlet -W -fcybermedium $(read) | sed 's/^/#  /' ## medium heading
h3:; @figlet -W -fsmall       $(read) | sed 's/^/#  /' ## small heading
h4:; @figlet -W -fmini        $(read) | sed 's/^/#  /' ## tiny heading

ok:; @cat - | python3 $(SRC)/ok.py -s

egok: ## example of "ok"
	 cat data/weatherwrong.csv | python3 ok.py -s

egstats1:
	@cat data/weather.csv  | python3 src/stats.py | column -s, -t

egstats2:
	@cat data/diabetes.csv  | python3 src/stats.py | column -s, -t

AUKS=$(shell ls *.auk)
auks: $(AUKS:.auk=.awk)

%.awk : %.auk
	gawk -f lib.awk --source 'BEGIN { auk2awk("'$<'")}' > $@

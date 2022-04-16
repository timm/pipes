#        _                 
#  _ __ (_)_ __   ___  ___ 
# | '_ \| | '_ \ / _ \/ __|
# | |_) | | |_) |  __/\__ \
# | .__/|_| .__/ \___||___/
# |_|     |_|              

HERE=$(shell git rev-parse --show-toplevel)
DATA=$(HERE)/data

help: ## show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| gawk 'BEGIN {FS = ":.*?## "}; \
               {printf "make \033[36m%-20s\033[0m %s\n", $$1, $$2}'

bye:	## save to github
	git add *;git commit -am save;git push;git status

copyright: ## show copyright
	@cat $(HERE)/LICENSE

egok: ## example of "ok"
	 cat data/weatherwrong.csv | python3 ok.py -s

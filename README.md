# How to build a pipe-based app
This following instructions have been tested under bash in Linux or Mac.


## Before reading this...

Before reading this material, review [these slides](https://swcarpentry.github.io/shell-novice/04-pipefilter/index.html)

## Setting up

### Step0: (optional)

List the tools you are using and place them in [requirements.txt](requirements.txt)

    # python >= 3.9
    # gawk >= 5.1
    # figlet >= 2.2
    
Tell Github what files never to save; see [.gitignore](.gitignore).

Add a copyright notice; see [LICENSE](LICENSE).

## Step1: create some shortcuts (e.g. in `pipes`)

[pipes](pipes):

    # pointer to this dir
    HERE=$(git rev-parse --show-toplevel)
    
    # command line tricks
    alias ls="ls -G"
    alias vi="vim -u $HERE/etc/dotvimrc "
    
    py()  { python3 $1.py $* ; }
    ccd() { cd $1; basename `pwd`; }
    
    PROMPT_COMMAND='echo -ne "| ";PS1="$(ccd ..)/$(ccd .):\!\e[m ▶ "'

Load these into the current shell

    . pipes

## Step1: make a `Makefile`

Build a traffic cop:
- Some place to store all the little idioms that you are about to create.

Makefile's contain actions  to achieve goals using prerequisites.
- and if you run the code twice, then the second time nothing happens (unless the prereqs have been updated)


    goal : prerequisite ## help text
          actions (to generate "target" from prerequisite)

e.g.

    all.csv : monday.csv tuesday.csv wednesday.csv thursday.csv friday.csv
        cat $* > $@


Simple tasks have no pre-reqs and will run every time. For example,
calling `make bye` does all the saving to Github

e.g.

     bye:	## save to github
     	   git add *;git commit -am save;git push;git status

## Step2: self-document the `Makefile`

Add this rule to top of the `Makefile`:

    help: ## show help
    	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
    	| sort \
    	| gawk 'BEGIN {FS = ":.*?## "}; \
                   {printf "make \033[36m%-20s\033[0m %s\n", $$1, $$2}'

Now your make file can report its own commands:

    > make

    make bye                  save to github
    make copyright            show copyright
    make egok                 example of "ok"
    make help                 show help
    


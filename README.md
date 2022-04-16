# How to build a pipe-based app
This following instructions have been tested under bash in Linux or Mac.


## Before reading this...

Before reading this material, review [these slides](https://swcarpentry.github.io/shell-novice/04-pipefilter/index.html)

## 1. Setting up

### Step 1a: (optional)

List the tools you are using and place them in [requirements.txt](requirements.txt)

    # python >= 3.9
    # gawk >= 5.1
    # figlet >= 2.2
    
Tell Github what files never to save; see [.gitignore](.gitignore).

Add a copyright notice; see [LICENSE](LICENSE).

## Step 1b: create some shortcuts (e.g. in `pipes`)

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

## Step 1c: make a `Makefile`

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

## Step 2: Add self-documentation 

## Step 2a: Self-document the `Makefile`

Add this rule to top of the `Makefile`:

```make
help: ## show help
    grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
    | sort \
    | gawk 'BEGIN {FS = ":.*?## "}; \
               {printf "make \033[36m%-20s\033[0m %s\n", $$1, $$2}'
```

Now your make file can report its own commands:

    > make

    make bye                  save to github
    make copyright            show copyright
    make egok                 example of "ok"
    make help                 show help
    
## Step 2b: Self-document your scripts

Write the help text for an app at the top of each file. e.g.

    """
    cat csvFile | python3 ok.py [OPTIONS]
    Check csv rows are right size. Optionally, check if cells are of right type.
    Print rows that pass all tasks. After more than `-q` problems, exit
    
    OPTIONS:
      --strict -s     use row1 to define checks for other rows = False
      --warn  -w int  number of warnings before quitting       = 20
      --help -h       show help                                = False
    """

Include the comments command line flags. Here:

- Such flags start on lines with two blanks and two dashes `"  --"`
- Those lines list a long flag, a short flag, some help text, and (as a final word
  on the line), the default value.
- If there is a command line flag that matches the short or long flag, then
  we will update the default.
- All this will end up as a setting whose key is from the long flag; e.g. the
  keys from the above would create the dictionary:
  - `{'strict': False, 'warn': 20, 'help':False}`


```python
def cli(s):
  d, pattern = {}, r"  (--(\S+))[\s]+(-[\S]+)[\s]+[^\n]*\s([\S]+)"
  for (want1,key,want2,x) in re.findall(pattern,s):  
     for at,flag in enumerate(sys.argv):            
       if flag==want1 or flag==want2: x=sys.argv[at+1])
     d[key] = atom(x)                             
  if d.get("help",True): print(s) # print the help text (if the help key set)
  return d

def atom(x):
  x = x.strip()
  if x=="True" : return True
  if x=="False": return False
  try: return int(x)
  except:
    try: return float(x)
    except: return x

settings = cli(__doc__)
```

Place that `cli` code  in some (e.g.) `lib.py` file that all your small scripts
can read. 

## Step3

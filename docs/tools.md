| <img width=200 src="/etc/img/setup.jpg"> | [intro](/docs/pipes101.md)    | [demos](https://swcarpentry.github.io/shell-novice/04-pipefilter/index.html)    | [tools](/docs/tools.md) | oneLiners: [some](https://librarycarpentry.org/lc-shell/05-counting-mining), [lots more](https://github.com/onceupon/Bash-Oneliner) | [mining](https://teaching.idallen.com/cst8207/13w/notes/805_data_mining.html)   | textmine [one](https://williamjturkel.net/2013/06/15/basic-text-analysis-with-command-line-tools-in-linux/), [two](https://towardsdatascience.com/text-mining-on-the-command-line-8ee88648476f)   |
| -------------------------                | ---------------------------- | ------------------------------------------------------------------------------- | ----------------------- | ------------------------------------------------------------------------------------------                                          | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

# Writing Pipe-based Tools
## Setting up
### Step 1a: (optional)

    
Tell Github what files never to save; see [.gitignore](.gitignore).

Add a copyright notice; see [LICENSE](LICENSE).

List the tools you are using and place them in [requirements.txt](requirements.txt)

    # python >= 3.9
    # gawk >= 5.1
    # figlet >= 2.2

## Step 1b: create some shortcuts (e.g. in `etc/dotbashrc`)

[dotbashrc](/etc/dotbashrc):

```sh
# home useful short cuts
alias ..='cd ..'
alias ...='cd ../../../'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias h="history"
alias ls="ls -G"

# my favorite editor. install these tricks with tricks with `vims`
alias vi="vim -u $here/etc/dotvimrc "
alias vims="vi +PluginInstall +qall"         

py()  { python3 $here/src/$1.py $* ; }

# path stuff
export PATH="$PWD:/opt/homebrew/bin:$PATH"
export PYTHONPATH="$here/src:$PYTHONPATH"

# prompts tuff
ccd() { cd $1; basename `pwd`; }
[PROMPT_COMMAND](PROMPT_COMMAND)='echo -ne "🚰 ";PS1="$(ccd ..)/$(ccd .):\!\e[m ▶ "'
```

The write a loader (e.g. `/pipes`)

Load these into the current shell

[pipes](pipes)

     #!/usr/bin/env bash
     # vim: ft=bash ts=2 sw=2 sts=2 et :
     export BASH_SILENCE_DEPRECATION_WARNING=1
      
     here="$(cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )"
     here="$here" bash --init-file "$here/etc/dotbashrc" -i

Then load all that

     ./pipes

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

<p align=center><img src="/etc/img/doc.png" width=400> </p>

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

    $ make

    make bye                  save to github
    make copyright            show copyright
    make egok                 example of "ok"
    make help                 show help
    
## Step 2b: Self-document your scripts

Write the help text for an app at the top of each file. e.g. in [ok.py](ok.py):

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

Now all your scripts can print their help text:

    $ py ok -h

    cat csvFile | python3 ok.py [OPTIONS]
    Check csv rows are right size. Optionally, check if cells are of right type.
    Print rows that pass all tasks. After more than `-q` problems, exit
    
    OPTIONS:
      --strict -s     use row1 to define checks for other rows = False
      --warn  -w int  number of warnings before quitting       = 20
      --help -h       show help                                = False

## Step3: Divide 

Divide you app into lots of bits e.g.

<table>
<tr>
<td> Com   </td><td> Command </td><td> Flags </td></tr>
<tr>
<td> py&nbsp;ok   </td><td> -s  </td><td> 
Checks if a csv file has the right number of cells on each row.
If `-s` is used, also check columns are of the right type</td>
</tr>
<tr>
<td> py&nbsp;ok   </td><td> -s  </td><td> 
Checks if a csv file has the right number of cells on each row.
If `-s` is used, also check columns are of the right type</td>
</tr>
<tr>
<td> py&nbsp;ok   </td><td> -s  </td><td> 
Checks if a csv file has the right number of cells on each row.
If `-s` is used, also check columns are of the right type</td>
</tr>
</table>


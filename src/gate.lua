#!/usr/bin/env lua
local b4={}; for k,_ in pairs(_ENV) do b4[k]=k end
local cat,cat2,cli,coerce,csv,fmt,help,key
local last,list,main,new,obj,q,the,words

function main()
  return help(list(
    "\nlua gate.lua [OPTIONS]",
    "(c) 2022 Tim Menzies        \n",
    "OPTIONS:                      ",
    "  --file  data file          = ../data/auto93.csv",
    "  --seed  random number seed = 10019",
    "  --bins  number bins        = 10",
    "  --help  show help text     = false",
    "  --copy  show copyright     = false")) end

--    _  |  o 
--   (_  |  | 
--            
function help(t,    u) 
  function cli(key,  x)
    for i,flag in pairs(arg) do
      if flag == "--"..key then 
        x = x=="true" and "false" or x=="false" and "true" or arg[i+1] end end
    return x end
  u={}; for s in q(t)  do 
          s=words(s," ") 
          if s[1]:sub(1,2)=="--" then 
            u[ s[1]:sub(3) ] = coerce(cli( s[1]:sub(3) ,last(s))) end end
  return u["help"] and os.exit(print(cat(t,"\n"))) or u end
                     
--   |  o   _  _|_   _ 
--   |  |  _>   |_  _> 

function list(...) return {...} end

function last(t) return t[#t] end

function q(t,   m,n)
  m,n = 0,#t
  return function() if m<n then m=m+1; return t[m] end end end

--    _  _|_  ._  o  ._    _    _ 
--   _>   |_  |   |  | |  (_|  _> 
--                         _|     
fmt=string.format
function words(s,sep,   t)
  sep= "([^"..(sep or ",").."]+)"
  t={}; for y in s:gmatch(sep) do t[1+#t]=y end; return t end

function coerce(x)
  x = x:match"^%s*(.-)%s*$"
  if x=="true" then return true elseif x=="false" then return false end
  return math.tointeger(x) or tonumber(x) or x end

function cat(t,sep,  s,u) 
  u,sep = "",sep or ", "
  s=""; for _,x in pairs(t) do s=s..u..tostring(x); u=sep end
  return s end

function cat2(t,sep,  s,u) 
  u,sep = "",sep or ", "
  s=""; for k,x in pairs(t) do s=s..u..fmt("%s %s",k,x); u=sep end
  return (t.is or "").."{"..s.."}" end

function csv(src,      things)
  function things(t) for i,x in pairs(t) do t[i]=coerce(x) end; return t end 
  src = io.input(src)
  return function(x) x=io.read()
    if x then return things(words(x)) else io.close(src) end end end 

--    _  |   _.   _   _   _    _ 
--   (_  |  (_|  _>  _>  (/_  _> 

function new(klass,...) 
  local obj = setmetatable({},klass)
  local res = klass.new(obj,...) 
  if res then obj = setmetatable(res,klass) end
  return obj end 

function obj(name,    t)
  t={__tostring=cat2, is=name or ""}; t.__index=t
  return setmetatable(t, {__call=new}) end

-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
the=main()
for row in csv(the.file) do print(cat(row)) end

for k,v in pairs(_ENV) do if not b4[k] then print("?",k,type(v)) end  end

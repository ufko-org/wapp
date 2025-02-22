# CLI and Web scripting with Tcl soul

This is a fork of [wapp.tcl.tk](https://wapp.tcl.tk), maintained with
custom changes and updates.  The goal is to add features that I
personally need, whether in the interpreter or the API.  My changes are
documented in this *README.md* file.  For everything else, refer to the
original documentation: https://wapp.tcl.tk/home/doc/trunk/README.md

--

This fork is used to run [ufko.org](https://ufko.org/env)

--

## Installation and running

For the installation and running instructions, please follow these
simple steps in this wiki page:   
[Installation steps](https://github.com/ufko-org/wapp/wiki/Installation-steps)

## Advantages of using Wapp instead of tclsh

Everything is built into a single, statically built (~3.7M stripped in my case) binary file:

- TCL 9 interpreter
- Wapp framework
- SQLite3 interface
- Any additional Tcl script

This means it could run in various environments, **including jails**,
without external dependencies.  The static compilation ensures
portability and simplicity in deployment.

```
$: ./wapptclsh

 _ _ _
| | | |___ ___ ___
| | | | .'| . | . |
|_____|__,|  _|  _|
          |_| |_|

Wapp 1.0 shell using SQLite version 3.50.0 and TCL 9.0
% Markdown::convert "# Heading1"
<h1>Heading1</h1>
% datetime "%Y-%m-%d %H:%M:%S" "'now', '+1 day'"
2025-02-21 07:06:50
% datetime "%Y-%m-%d %H:%M:%S" "'now', '+1 day', 'localtime'"
2025-02-21 08:07:13
%

$: ./wapptclsh script.tcl
Hello World!

Implement proc main in the app.tcl and ship it as a single file:
$: echo 'proc main {} { puts "All in one" }' >> app.tcl
$: make clean wapptclsh
$: ./wapptclsh
All in one

Create your first wapplication:
$: echo 'proc wapp-default {} { wapp-trim { Hello web! } }; wapp-start $argv' > index.cgi
$: ./wapptclsh index.cgi --server 8082
Listening for HTTP requests on TCP port 8082
$: curl http://localhost:8082
Hello web!
```

### **wapptclsh**  

- Is a pure C program with zero dependencies, no external libraries required 
- Runs seamlessly on Unix, Linux, macOS, and Windows, making it a truly portable solution.
- Runs as an interactive shell (REPL) when executed without arguments.
- Can be used for CLI scripting as an alternative to tclsh.
- Functions as a CGI interpreter for writing web applications.
- Easily compiles any Tcl code directly into the executable.

## Additional Files  

These files are optional and serve to demonstrate how to extend the
functionality of `wapptclsh`.  If you want to exclude these files from
the build process, please edit the `Makefile` and `wapptclsh.c.in` file.

- **functions.tcl** - A collection of useful, custom functions that 
extend the core capabilities of wapptclsh. These functions can simplify 
common tasks and improve the usability of your projects. This file serves 
as a great starting point for adding your own helper functions or utilities 
to enhance the Tcl environment within Wapp.
- **markdown.tcl** – A modified version of the Tcllib Markdown processor
with all external dependencies removed.  This ensures it runs
independently within the Wapp framework. The markdown.tcl code could be 
moved to functions.tcl, but since it is extensive, I decided to keep it 
in a separate file. Finally, not everyone needs markdown processing, 
so it makes sense.
- **app.tcl** – A utility file for including the entire application in 
the interpreter binary. After modifying `app.tcl`, 
**you need to rebuild the binary** to include the changes.

	If you use Wapp for writing a CLI application, you can move all the code
	that would normally be run with:

	```sh
	wapptclsh myscript.tcl
	```  

	into `app.tcl` and implement the `main` function there.  It will then
	run automatically instead of the interactive shell.

	If you use Wapp for writing a web application, you can move the code
	from the main file (e.g., `index.cgi`) into `app.tcl`.  Then,
	`index.cgi` can be simplified to:

	```sh
	#!/path/to/wapptclsh
	wapp-start $argv
	```  

	This way, you **can** ship the entire web application as
	part of the interpreter binary, bringing these advantages:

	- The entire application code is outside the document root.  
	- Deployment is just a matter of copying the new `wapptclsh` binary to the server.

## Makefile 

Note that I had change the compiler from gcc to cc and remove `-ldl`
from `Makefile` because OpenBSD does not have `libdl`, and since I do
not use other operating systems, I cannot test the `Makefile` on
different platforms.

## Changelog  

### `proc randhex`

Added to generate a random hexadecimal string using SQLite’s randomblob() 
for top-notch randomness.  
See: [functions.tcl](https://github.com/ufko-org/wapp/blob/main/functions.tcl) : proc randhex

### `proc test`

Added as a no-nonsense test helper. Takes an expected value - either 
a fixed one or a regex wrapped in //. Ditch the bloated test suites.  
See: [functions.tcl](https://github.com/ufko-org/wapp/blob/main/functions.tcl) : proc test

### `proc parray`

Added as a replacement for the missing `parray` command and for
convenience.  
See: [functions.tcl](https://github.com/ufko-org/wapp/blob/main/functions.tcl) : proc parray

### `proc datetime`

Added as a replacement for the missing `clock` command and for
convenience.  
See: [functions.tcl](https://github.com/ufko-org/wapp/blob/main/functions.tcl) : proc datetime

### `proc wapp-set-cookie`  

Now supports setting an expiry time and a secure flag.  

#### Setting Cookies  
```tcl
wapp-set-cookie session val
wapp-set-cookie session-secure val 0 secure
wapp-set-cookie timed val 3600
wapp-set-cookie timed-secure val 3600 secure
```

### `proc wapp-clear-cookie`  

#### Clearing Cookies  
```tcl
wapp-clear-cookie session
wapp-clear-cookie session-secure "" -1 secure
wapp-clear-cookie timed "" -1
wapp-clear-cookie timed-secure "" -1 secure
```

## Available commands

```
after
append
apply
array
binary
break
catch
cd
chan
close
concat
const
continue
coroinject
coroprobe
coroutine
datetime
dict
encoding
eof
error
eval
exec
exit
expr
fblocked
fconfigure
fcopy
file
fileevent
flush
for
foreach
format
fpclassify
gets
glob
global
if
incr
info
interp
join
lappend
lassign
ledit
lindex
linsert
list
llength
lmap
load
lpop
lrange
lremove
lrepeat
lreplace
lreverse
lsearch
lseq
lset
lsort
namespace
open
package
parray
pid
proc
puts
pwd
randhex
read
regexp
regsub
rename
return
scan
seek
set
socket
source
split
sqlite
sqlite3
string
subst
switch
tailcall
tell
test
throw
time
timerate
trace
try
unload
unset
update
uplevel
upvar
variable
vwait
wapp
wapp-allow-xorigin-params
wapp-before-dispatch-hook
wapp-before-reply-hook
wapp-cache-control
wapp-clear-cookie
wapp-content-security-policy
wapp-debug-env
wapp-mimetype
wapp-param
wapp-param-exists
wapp-param-list
wapp-redirect
wapp-reply-code
wapp-reply-extra
wapp-reset
wapp-safety-check
wapp-set-cookie
wapp-set-param
wapp-start
wapp-subst
wapp-trim
wapp-unsafe
wappInt-%HHchar
wappInt-close-channel
wappInt-decode-query-params
wappInt-decode-url
wappInt-enc
wappInt-enc-html
wappInt-enc-qp
wappInt-enc-string
wappInt-enc-unsafe
wappInt-enc-url
wappInt-gzip-reply
wappInt-handle-cgi-request
wappInt-handle-request
wappInt-handle-request-unsafe
wappInt-http-readable
wappInt-http-readable-unsafe
wappInt-new-connection
wappInt-parse-header
wappInt-scgi-readable
wappInt-scgi-readable-unsafe
wappInt-start-browser
wappInt-start-listener
wappInt-trace
wapptclsh_init
while
yield
yieldto
zipfs
zlib
```

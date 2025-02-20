# Let's give wapp.tcl.tk a new dimension

This is a fork of [wapp.tcl.tk](https://wapp.tcl.tk), maintained with
custom changes and updates.  The goal is to add features that I
personally need, whether in the interpreter or the API.  My changes are
documented in this *README.md* file.  For everything else, refer to the
original documentation: https://wapp.tcl.tk/home/doc/trunk/README.md

--

This fork is used to run [ufko.org](https://ufko.org/env)

--

## Why not zipfs

My opinion on zipfs is explained [here in discussion](https://github.com/ufko-org/wapp/discussions/6)

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
```

### **wapptclsh**  

- Is a pure C program, while the static tclsh is a ZipFS binary.
- Runs as an interactive shell (REPL) when executed without arguments.
- Can be used for CLI scripting as an alternative to tclsh.
- Functions as a CGI interpreter for writing web applications.
- Includes a straightforward mechanism for compiling any Tcl code directly into it

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
- **app.tcl** – A utility file for including reusable components or the
entire application logic.  So if, for example, you often use the
hello_world function in your projects and you expect not to change it
frequently, you can place it right here :)

	If you use Wapp for writing a web application, you can put all the
  code that would normally be in, for example, `index.cgi`, into
	`app.tcl`, and then `index.cgi` only contains:

  ```tcl
  #!/path/to/wapptclsh
  wapp-start $argv
  ```  

	The application will then become part of the interpreter's binary with
	these advantages:

	- entire application code is outside of the document root
	- deployment equals to copy new `wapptclsh` binary to the server


## Makefile 

Note that I had change the compiler from gcc to cc and remove `-ldl`
from `Makefile` because OpenBSD does not have `libdl`, and since I do
not use other operating systems, I cannot test the `Makefile` on
different platforms.

## Changelog  

### `proc datetime`

Added as a replacement for the missing 'clock' command and for
convenience.  
See: [functions.tcl](https://github.com/ufko-org/wapp/blob/main/functions.tcl), proc datetime

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
initialize_wapptclsh
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
pid
proc
puts
pwd
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
while
yield
yieldto
zipfs
zlib
```

# Wapp – Fork of wapp.tcl.tk  

This is a fork of [wapp.tcl.tk](https://wapp.tcl.tk),
maintained with custom changes and updates.  The goal is to add features
that I personally need, whether in the interpreter or the API.  This
fork is not meant to fix issues in the original project but simply to
adapt it to my own use.  If someone finds these additions useful, they
are welcome to use this version; otherwise, they can stick with the
original.  My changes are documented in this *README.md* file.  For
everything else, refer to the original documentation:
https://wapp.tcl.tk/home/doc/trunk/README.md

This fork is used to run [ufko.org](https://ufko.org)

--

## Advantages of using Wapp

Everything is built into a single, statically compiled binary file:

- TCL 9 interpreter
- Wapp framework
- SQLite3 interface

This means it could run in various environments, **including jails**,
without external dependencies.  The static compilation ensures
portability and simplicity in deployment.

## Interpreter properties 

### **wapptclsh**  

- Runs as an interactive shell (REPL) when executed without arguments.
- Can be used for CLI scripting as an alternative to tclsh.
- Functions as a CGI interpreter for writing web applications.
- Includes markdown.tcl, enabling built-in Markdown processing.
- Includes app.tcl, allowing easy inclusion of reusable application logic.

## Additional Files  

These files are optional and serve to demonstrate how to extend the
functionality of `wapptclsh`.  If you want to exclude these files from
the build process, please edit the `Makefile` and `wapptclsh.c.in` file.

- **markdown.tcl** – A modified version of the Tcllib Markdown processor
with all external dependencies removed.  This ensures it runs
independently within the Wapp framework.
- **app.tcl** – A utility file for including reusable components or the
entire application logic.  So if, for example, you often use the
hello_world function in your projects and you expect not to change it
frequently, you can place it right here :)

  If your entire application is included in `app.tcl`, then `index.cgi` only needs:  

  ```tcl
  #!/path/to/wapptclsh
  wapp-start $argv
  ```  

  This keeps `index.cgi` minimal and easier to maintain. This also means that:

	- entire application code is outside of the document root
	- deployment equals to copy new `wapptclsh` binary to the server


## Makefile 

Note that I had to remove `-ldl` from `Makefile` because OpenBSD does
not have `libdl`, and since I do not use other operating systems, I
cannot test the `Makefile` on different platforms.

## API Changes  

### `wapp-set-cookie`  

Now supports setting an expiry time and a secure flag.  

#### Setting Cookies  
```tcl
wapp-set-cookie session val
wapp-set-cookie session-secure val 0 secure
wapp-set-cookie timed val 3600
wapp-set-cookie timed-secure val 3600 secure
```

#### Clearing Cookies  
```tcl
wapp-clear-cookie session
wapp-clear-cookie session-secure "" -1 secure
wapp-clear-cookie timed "" -1
wapp-clear-cookie timed-secure "" -1 secure
```

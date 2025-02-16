# wapp – Fork of wapp.tcl.tk

This is a fork of [wapp.tcl.tk](https://wapp.tcl.tk), maintained
independently with custom patches and updates.  All changes will be
documented in this *README.md* file.

**wapp-set-cookie** – Now accepts a cookie expiry time and a secure flag.

```
Set examples:
wapp-set-cookie session val
wapp-set-cookie session-secure val 0 secure
wapp-set-cookie timed val 3600
wapp-set-cookie timed-secure val 3600 secure

Clear examples:
wapp-clear-cookie session
wapp-clear-cookie session-secure "" -1 secure
wapp-clear-cookie timed "" -1
wapp-clear-cookie timed-secure "" -1 secure
```

**wapptclsh** – Can be run as a shell (REPL) when invoked without arguments.

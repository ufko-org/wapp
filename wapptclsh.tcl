# This script runs to initialize wapptclsh.
#
proc wapptclsh_init {} {
  global argv argv0 main_script
	set wapp_version "1.0"

  if {[llength $argv]==0} {
		if {[info commands main] eq "main"} {
			main
			exit
		} 
		puts "
 _ _ _             
| | | |___ ___ ___ 
| | | | .'| . | . |
|_____|__,|  _|  _|
          |_| |_|  
"
		puts "Wapp $wapp_version shell using SQLite version [sqlite3 -version]\
				  and TCL $::tcl_version"
		puts " "
		return
  } else {
    set script [lindex $argv 0]
  	if {[string index $script 0]=="-"} {
    	set opt [string trim $script -]
   	 	if {$opt=="v" || $opt=="version"} {
      	puts stderr "Wapp $wapp_version using SQLite version [sqlite3 -version]\
                     and TCL $::tcl_version"
			} elseif {$opt=="h" || $opt=="help"} {
				puts stderr "Usage: $argv0 FILENAME \[--server port\]"
        puts stderr "Options:"
        puts stderr "   -v --version        Show version information"
        puts stderr "   -h --help           Show this help message"
        puts stderr "      --server port    Start the server on the given port"
        puts stderr "If no arguments are provided, an interactive shell is started."
				puts stderr "See also project homepage: https://github.com/ufko-org/wapp"
    	} else {
				puts "Unknown option: -$opt, use -h --help for help"
    	}
    	exit 1
  	} elseif {[file readable $script]} {
    	set fd [open $script r]
    	set main_script [read $fd]
    	close $fd
    	set argv [lrange $argv 1 end]
    	set argv0 $script
  	} else {
			puts stderr "Error: File \"$script\" does not exist or has incorrect permissions."
			exit 
  	}
	}
}

wapptclsh_init

# This script runs to initialize wapptclsh.
#
proc initialize_wapptclsh {} {
  global argv argv0 main_script
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
		puts "Wapp 1.0 shell using SQLite version [sqlite3 -version]\
				  and TCL $::tcl_version"
		return
  } else {
    set script [lindex $argv 0]
  }
  if {[string index $script 0]=="-"} {
    set opt [string trim $script -]
    if {$opt=="v"} {
      puts stderr "Wapp using SQLite version [sqlite3 -version]\
                   and TCL $::tcl_version"
    } else {
      puts stderr "Usage: $argv0 FILENAME"
      puts stderr "Options:"
      puts stderr "   -v      Show version information"
    }
    exit 1
  } elseif {[file readable $script]} {
    set fd [open $script r]
    set main_script [read $fd]
    close $fd
    set argv [lrange $argv 1 end]
    set argv0 $script
  } else {
    puts stderr "unknown option: \"$script\"\nthe --help option is available"
  }
}
initialize_wapptclsh

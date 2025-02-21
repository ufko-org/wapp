# These are functions that I think are useful for everyday use. 
# Not all functions in this file may have the most optimized 
# implementation, but I guarantee that they work as intended. 
# The focus is on functionality first, and improvements can be 
# made over time to enhance performance.
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
# Function: datetime
# Added as a replacement for the missing 'clock' command and for 
# convenience. Function is platform-independent, which is especially 
# useful when working in environments like jails or on systems where 
# external tools (like date) are not available.
# See: https://www.sqlite.org/lang_datefunc.html
#
# Arguments:
#  - format: The datetime format (uses SQLite's strftime format)
#            Defaults to ISO 8601 (YYYY-MM-DD HH:MM:SS)
#  - mods:   Modifiers (uses SQLite's date time modifiers)
#            Defaults to the current local date and time
#
# Usage examples:
# datetime
# datetime "%Y-%m-%d %H:%M:%S" "'now', '+1 day'"
# datetime "%Y-%m-%d" "'now','start of year','+9 months','weekday 2'"
# datetime "%s"
# ---------------------------------------------------------------------
proc datetime {{fmt "%Y-%m-%d %H:%M:%S"} {mods "'now', 'localtime'"}} {
  set sql "SELECT strftime('$fmt', $mods);"
  if {[info commands db] eq "db"} {
    set result [db one $sql]
    return $result
  } else {
    sqlite3 __db :memory:
    set result [__db one $sql]
    __db close
    return $result
  }
}

# ---------------------------------------------------------------------
# Function: parray
# Displays the contents of an array with custom formatting. This function
# allows filtering by key and/or value. It is useful when working with
# Tcl arrays, providing a convenient way to format and display array data
# with optional key and value filters.
#
# Arguments:
#  - arrayName: The name of the array (passed by reference).
#  - keyfilter: A pattern used to filter the array keys 
#    default is '*', meaning no filtering
#  - valuefilter: A nocase pattern used to filter the array values 
#    default is '*', meaning no filtering
#
# Usage examples:
# parray myArray
# parray myArray "ba*"
# parray myArray "*" "value*"
# parray myArray "key1" "value1"
# ---------------------------------------------------------------------
proc parray {arrayName {keyfilter *} {valuefilter *}} {
  upvar 1 $arrayName __a
  if {![array exists __a]} {
    return -code error "Variable: \"$arrayName\" isn't an array"
  }

  set maxlen 0
  set names [lsort [array names __a $keyfilter]]

  # Find the maximum name length
  foreach name $names {
    if {[string length $name] > $maxlen} {
      set maxlen [string length $name]
    }
  }

  set maxlen [expr {$maxlen + [string length $arrayName] + 2}]

  # Display the array with custom formatting
  foreach name $names {
		if {[string match -nocase "$valuefilter" $__a($name)]} {
			set key_string [format %s(%s) $arrayName $name]
			puts stdout [format "%-*s = %s" $maxlen $key_string $__a($name)]
		}
  }
}

# ---------------------------------------------------------------------
# Function: test
# My simple test suite :) It's sufficient for most use cases where
# you don't need advanced features. It's lightweight, easy to use, 
# and it can handle basic test scenarios well. The function is flexible 
# enough for quick testing of functions, commands, and database 
# interactions. If you're looking for something simple and effective, 
# this is the way to go!
# 
# The test suite supports two types of comparison:
# 1. `regexp`: If the expected value is wrapped in slashes (`/`), 
#    a regular expression comparison is performed. This allows 
#    flexibility when you need to match patterns in the result.
# 2. `eq`: If the expected value is not wrapped in slashes, 
#    a direct string comparison is used, meaning the result must
#    match the expected value exactly.
# ---------------------------------------------------------------------
# Usage:
# test testname {
#   testbody
# } {expected}
#
# The testbody is a block of Tcl code that will be evaluated, and the 
# result is compared to the expected value (expected). 
# If the comparison passes, the test is marked as "PASS"; otherwise, 
# it will be marked as "FAIL". 
# ---------------------------------------------------------------------
proc test {testname testbody {expected {}}} {
  set fail_line 0
  set result [eval $testbody]
  
	# Check if we want a regexp comparison; the expected value 
	# is between / and /
  if {[regexp {^/.*/$} $expected]} {
    # Perform regexp comparison
		set expected [string range $expected 1 end-1] ;# remove the slashes
    if {[regexp "^${expected}\$" $result]} {
      puts "PASS: $testname"
    } else {
      set fail_line [lindex [info frame -1] 3]
      puts "FAIL: $testname, want: $expected, got: $result line: $fail_line"
    }
  } else {
    # Perform simple string comparison
    if { $result eq $expected } {
      puts "PASS: $testname"
    } else {
      set fail_line [lindex [info frame -1] 3]
      puts "FAIL: $testname, want: $expected, got: $result line: $fail_line"
    }
  }
}

# ---------------------------------------------------------------------
# Function: randhex 
# Generates a random hexadecimal string using SQLite if available,  
# otherwise falls back to an in-memory SQLite instance.  
#  
# Arguments:  
# length (default: 16) - Number of random bytes to generate.  
#                        Each byte is converted to 2 hex characters,  
#                        so the output length is length * 2 characters.  
#  
# Behavior:  
#   - If the global "db" command exists (assumed to be an active SQLite connection),  
#     it is used directly for efficiency. (~35 µs in my case) 
#   - If "db" does not exist, a temporary SQLite database is created in RAM  
#     to execute the query, which adds some overhead (~2500 µs in my case).  
#  
# Notes:  
#   - SQLite's randomblob() provides high-quality randomness,  
#     superior to Tcl's built-in rand().  
#   - Optimized for web applications where an active database connection is 
#      usually available.  
# ---------------------------------------------------------------------
proc randhex {{length 16}} {
	set sql "SELECT lower(hex(randomblob($length)))"
  if {[info commands db] eq "db"} {
    set result [db one $sql]
    return $result
  } else {
    sqlite3 __db :memory:
    set result [__db one $sql]
    __db close
    return $result
  }
}

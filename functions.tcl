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
# Parameters:
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
# Parameters:
#  - arrayName: The name of the array (passed by reference).
#  - keyfilter: A pattern used to filter the array keys 
#    default is '*', meaning no filtering
#  - valuefilter: A pattern used to filter the array values 
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
    return -code error "\"$arrayName\" isn't an array"
  }

  set maxl 0
  set names [lsort [array names __a $keyfilter]]

  # Find the maximum name length
  foreach name $names {
    if {[string length $name] > $maxl} {
      set maxl [string length $name]
    }
  }

  set maxl [expr {$maxl + [string length $arrayName] + 2}]

  # Display the array with custom formatting
  foreach name $names {
		if {[string match -nocase "$valuefilter" $__a($name)]} {
			set key_string [format %s(%s) $arrayName $name]
			puts stdout [format "%-*s = %s" $maxl $key_string $__a($name)]
		}
  }
}

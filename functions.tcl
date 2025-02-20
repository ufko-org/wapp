# These are functions that I think are useful for everyday use. 
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
    set result [db eval $sql]
    return $result
  } else {
    sqlite3 __db :memory:
    set result [__db eval $sql]
    __db close
    return $result
  }
}

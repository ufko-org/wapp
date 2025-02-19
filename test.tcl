proc datetime {{fmt "%Y-%m-%d %H:%M:%S"} {mods "'now', 'localtime'"}} {
	set sql "SELECT strftime('$fmt', $mods);"
  if {[info command db] eq "db"} {
    set result [db eval $sql]
		return $result
  } else {
    sqlite3 __db :memory:
    set result [__db eval $sql]
    __db close
    return $result
  }
}

puts [datetime]
puts [datetime "%Y-%m-%d %H:%M:%S" "'now', '+1 day'"]
puts [datetime "%Y-%m-%d" "'now','start of year','+9 months','weekday 2'"]
puts [datetime "%s"] ;# unix timestamp

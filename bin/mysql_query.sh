# mysql connection params
host=localhost
port=3306
user=ssuser
pass=ssuser

# example mysql_query "select * from table;"
function mysql_query() {
  echo "mysql_query Running $@"
  echo $@|mysql -h $host -u $user --password=$pass --port=$port
}

# run a .sql script file
function mysql_query_file() {
  echo "mysql file query running $@"
  mysql -h $host -u $user --password=$pass --port=$port < "$@"
}

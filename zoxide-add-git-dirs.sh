#!/usr/bin/env bash

# list all directories
projects=$(fd -H -I -g **/.git -E /.git -E **/.git/** -E /external/**)

for project in ${projects};
do
  dir_name=${project%/.git/}
  zoxide add "$dir_name"
done

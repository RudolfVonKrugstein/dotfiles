#!/usr/bin/env bash

# ensure we are at the gws directory
if [ ! -f .projects.gws ]; then
  echo "Not in GWS directory"
  exit 1
fi

# list all directories
projects=$(fd -H -I -g **/.git -E /.git -E **/.git/** -E /external/**)

for project in ${projects};
do
  project_name=${project%/.git/}
  if ! grep "${project_name}" .projects.gws > /dev/null; then
    pushd "${project_name}" > /dev/null || exit 1
    origin=$(git config --get remote.origin.url)
    popd > /dev/null || exit 1
    if [ "$origin" == "" ]; then
      continue
    fi
    echo "${project_name} | ${origin}"
  fi
done

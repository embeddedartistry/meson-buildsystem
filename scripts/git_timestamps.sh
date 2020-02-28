#!/bin/bash

# This script will iterate through your git repository and set the file timestamps
# to their last modification date in git history.
# Why do this sort of thing, you ask?
# Well, mostly, to produce deterministic zip files. Different timestamps resulting from
# different clone times can produce different MD5 hashes for the same file contents.
# This is because timestamps get saved. So we overwrite them.
# Other archive formats may also benefit from a deterministic timestamp method.

find . -exec touch -t `git ls-files -z . | \
  xargs -0 -n1 -I{} -- git log -1 --date=format:"%Y%m%d%H%M" --format="%ad" {} | \
  sort -r | head -n 1` {} +

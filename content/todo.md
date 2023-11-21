title: TODO: Don't forget to remove

subtitle: Keep track of the things you planned to do later

tags: Productivity

date: 2023-11-21

---

Coding all day
adding todos to help not forget something for later
but than while searching the code for TODO: I get 1000000 result
I started by adding a small emoji to identify the latest todos but it wasn't easy enough to track
so I wrote this script to search for all the todos added on the current branch

```
#!/bin/sh
branch=`git rev-parse --abbrev-ref HEAD`
parent_branch=`git show-branch -a 2>/dev/null | grep '\*' | grep -v "$branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'`
git diff $parent_branch | grep "^+.*TODO"
```

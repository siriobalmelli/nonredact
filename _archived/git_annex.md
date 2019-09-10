---
layout:		default
title:		Git Annex Notes
date:		2019-09-10
categories: articles
---

# Git Annex Notes

I am moving to git-annex to extend my use of Git for *all* of my files.

No more Dropbox, Google Drive, Tresorit, etc.
Just [Git Annex](https://git-annex.branchable.com/),
[gcrypt](https://github.com/spwhitton/git-remote-gcrypt)
and pretty much any remote (Git__b anyone?).

Git-annex deserves a thorough introduction,
which will have to be the subject of a separate article.
In the meantime, these are my notes as I go through this transition.

"Why not [git-lfs](https://git-lfs.github.com/)" you might ask?

- git-annex has very comprehensive tracking of remotes.
- git-lfs [does not work over SSH](https://github.com/git-lfs/git-lfs/issues/1044).
- git-annex can [store data on git-lfs remotes](https://git-annex.branchable.com/tips/storing_data_in_git-lfs/), but not the other way around.

## Cheatsheet

1. Must have the following in global Git config,
or manually set it each time a repo is initialized *or* cloned:
    ```gitconfig
    [annex]
        version = 7
        thin = true
        numcopies = 2
        largefiles = not mimetype=text/*
    ```

1. Init or clone a repo:
    - `git init` or `git clone`
    - `git annex init`
    - `git annex wanted . present`

1. On init: add `gcrypt`-encrypted Git remote *and* separate annex repo:
    - `git remote add NAME gcrypt:HOST:PATH`
    - `git annex initremote NAME type=rsync rsyncurl=HOST:PATH encryption=hybrid keyid=KEY`
    - `git annex initremote NAME type=directory directory=PATH encryption=hybrid keyid=KEY`

1. On clone: enable annex remotes:
    - `git annex enableremote NAME`

1. Get location of files:
    - `git annex whereis [FILE]`

1. Copy all content to all repos, without pulling any:
    - `git remote | xargs -P 4 -I {} git annex copy --all --to {}; git annex sync --jobs=cpus`

1. Cleaning up a repo:
    - `git annex fix`
    - `git annex fsck --all`
    - `git annex unused`
    - `git annex drop --unused`

1. When recovering files from history:
    - `git checkout COMMIT -- FILE`
    - `git annex get FILE`

## Notes

1. must *not* use `direct` mode, this is now deprecated.

1. *must* use repo in `unlocked` mode, else Spotlight indexing is broken.
It is necessary that repo be version 7 for this:
`git config annex.version 7`

1. *must* use repo in `thin` mode, else we double the space usage.

1. must *not* run `annex sync` before an `add`, else moved files are *removed*.

1. Prevent `annex sync --content` from pulling all missing files by configuring
"wanted" with `git annex wanted . present`.

1. *should* name git-annex repos e.g. `git annex init NAME`,
else later clones of that same repo on different machines
are hard to tell apart from each other later.

1. Make sure to have proper filtering so that `git add`
does the right thing by default:
`git config annex.largefiles 'not mimetype=text/*'`

1. Seems possible to achieve fully braindead state when initializing or cloning,
but cannot reproduce this despite repeated effort.
When it *has* happened the fix seems to have been to re-initialize or re-enable
git-annex and the remote(s) until it cleaned up.
At any rate, apply the following precautions:
    - run `git annex init` on a newly cloned repo as the *first* command
    - call `git annex enableremote` right after `annex init`

1. Git config entries do *not* carry over - must config each cloned git repo,
or use global config.

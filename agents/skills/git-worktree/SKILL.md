---
name: git-worktree
description: git worktree を使って作業を開始する時に使用するスキル
---

## 新規に git worktree を作成するとき

`git wt` コマンドが利用可能な時，ユーザーは [k1LoW/git-wt](https://github.com/k1LoW/git-wt) を使って作業している．
そのため git-wt の使い方に従って worktree を作成する．

`git config wt.basedir` を実行することで，worktree が存在する相対パスを知ることができる

## k1LoW/git-wt の使い方

```sh
$ git wt                            # List all worktrees
$ git wt --json                     # List all worktrees in JSON format
$ git wt <branch|worktree|path>     # Switch to worktree (create worktree/branch if needed)
$ git wt -b <branch> <worktree>     # Create worktree with a different branch name
$ git wt --orphan <branch|worktree> # Create worktree with a new orphan branch (Git 2.42+)
$ git wt -d <branch|worktree|path>  # Delete worktree and branch (safe)
$ git wt -D <branch|worktree|path>  # Force delete worktree and branch
$ git wt -m [<old>] <new>           # Rename worktree directory and branch (safe)
$ git wt -M [<old>] <new>           # Force rename (overwrite existing branch, allow moving dirty/locked worktrees)
```


安装 
-----

我只测试过 Windows + cygwin 的环境，linux应该也是一样的。

    git clone https://github.com/JiangYouxin/git-mg.git
    cd git-mg 
    make install

自动解决git合并冲突
-----

git的3-way merge算法基于文件三个版本 (ours, base, theirs) 的LCS(最长公共子序列)。

这些LCS将文件切分成若干个block，每个block也有ours, base, theirs三个版本，且这三个版本不再有共同行。

3-way merge使用下面的规则处理这三个版本：

* 若ours == base，则合并结果取theirs

* 若theirs == base，则合并结果取ours

* 若ours == theirs，则合并结果取ours or theirs

* 若三个版本互不相同，则生成一个冲突(需要设置为diff3 格式)：

        <<<<<<<
        ours version
        |||||||
        base version
        =======
        theirs version
        >>>>>>>

这个算法有一些不智能，或者说，保守的地方：当base的每一行，都在ours或者theirs中依序出现时（即lcs(base, ours) + lcs(base, theirs) = base），合并结果应仅由ours或者theirs的新增行组成，特别的，如果ours与theirs中至少有一个版本没有引入新增行时，冲突其实可以被自动解决掉（直接采用新增行即可）

一个更激进的策略是，即使ours和theirs都引入了新增行，但在一个特定的上下文中，如果新增行的顺序不重要（比如两个分支都在源文件的同一个位置引用了不同的头文件），也可以直接采用这些新增行。

    git df [-g] [<file>]

使用上面的命令：

* lcs(base, ours) 与 lcs(base, theirs) 会从冲突上下文去掉，使冲突上下文更容易阅读。

* 执行上一步之后，如果base为空，且设置了-g参数或者ours与theirs至少有一个为空，则直接采用新增行解决冲突。

如果指定`<file>`，则对指定的文件执行操作；如果不指定，则对当前git工作区中所有冲突文件执行操作，并对已解决冲突的问题自动执行git add。

使用二分法做git merge
-----

用`git merge`做合并时，必须一次性解决所有冲突才能提交。

这样当一次性合并的范围较大时（比如在一个差距较大的分支上合并500个提交），会产生非常多的冲突，一次性解决非常困难。

git-mg在这种情况下会采用二分法逐步缩小逐步范围，逐步解决冲突。  
同时，当某一个提交产生很难解决的冲突时，可以跳过这个提交，留待以后处理。
    
    git mg <branch>

它的作用相当于`git merge <branch>`（我给git merge加了几个默认参数，详见源代码）

如果合并成功，则会正常退出。若合并失败，则会显示提示并进入subshell。  
此时有三种选择：

* 解决冲突

        git mergetool
        git commit
        exit 0

  此时成功完成一次合并，并继续 git-mg session。

* 使用二分法缩小合并范围

        exit 1

  此时git-mg将会使用二分法，将要被合并的branch切分为两半，分别递归地调用`git mg`。

  可以一直使用`exit 1`，将合并范围不断缩小，直到冲突的数量可控时再解决。

  有一个例外是branch上只有一个commit了。  
  此时git-mg会使用`git merge -s ours <commit>`跳过这个提交，以便继续 git-mg session。  
  请记住被跳过的commit的SHA号以便未来处理。

* 退出git mg

        exit 2

  此时会取消当前正在进行的合并，从整个 git-mg session 中返回。  
  但会保留之前已经完成的合并。

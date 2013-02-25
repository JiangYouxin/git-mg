使用二分法做git merge
=====

用`git merge`做合并时，必须一次性解决所有冲突才能提交。

这样当一次性合并的范围较大时（比如在一个差距较大的分支上合并500个提交），会产生非常多的冲突，一次性解决非常困难。

git-mg在这种情况下会采用二分法逐步缩小逐步范围，逐步解决冲突。  
同时，当某一个提交产生很难解决的冲突时，可以跳过这个提交，留待以后处理。

安装 
-----

我只测试过 Windows + cygwin 的环境，linux应该也是一样的。

    git clone https://github.com/JiangYouxin/git-mg.git
    cd 
    make install

使用 
-----
    
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
  此时git-mg会使用`git merge -r ours <commit>`跳过这个提交，以便继续 git-mg session。  
  请记住被跳过的commit的SHA号以便未来处理。

* 退出git mg

        exit 2

  此时会取消当前正在进行的合并，从整个 git-mg session 中返回。  
  但会保留之前已经完成的合并。

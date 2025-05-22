#=====目录相关快捷命令=====

## 显示目录等时，会自动渲染颜色
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


## 以列表形式显示当前路径下的所有文件文件夹，包括隐藏文件，但不显示 . 和 ..
## 以方便读取的形式显示文件和目录的大小，注意，目录大小不包含内部的文件
## 在列出的文件名称后加提示符；可执行档则 "*", 目录加 "/"
alias ll='ls -AlhF'

## 跳转到上层目录的快捷命令
alias ..='builtin cd ..; ls -F'
alias ...='builtin cd ../..; ls -F'
alias ....='builtin cd ../../..; ls -F'
alias .....='builtin cd ../../../..; ls -F'

## 跳转到新目录后，自动列出目录下的文件
function cd()
{
    builtin cd "$@"
    ls
}

alias gh='cd $HOME'
alias gr='cd /'

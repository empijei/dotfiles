# Dotfiles

## When you clone this
To download all the files use: `git submodule update --init --recursive`

## Awesome Window Manager
the awesome folder is in my `~/config` folder, it is my configuration for the [Awesome Window Manager](https://awesomewm.org/).

### Note
If you plan to use this beware: I use my [custom fork of vicious](https://github.com/empijei/vicious), which is here as a submodule.

Moreover, if you plan to use this, beware: in order for some of the bindings to work you will need the scripts in the `bin` folder to be in a directory that is in your $PATH variable __before__ awesome loads.

## The other files
`vimrc` is my `~/.vimrc` file

`zshrc` is my `~/.zshrc` file

`xmodmaprc` is loaded in my X session with xmodmap after the en_us keyboard layout is set
```
setxkbmap us && xmodmap ~/.xmodmaprc
```

the [zshproject](https://github.com/empijei/zshproject) folder is in my `~/empijei` folder



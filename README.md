[comment]: # ( )
# Intro

I use Neovim nowadays. It started out mainly as a way to have
available the ‹neovim-remote› package which provides functionality
similar to Vim's client-server mode, but which contrary to Vim also
works in console mode. Maybe this can be done with Vim too now, but
there appear to be other good reasons to use Neovim; I'll leave that
discussion to others and stick with Neovim.

[comment]: # ( )
## HOMEs Sweet HOMEs

An unusual thing I do when working on my main desktop is that,
depending on which project I am working on, I may set the HOME envvar
(among other configuration tweaks) to point to a different directory,
holding the project's files (there are pros and cons to this approach,
the trade-offs of which I am happy with). For Neovim, which uses the
XDG conventions, that means that each of these HOME directories would
need to have its own copy of an …<init.vim>, of plugins, etc., since
they are searched for in the …<nvim/> subdirectories of the following
directories by default:

    XDG_CONFIG_HOME : ~/.config
    XDG_DATA_HOME   : ~/.local/share

Now, most of my projects use the same initialization and plugins, so I
neither want to duplicate all that stuff, nor want to have to update
each project whenever I modify something that I want all projects to
share. On the other hand, some projects may indeed require their own
unique settings. I solve this by using an appropriate combination of
files specific to each project and by using symlinks.

[comment]: # ( )
## Installing

            ▸ Clone the nvim-lucs, this, module.
        dPkg=~/.local/share/nvim/site/pack/lucs/opt
        mkdir -p $dPkg
        cd $dPkg
        git clone https://github.com/lucs/nvim-lucs.git

            ▸ Ensure there is a config dir.
        dCfg=~/.config/nvim
        mkdir -p $dCfg

            ▸ Copy the init files. You may want to validate the contents,
            especially after having cloned the plugins you will be asked to by
            this doc right after.
        cp $dPkg/nvim-lucs/init.vim $dCfg
        cp $dPkg/nvim-lucs/init.lucs.vim $dCfg

[comment]: # ( )
### Want these plugins

I will want to install these plugins:

        XDG_DATA_HOME/nvim/site/pack/
    ~/.local/share/nvim/site/pack/
        lucs/opt/
                Sources detailed later.
            DrawIt
            nvim-lucs/
            undotree/
            vim-dirvish/
            vim-perl/
            vim-pgsep/
            vim-plugin-AnsiEsc/
            vim-raku/
            vim-repeat/
            vim-replquotes/
            vim-scroll-around-cursor/
            vim-surround/

Then `▸ git clone` each of these other plugins, in the same `$dPkg`
directory:

        My page separator plugin.
    https://github.com/lucs/vim-pgsep.git

        Scroll page, cursor remaining immobile.
    https://github.com/lucs/vim-scroll-around-cursor.git

        To make easier ╫─like box drawing.
    https://github.com/vim-scripts/DrawIt.git

        Navigate dirs. Start with '-'.
    https://github.com/justinmk/vim-dirvish.git

        Perl/Raku synlighting.
    https://github.com/vim-perl/vim-perl.git
    https://github.com/vim-perl/vim-perl6.git

        Not sure anymore why/what this is. 2021-05-09
    https://github.com/powerman/vim-plugin-AnsiEsc.git

        Make it easy to surround with paren-alikes.
    https://github.com/tpope/vim-surround.git

The nvim-lucs plugin repo (this repo) will have supplied two init
files that I place as follows:

        XDG_CONFIG_HOME/nvim/
    ~/.config/nvim/

            ⦃
                packadd nvim-lucs
                packadd vim-dirvish
                ⋯

                    " Misc options.
                set termguicolors
                ⋯

                    " prj globals.
                let g:user_home_dir = '/home/lucs'
                ⋯
            ⦄
        init.lucs.vim

            ⦃
                source /home/lucs/.config/nvim/init.lucs.vim
                let g:prj_nick = 'lucs'
                packadd vim-foo
            ⦄
        init.vim

You can merge them into a single init.vim if you want; I use the
include mechanism for flexibility in another aspect of the way I
organize my projects, aspect which is not discussed here.

[comment]: # ( )
### Build the help files. FIXME

    ./vimext/helptags.pl $dVimLucs/vimext
    ./vimext/helptags.pl $dVimLucs/vimsetup/vimfiles

[comment]: # ( )
## Things in this plugin:

    ./

        filetype.vim

        plugin/

            acutags.pl

            refmt.pl

                Print timestamps used by some of my code.
            tstamp.pl

        syntax/

            lucslog.vim

            text.vim

                Highlights in red or green parts of text wrapped in some UTF-8
                character pairs (for a project I did in the past).
            tradhelp.vim

        after/

            plugin
                    My "real" .vimrc hides way down here file.
                lucs.vim

            ftplugin/

                lucslog.vim

                lucs.vim

[comment]: # ( )
## Where my and external plugins are deployed for runtime.

HOMES symlink to these.

    ~lucs/
            XDG_DATA_HOME/nvim/site/pack/
        .local/share/nvim/site/pack/lucs/opt/

            VPS/.git
                    ▷ [remote "origin"]
                    ▷ /shome/lucs/vcs/VPS.git
                .config
            ⋯

        .config/nvim/

                ▷ source ~lucs/.config/nvim/init.lucs.vim
                ▷ let g:prj_nick = "lucs"
            init.vim

                ▷ let g:user_home_dir = '/home/lucs'
                ▷ let g:nvim_lucs_pack = g:user_home_dir .
                ▷   \ '/.local/share/nvim/site/pack/lucs/opt/nvim-lucs'
                ▷
                ▷ packadd VPS
                ▷ packadd DrawIt
                ▷ packadd vim-dirvish
                ▷ packadd vim-perl
                ▷ packadd vim-scroll-around-cursor
                ▷ packadd vim-plugin-AnsiEsc
                ▷ packadd vim-surround
                ▷ packadd vim-raku
                ▷ packadd vim-repeat
                ▷ packadd vim-replquotes
                ▷ packadd nvim-lucs
                ▷ packadd undotree
                ▷
                ▷ colorscheme blue
                ▷ set bg=dark
                ▷ let loaded_matchparen = 1
            init.lucs.vim

[comment]: # ( )
## Work on one of my plugins

    ~lucs/prj/t/nvim/

            .config
                ▷ [remote "origin"]
                ▷ /shome/lucs/vcs/VPS.git
        plugin.VPS/VPS.git/.git

        .config/nvim/
            init.vim
            pack/work/opt/
                VPS -> ~lucs/prj/t/nvim/plugin.VPS/VPS.git/.git

[comment]: # ( )
## Shared local bare repos of my and external plugins.

    /shome/lucs/vcs/VPS.git

[comment]: # ( )
## Where my plugins are made world public.

        .config
            ▷ [remote "gh"]
            ▷ ssh://githum.com/VPS.git
    https://github.com/lucs/VPS

[comment]: # ( )
## Any project

    ~lucs/prj/⟨prj root⟩/
        .config/nvim/init.vim

    ~lucs/prj/⦃t/nvim⦄/
            ▷ source ~lucs/.config/nvim/init.lucs.vim
            ▷ let g:prj_nick = "⦃t_nvim⦄"
        .config/nvim/init.vim

    ~lucs/prj/⟨any⟩/
        .config/nvim/init.vim
        .local/share/nvim/site/pack/lucs/opt/ ->
            ~lucs/.local/share/nvim/site/pack/lucs/opt/


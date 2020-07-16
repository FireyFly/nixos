{ pkgs, ... }:

let
  inherit (pkgs.vimUtils.override { inherit (pkgs) vim; })
    buildVimPluginFrom2Nix;

  myVimRuntime = buildVimPluginFrom2Nix {
    name = "my-vim-runtime";
    src = ./runtime;
  };

in

pkgs.vim_configurable.customize rec {
  name = "vim";

  vimrcConfig.customRC = ''
    set nocompatible

    " directories
    set viminfofile=$HOME/local/var/${name}/viminfo
    set undodir=$HOME/local/var/${name}/undodir

    syntax on
    colorscheme fireflybrid

    filetype plugin indent off

    " options
    set hidden
    set splitright
    set nowrap
    set ruler showcmd
    set ttimeoutlen=40
    set textwidth=78
    set backspace=indent,eol,start
    set incsearch nohlsearch
    set expandtab shiftwidth=2 copyindent autoindent
    inoremap <Tab> <C-v><Tab>
    set foldmethod=marker
    set undofile

    cnoremap <C-a> <Home>
    map Y y$

    " nice but non-essential
    set shortmess+=I laststatus=0
    set sidescroll=5 scrolloff=3
    set lazyredraw
    set list listchars=tab:»\ ,trail:·,nbsp:␣,extends:$,precedes:^
    set fillchars=vert:│,stl:─,stlnc:─
    " these should ideally be feature-tested
    set t_ZH=[3m   t_ZR=[23m    " italics
    set t_SI=[5\ q t_EI=[1\ q   " insert mode bar-cursor

    " mappings
    let mapleader = "-"
    nnoremap <Leader><Leader> <C-6>
    for i in range(1, 10)
      exec 'nnoremap <Leader>'.(i % 10).' :buf '.i.'<CR>'
    endfor

    nnoremap <Leader>. :!!<CR>
    nnoremap <Leader>e :edit %<CR>


    " pastebox
    let g:pasteboxWriteCommand = 'ssh hagall "cat >/var/www/up.firefly.nu/tmp/{}"'
  '';

  vimrcConfig.packages.x.start = [
    pkgs.vimPlugins.ale
    pkgs.vimPlugins.vim-gitgutter
    myVimRuntime
    # missing: syntax/* ftplugin/rfc.vim vim-glsl
  ];

}

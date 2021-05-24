{ config, lib, pkgs, ... }:
let
  sources = import ../../functions/sources.nix { sourcesFile = ./nix/sources.json; };

  nivMap = import ../../functions/nivMap.nix;

  attrList = nivMap sources;

  pluginList = builtins.map ( x:
    pkgs.vimUtils.buildVimPlugin {
      name = x.repo;
      src = builtins.fetchTarball {
        url = x.url;
        sha256 = x.sha256;
      };
      dontBuild = true;
      dontConfigure = true;
    }
  ) attrList;

  nvimNightly = pkgs.neovim-unwrapped.overrideAttrs (
    old: rec {
      version = "nightly";
      src = pkgs.fetchFromGitHub (lib.importJSON ./nightly.json);

      buildInputs = old.buildInputs ++ [ pkgs.tree-sitter ];
      cmakeFlags = old.cmakeFlags ++ [ "-DUSE_BUNDLED=OFF" ];
    }
  );

in
{

  programs.neovim = {
    enable = true;
    package = nvimNightly;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = pluginList;
    extraConfig = with config.lib.base16; let
      nivscript = pkgs.writeShellScript "nivscript" ''
        package=$(</dev/stdin)

        if type niv &> /dev/null; then
          niv=niv
        else
          niv="nix run nixpkgs.niv -c niv"
        fi

        $niv add $package | sed -u 's/\x1b\[[0-9;]*m//g'
        sleep 1
      '';
    in
    ''
      let g:deoplete#enable_at_startup = 1

      if !exists('g:airline_symbols')
        let g:airline_symbols = {}
      endif

      let g:indentLine_char = '┊'

      let g:airline_symbols.colnr = 'co'
      let g:airline_symbols.branch = ''
      let g:airline_symbols.maxlinenr = ''

      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#formatter = 'unique_tail'
      let g:airline#extensions#tabline#show_tabs = 0

      let g:airline#extensions#nvimlsp#enabled = 0

      let g:airline_mode_map = {
        \ '__'     : ' - ',
        \ 'c'      : ' C ',
        \ 'i'      : ' I ',
        \ 'ic'     : ' I ',
        \ 'ix'     : ' I ',
        \ 'n'      : ' N ',
        \ 'multi'  : ' M ',
        \ 'ni'     : ' N ',
        \ 'no'     : ' N ',
        \ 'R'      : ' R ',
        \ 'Rv'     : ' R ',
        \ 's'      : ' S ',
        \ 'S'      : ' S ',
        \ ''     : ' S ',
        \ 'v'      : ' V ',
        \ 'V'      : 'V-L',
        \ ''     : 'V-B',
      \}

      let g:suda_smart_edit = 1

      source ${base16template "vim"}
      let base16colorspace=256
      let g:airline_theme='base16'
      syntax on
      set autochdir
      set t_Co=256
      set title
      set number
      set numberwidth=5
      set cursorline

      function! s:ModeCheck(id)
        let vmode = mode() =~# '[vV�]'
        if vmode && !&rnu
          set relativenumber
        elseif !vmode && &rnu
          set norelativenumber
        endif
      endfunction
      call timer_start(100, function('s:ModeCheck'), {'repeat': -1})

      set hidden
      set ttimeoutlen=50
      set updatetime=40
      set tabstop=2
      set expandtab
      set autoindent
      set shiftwidth=2
      set mouse=a
      set noshowmode
      set nohlsearch
      set foldmethod=marker
      command -nargs=* Hm !home-manager <args>
      autocmd VimEnter * hi Comment cterm=italic gui=italic
      autocmd VimEnter * hi Folded cterm=bold ctermfg=DarkBlue ctermbg=none
      autocmd VimEnter * hi FoldColumn cterm=bold ctermfg=DarkBlue ctermbg=none
      vnoremap <C-c> "*y
      vnoremap <C-x> "*d
      cnoremap <Up> <C-p>
      cnoremap <Down> <C-n>
      nnoremap hms :Hm switch
      nnoremap hmb :Hm build
      " https://stackoverflow.com/questions/597687/how-to-quickly-change-variable-names-in-vim/597932#597932
      nnoremap gR gD:%s/<C-R>///gc<left><left><left>
      nnoremap <Space> za
      map <Leader>niv :s/$/ /<CR>^v$:w !${nivscript}<CR>wv^deld$viwyA = sources.<esc>pA;
    '';
  };
}

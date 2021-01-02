# TODO

## Acronyms

- c: -> /etc/nixos
 
## Broken packages managed by flatpaks

- qutebrowser
 
## Other things

### Prepare for AOC

#### Setup backup
- Try to upload dummy file to onedrive w/ rclone
- Try local manual backup w/ restic
- Try onedrive manual backup w/ restic
- Write simple scripts to backup with a single command on both richard and richard-win-vb, these will serve as temprorary until a proper systemd service is written.

#### Others

- Finish writing ttimer in hs
- Try and see if permission break if config is recloned
- If they break:
    - Use `mkscript` to refactor `bin/set-home-privileges` to Haskell
    - Fix permissions once and for all (again)
- Add xmonad-like window switching to vim + tab for coc completion
- Make `mkscript` more accessible (and think about accessibility of scripts more in general)

### Things to do in better times

- Rewrite `c:/bin/extra-setup` in Haskell
    - Add hardlink and backup functionality
        - Test them
- Write central `c:/bin/setup.hs` which does **all the setup**. Also document eventual manual setup instructions (such as importing gpg keys).
- Turn `c:/bin/richard-do-bu` and `c:/bin/richard-win-vb-do-bu` into a proper systemd service
    - First read this: https://nixos.wiki/wiki/Module
- Ask on forums why `richard:makeSoundWork` doesn't work
- Finish writing edit-home-prog
- Learn about systemd services for setting up sxhkd
- Write brightness changing script
- update pass-w/-git setup section in 1.todo.org
- Setup /sd
- Setup vim-org mode
- Setup doom emacs
- Make PR for adding quickmarks file to qutebrowser config
- Find out why xsession in home-manager dactivates caps lock remapping in configuration.nix
- git alias: start-ignoring
- Fix sxhkd (for now use pkill when is doesn't work properly)
- Make customized dmenu script to launch applications
    - Include aliases

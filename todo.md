# TODO

## Acronyms

- c: -> /etc/nixos
 
## Broken packages managed by flatpaks

- qutebrowser
 
## Other things

### Prepare for AOC

- Try and see if permission break if config is recloned
- If they break:
    - Use `mkscript` to refactor `bin/set-home-privileges` to Haskell
    - Fix permissions once and for all (again)
- Add xmonad-like window switching to vim + tab for coc completion
- Make `mkscript` more accessible (and think about accessibility of scripts more in general)
- Setup freaking manual backup (try on sd first)
- If sd fails:
    - Set up on hard disk
- Finish writing ttimer in hs
- Setup freaking daily backup (try on sd first)
- If sd fails:
    - Set up on hard disk

### Things to do in better times

- Rewrite `c:/extra-setup` in Haskell
    - Add hardlink and backup functionality
        - Test them
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


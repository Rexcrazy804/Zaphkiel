# this file only sets some user-specific stuff for my shell
# rest of the config is in nixosModules/programs/fish.nix
if status is-interactive
    fish_config theme choose "Rosé Pine"
    set -U hydro_color_pwd $fish_color_pine
    set -U hydro_color_git $fish_color_foam
    set -U hydro_color_start $fish_color_iris
    set -U hydro_color_error $fish_color_love
    set -U hydro_color_prompt $fish_color_pine
    set -U hydro_color_duration $fish_color_iris
    set -U fish_prompt_pwd_dir_length 0
    set -g fish_color_search_match
    set -g fish_pager_color_background
    set -g fish_pager_color_selected_background
end

if status is-interactive

fish_config theme choose "Rosé Pine"
set -g __rexies_prompt "$(set_color $fish_color_iris)~>$(set_color --reset)"
set -g __rexies_last_status 0
set -g __rexies_prompt_impure
set -g __rexies_prompt_status
set -g __rexies_prompt_jj

function fish_mode_prompt; end; # disable shitty vi indicator

function __rexies_repaint_prompt \
  --on-variable __rexies_prompt_impure \
  --on-variable __rexies_prompt_status \
  --on-variable __rexies_prompt_jj

  __rexies_render_prompt
  commandline --function repaint
end

function __rexies_render_prompt
    set __rexies_prompt (string join '' (set_color $fish_color_iris) "$__rexies_prompt_impure$hostname" (set_color $fish_color_pine) '/' (basename $PWD) $__rexies_prompt_jj $__rexies_prompt_status '> ' $(set_color --reset))
end

function __rexies_set_status --on-variable __rexies_last_status
    set -l output

    if test $__rexies_last_status -ne 0
      set output (set_color $fish_color_love)" E$__rexies_last_status"(set_color $fish_color_pine)
    end

    if test "$output" != "$__rexies_prompt_status"
      set __rexies_prompt_status $output
    end
end

function __rexies_set_impure --on-event fish_prompt
    set -l output
    if test "$IN_NIX_SHELL" = "impure"
        set output "!"
    else 
        set output "@"
    end

    if test "$output" != "$__rexies_prompt_impure"
        set __rexies_prompt_impure $output
    end
end

function __rexies_set_jj --on-event fish_prompt
    set -l output (command jj log -r @ --no-graph --template 'change_id.short(8)' 2>/dev/null)
    if test -n "$output"
        set output "$(set_color $fish_color_foam)#$output$(set_color $fish_color_pine)"
    end
    if test "$output" != "$__rexies_prompt_jj"
        set __rexies_prompt_jj $output
    end
end

function __rexies_set_last_status --on-event fish_prompt
  set __rexies_last_status $status
end

function fish_prompt
  string collect "$__rexies_prompt"
end

end

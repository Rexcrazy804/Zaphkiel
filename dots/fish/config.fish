if ! status is-interactive; return; end;

fish_config theme choose "Rosé Pine"
function fish_mode_prompt; end; # disable shitty vi indicator

## PROMPT ARCHITECTURE
# EVENT FISH_PROMPT 
# |> async functions will auto run <- async functions will write to specific paths
# ||> async counter is increased by each function
# |> prompt is written to $paths_prompt <- this call sync functions that will read from paths async functions write to
# E> fish_prompt reads $paths_prompt <- event emitter, waits for event handlers to complete :<
#
# EVENT SIGNAL USR1 <- this is the event emited by async calls once they are done
# |> render_prompt is invoked
# ||> async count is reduced
# ||> if count is zero > prompt is prompt is force repainted <- this will call fish_prompt
# ||> else ends here

# PROMPT VARIABLES
set -g __rexies_paths_root (mktemp -d fish-prompt-XXXX -p /tmp)
set -g __rexies_paths_prompt "$__rexies_paths_root/path"
set -g __rexies_paths_jj "$__rexies_paths_root/jj"
set -g __rexies_async_counter 0
touch $__rexies_paths_prompt
touch $__rexies_paths_jj


# ASYNC
function __rexies_async_call -a cmd -a out_path
  fish -c \
    'begin
    '$cmd' 2>/dev/null > '$out_path'
    kill -s USR1 '$fish_pid'
    end 2>&1 > /dev/null'&
  set __rexies_async_counter (math $__rexies_async_counter + 1)
end

# ASYNC PROMPT MODULES
function __rexies_prompt_jj_async --on-event fish_prompt
  if ! set -q __rexies_prompt_jj_color
    set -g __rexies_prompt_jj_color $fish_color_foam
    set -g __rexies_prompt_jj_color_hex (echo $__rexies_prompt_jj_color | awk '{ print "#" $1 }')
  end

  __rexies_async_call 'begin
    command jj log -r @ \
      --no-graph \
      --template \'change_id.shortest(8)\' \
      --color always \
      --config "colors.prefix=\"'$__rexies_prompt_jj_color_hex'\""
  end' $__rexies_paths_jj
end

# SYNC PROMPT MODULES
function __rexies_prompt_jj
  string collect < $__rexies_paths_jj | read -l output

  if test -n "$output"
    echo "$(set_color $__rexies_prompt_jj_color)#$output"
  else
    echo "" # so that the '#' isn't added if output is empty
  end
end

function __rexies_prompt_direnv
  if test "$IN_NIX_SHELL" = "impure"
    echo "$(set_color $fish_color_iris)!"
  else 
    echo "$(set_color $fish_color_iris)@"
  end
end

function __rexies_prompt_host
  echo "$(set_color $fish_color_iris)$hostname"
end

function __rexies_prompt_pwd
  echo "$(set_color $fish_color_pine)/$(basename $PWD)"
end

function __rexies_prompt_head
  echo "$(set_color $fish_color_pine)>$(set_color --reset)"
end

# PROMPT
function __rexies_prompt
  echo "$(__rexies_prompt_direnv)$(__rexies_prompt_host)$(__rexies_prompt_pwd)$(__rexies_prompt_jj)$(__rexies_prompt_head) "
end

function fish_prompt
  string collect <$__rexies_paths_prompt
end

# PROMPT UTIL
function __rexies_write_prompt --on-event fish_prompt
  __rexies_prompt > $__rexies_paths_prompt
end

function __rexies_cleanup_prompt --on-event fish_exit
  rm -rf $__rexies_paths_root
end

function __rexies_render_prompt --on-signal USR1
  set __rexies_async_counter (math $__rexies_async_counter - 1)
  if test "$__rexies_async_counter" -ne 0; return; end
  __rexies_write_prompt
  commandline --function repaint
end

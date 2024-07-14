let envhelp = {|cmd|
    let commands_in_path = (
        $env.PATH | each {|directory|
            if ($directory | path exists) {
                ls $directory | get name | path parse | update parent "" | path join
            }
        }
        | flatten
        | wrap cmd
    )

    let closest_commands = (
        $commands_in_path
        | insert distance {|it|
            $it.cmd | str distance $cmd
        }
        | uniq
        | sort-by distance
        | get cmd
        | first 5
    )

    let pretty_commands = (
        $closest_commands | each {|cmd|
            $"    (ansi {fg: "default" attr: "di"})($cmd)(ansi reset)"
        }
    )

    $"\ndid you mean?\n($pretty_commands | str join "\n")"
}

export-env {
    $env.config = ( $env.config | upsert hooks.command_not_found { |config|
        let env_hooks = ($config | get -i hooks.env_change.command_not_found)
        let my_hook = ($envhelp)
        if $env_hooks == null {
            $my_hook
        } else {
            $env_hooks | append $my_hook
        }
    })
}


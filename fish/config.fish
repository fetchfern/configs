fish_add_path ~/.cargo/bin
fish_add_path ~/.local/share/fnm

eval (fnm env)

set fish_greeting

alias compose='docker compose'

function fish_prompt
	echo -n (pwd |
	  sed -e "s|/home/$USER|~|" |
	  awk -F/ '{ \
		  if (NF <= 3) { print $0 } else
	      { print $(NF-2)"/"$(NF-1)"/"$(NF) }
		}')
	echo -n (fish_git_prompt)
	echo -n ": "
end

# Taken from https://github.com/fish-shell/fish-shell/issues/2671#issuecomment-170358106
function cd --description "Change directory"

    # Skip history in subshells
    if status --is-command-substitution
        builtin cd $argv
        return $status
    end

    # If argument consists solely of dots, go up number of dots - 1 directories - `cd ...` goes up to the grandparent
    if string match -qr '^\.{3,}$' -- $argv[1]
        # Only do this if there's no directory called "..." - which is theoretically allowed
        test -d $argv[1]; or set argv[1] (string replace "." "" -- $argv[1] | string replace -a "." "../")
    end

    builtin cd $argv[1]
    set -l cd_status $status

    if test $cd_status = 0 -a "$PWD" != "$previous"
        set -g dirprev $dirprev $previous
        set -e dirnext
        set -g __fish_cd_direction prev
    end

    return $cd_status
end

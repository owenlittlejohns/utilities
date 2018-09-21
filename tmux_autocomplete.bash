#/usr/bin/env bash
#
# Author: Owen Littlejohns, 2018-09-21
#
# A tab completion script for tmux commands. Currently included:
# - Standard command completion, e.g. "tmux a" -> "tmux attach-session"
# - Session selection for use with "tmux attach-session -t "
#
# To implement, source the file:
#
# 	source tmux_autocomplete.bash
#
# To avoid sourcing this in every new terminal add the previous command to the
# .bash_profile or .bashrc (or equivalent files in other shells).
#
# Reference: https://iridakos.com/tutorials/2018/03/01/bash-programmable-completion-tutorial.html
#

_find_suggestions()
{
	local possible_list=$1
	local tab_argument=$2
	local suggestions=($(compgen -W "${possible_list}" -- "${tab_argument}"))

	if [ "${#suggestions[@]}" == "1" ]; then
		# Only one match, so remove command literal and proceed with autocomplete
		local resolved_output=$(echo ${suggestions[0]/%\ */})
		COMPREPLY=("${resolved_output}")
	else
		# More than one suggestion, respond with suggestions intact:
		COMPREPLY=("${suggestions[@]}")
	fi
}

_tmux_attach_completions()
{
	# Tab complete for standard commands taken from /usr/local/etc/bash_completion.d/tmux
	if [[ "${#COMP_WORDS[@]}" -eq "2" ]]; then
		# Complete "tmux <command>", e.g. "tmux a" becomes "tmux attach-session"
		all_commands=$(tmux list-commands | awk 'BEGIN {ORS = " "} ; {print $1}')
		_find_suggestions "${all_commands}" "${COMP_WORDS[1]}"
	fi

	# For now everything below here is specifically for "tmux attach-session"
	if [[ "${#COMP_WORDS[@]}" -lt "4" ]]; then
		# There aren't at least four arguments, and it should be "tmux a -t "
		return
	fi

	if [[ ("${COMP_WORDS[COMP_CWORD-1]}" -ne "-t") || ( ! "${COMP_WORDS[1]}" =~ ^a$|^attach$|^attach-session$) ]]; then
		# Either the previous argument isn't "-t" or the second argument isn't
		# "a", "attach" or "attach-session"
		return
	fi

	# Get all the session names as a space separated list:
	sessions=$(tmux ls | awk 'BEGIN {ORS = " "} ; {listOutput = $1; split(listOutput, sessionArray, ":"); print sessionArray[1]}')

	_find_suggestions "${sessions}" "${COMP_WORDS[COMP_CWORD]}"
}

complete -F _tmux_attach_completions tmux

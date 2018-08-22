# alias list
# configure ipython to use pylab
alias ls='ls -G'
alias steam='wine "/Users/nowak/.wine/drive_c/Program Files/Steam/Steam.exe" -no-dwrite'

JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-9.0.4.jdk/Contents/Home"
export PATH=$JAVA_HOME/bin:$PATH

# configure GOPATH
export GOPATH=/Users/nowak/Development/go
export PATH=$PATH:$GOPATH/bin

#load colors
autoload colors && colors
#for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
#    eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'  #wrap colours between %{ %} to avoid weird gaps in autocomplete
#    eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
#done
#eval RESET='$reset_color'

###########################################
#   iTerm Tab and Title Customization     #
###########################################

function set_title_tab {

    function settab   {

		    # file settab  -- invoked only if iTerm or Konsole is running

		    #  Set iterm window tab to current directory and penultimate directory if the
		    #  shell process is running.  Truncate to leave the rightmost $rlength characters.
		    #
		    #  Use with functions settitle (to set iterm title bar to current directory)
		    #  and chpwd


		if [[ $TERM_PROGRAM == iTerm.app && -z "$KONSOLE_DCOP_SESSION" ]];then

			# The $rlength variable prints only the 20 rightmost characters. Otherwise iTerm truncates
			# what appears in the tab from the left.


				# Chage the following to change the string that actually appears in the tab:

					tab_label="$PWD:h:t/$PWD:t"

					rlength="20"   # number of characters to appear before truncation from the left

		            echo -ne "\e]1;${(l:rlength:)tab_label}\a"


		else

				# For KDE konsole tabs

				# Chage the following to change the string that actually appears in the tab:

					tab_label="$PWD:h:t/$PWD:t"

					rlength="20"   # number of characters to appear before truncation from the left

		        # If we have a functioning KDE console, set the tab in the same way
		        if [[ -n "$KONSOLE_DCOP_SESSION" && ( -x $(which dcop)  )  ]];then
		                dcop "$KONSOLE_DCOP_SESSION" renameSession "${(l:rlength:)tab_label}"
		        else
		            : # do nothing if tabs don't exist
		        fi

		fi
	}

    function settitle   {
		# Function "settitle"  --  set the title of the iterm title bar. use with chpwd and settab

		# Change the following string to change what appears in the Title Bar label:


			title_lab=$HOST:r:r::$PWD
				# Prints the host name, two colons, absolute path for current directory

			# Change the title bar label dynamically:

			echo -ne "\e]2;[zsh]   $title_lab\a"
	}

	# Set tab and title bar dynamically using above-defined functions

		function title_tab_chpwd { settab ; settitle }

		# Now we need to run it:
	    title_tab_chpwd

	# Set tab or title bar label transiently to the currently running command

	if [[ "$TERM_PROGRAM" == "iTerm.app" ]];then
		function title_tab_preexec {  echo -ne "\e]1; $(history $HISTCMD | cut -b7- ) \a"  }
		function title_tab_precmd  { settab }
	else
		function title_tab_preexec {  echo -ne "\e]2; $(history $HISTCMD | cut -b7- ) \a"  }
		function title_tab_precmd  { settitle }
	fi


	typeset -ga preexec_functions
	preexec_functions+=title_tab_preexec

	typeset -ga precmd_functions
	precmd_functions+=title_tab_precmd

	typeset -ga chpwd_functions
	chpwd_functions+=title_tab_chpwd

}

####################

set_title_tab

# Set prompts
PROMPT=%{$fg[red]%}%m%{$reset_color%}::%{$fg[blue]%}%C%{$reset_color%}'$ '  # default prompt
RPROMPT='[%* on %W]' # prompt for right side of screen

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'


# Other zsh settings
    zmodload -i zsh/complist
    zstyle ':completion:*' menu select=10
    zstyle ':completion:*' verbose yes
    setopt hist_ignore_all_dups
#http://www.nparikh.org/unix/prompt.php



export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/nowak/.gvm/bin/gvm-init.sh" ]] && source "/Users/nowak/.gvm/bin/gvm-init.sh"

# unlimited terminal history size
HISTSIZE=10000
# unlimited term history file size
HISTFILESIZE=10000000
# do not store duplicate history commands
#HISTCONTROL=erasedups

SPARK_HOME=/Users/nowak/Development/spark
SPARK_LOCAL_IP=localhost

bash_configure_fzf() {
	export FZF_DEFAULT_OPTS="--border --style=full --tmux center,70%,60% --preview='[[ -d {} ]] && eza -T -L 1 --color=always --icons=always {} || batcat -n --theme TwoDark {} --color=always' --multi --min-height 20 --border --no-separator --header-border horizontal --border-label-pos 2 --color 'label:blue' --preview-window 'right,50%' --preview-border line --bind 'ctrl-/:change-preview-window(down,50%|hidden|)' --bind 'ctrl-e:preview-down,ctrl-y:preview-up'"
	export FZF_CTRL_R_OPTS="--no-preview"
}

bash_configure_eval_fzf() {
	fzf --bash
}

BASH_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

source "$BASH_DIR/configs.sh"

echo "" > "$BASH_DIR/generated_configs.sh"

for i in $BASH_CONFIG_TAGS; do
	if [ -n "$(type -t "bash_configure_eval_${i}")" ]; then
		eval "$(declare -f "bash_configure_eval_$i" | tail -n +3 | head -n -1)" >> "$BASH_DIR/generated_configs.sh"
	fi
        echo "" >> "$BASH_DIR/generated_configs.sh"
	if [ -n "$(type -t "bash_configure_${i}")" ]; then
		declare -f "bash_configure_$i" | tail -n +3 | head -n -1 >> "$BASH_DIR/generated_configs.sh"
	fi
        echo "" >> "$BASH_DIR/generated_configs.sh"
done

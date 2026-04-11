#!/usr/bin/env bash
input=$(cat)

reset='\033[0m'
fg_white='\033[97m'
bold='\033[1m'

bg_purple='\033[48;5;99m'
bg_blue='\033[48;5;25m'
bg_green='\033[48;5;28m'
bg_yellow='\033[48;5;136m'
bg_red='\033[48;5;160m'
bg_cyan='\033[48;5;31m'
bg_orange='\033[48;5;130m'
bg_dark='\033[48;5;236m'

fg_purple='\033[38;5;99m'
fg_blue='\033[38;5;25m'
fg_green='\033[38;5;28m'
fg_yellow='\033[38;5;136m'
fg_red='\033[38;5;160m'
fg_cyan='\033[38;5;31m'
fg_orange='\033[38;5;130m'
fg_dark='\033[38;5;236m'

declare -a seg_bg seg_fg seg_text
add_seg() { seg_bg+=("$1"); seg_fg+=("$2"); seg_text+=("$3"); }

model=$(echo "$input"    | jq -r '.model.display_name              // empty')
ctx=$(echo "$input"      | jq -r '.context_window.used_percentage  // empty')
ctx_used=$(echo "$input" | jq -r '.context_window.total_input_tokens  // empty')
ctx_max=$(echo "$input"  | jq -r '.context_window.context_window_size  // empty')
five=$(echo "$input"     | jq -r '.rate_limits.five_hour.used_percentage // empty')
turns=""

# Model
if [ -n "$model" ]; then
  add_seg "$bg_purple" "$fg_purple" "$model"
fi

# Context
if [ -n "$ctx" ]; then
  ctx_int=$(printf '%.0f' "$ctx")
  if   [ "$ctx_int" -ge 80 ]; then ctx_bg="$bg_red";    ctx_fg="$fg_red"
  elif [ "$ctx_int" -ge 50 ]; then ctx_bg="$bg_yellow"; ctx_fg="$fg_yellow"
  else                              ctx_bg="$bg_green";  ctx_fg="$fg_green"
  fi
  label="ctx:${ctx_int}%"
  if [ -n "$ctx_used" ] && [ -n "$ctx_max" ]; then
    used_k=$(awk "BEGIN{printf \"%.0fk\",$ctx_used/1000}")
    max_k=$(awk  "BEGIN{printf \"%.0fk\",$ctx_max/1000}")
    label="${label} ${used_k}/${max_k}"
  fi
  add_seg "$ctx_bg" "$ctx_fg" "$label"
fi

# Session rate limit
if [ -n "$five" ]; then
  five_int=$(printf '%.0f' "$five")
  if   [ "$five_int" -ge 80 ]; then five_bg="$bg_red";    five_fg="$fg_red"
  elif [ "$five_int" -ge 50 ]; then five_bg="$bg_yellow"; five_fg="$fg_yellow"
  else                               five_bg="$bg_cyan";   five_fg="$fg_cyan"
  fi
  add_seg "$five_bg" "$five_fg" "5h:${five_int}%"
fi

# Turns
if [ -n "$turns" ]; then
  add_seg "$bg_dark" "$fg_dark" "${turns}t"
fi

# ── Render with plain space separators (no powerline glyphs) ──────────────
out=""
count=${#seg_bg[@]}
for ((i=0; i<count; i++)); do
  out="${out}${seg_bg[$i]}${fg_white}${bold} ${seg_text[$i]} ${reset}"
  if (( i+1 < count )); then
    # Simple colored divider — no multi-byte glyph
    out="${out}${seg_fg[$i]}${seg_bg[$((i+1))]}▎${reset}"
  fi
done

printf "%b" "$out"
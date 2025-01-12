#!/bin/bash
#
#                                      |
#                                  ___/"\___
#                          __________/ o \__________
#                            (I) (G) \___/ (O) (R)
#                                   Igor Os
#                               igor@igoros.com
#                                 2025-01-12
# ----------------------------------------------------------------------------
# Script description
# Documentation URL: https://
#
# CHANGE CONTROL
# ----------------------------------------------------------------------------
# 2025-01-12  igor  wrote this script
# ----------------------------------------------------------------------------


sanitize() {
  echo "${@}" | tr -cd '[:alnum:]._-' | sed 's|^\.*|./|'
}

# Configurations
extensions="pdf,epub,mkv,avi,mp4,mp3,flac"
unrar_opts="e -kb -o+"
log_file="unrar_log_$(date +%F_%T).log"
status_file=$(mktemp)
max_jobs=$(( $(nproc) > 4 ? 4 : $(nproc) ))

cleanup() {
  rm -f "$status_file"
}
trap cleanup EXIT

echo "Starting unrar operation at $(date)" > "$log_file"

# Sanitize filenames
find . -type f -regextype posix-extended \
  -regex '^.*(part(0)?1|[[:alpha:]]|[@_\-\.;\:\^\%\$\#\!=+~`()])\.rar$' | while IFS= read -r i; do
  sanitized=$(sanitize "${i}")
  if [[ "${i}" != "${sanitized}" ]]; then
    count=1
    while [[ -e "$sanitized" ]]; do
      sanitized="${sanitized%.rar}_$count.rar"
      ((count++))
    done
    if ! /bin/mv -n "${i}" "${sanitized}"; then
      echo "Failed to move ${i} to ${sanitized}" >> "$log_file"
    fi
  fi
done

# Extract files
find . -type f -regextype posix-extended \
  -regex '^.*(part(0)?1|[[:alpha:]]|[@_\-\.;\:\^\%\$\#\!=+~`()])\.rar$' -print0 | \
xargs -0 -P"$max_jobs" -I% bash -c '
  file="$1"
  unrar_opts="$2"
  extensions="$3"
  log_file="$4"
  status_file="$5"
  # Expand extensions into individual patterns
  ext_patterns=$(echo "$extensions" | tr "," " ")
  # Extract files matching patterns
  for ext in $ext_patterns; do
    if unrar $unrar_opts "$file" "*.$ext" >> "$log_file" 2>&1; then
      echo 0 >> "$status_file"
      break
    fi
  done
  if ! grep -q 0 "$status_file"; then
    echo "Error extracting $file" >> "$log_file"
    echo 1 >> "$status_file"
  fi
' _ % "$unrar_opts" "$extensions" "$log_file" "$status_file"

# Check status
if ! grep -q -v '^0$' "$status_file"; then
  echo "All unrar operations successful. Proceeding with cleanup." | tee -a "$log_file"
  find . -type f -regextype posix-extended \
    -regex '^.*\.rar$' -exec rm -v {} \; >> "$log_file" 2>&1
else
  echo "Errors occurred. Cleanup halted. Check $log_file for details." | tee -a "$log_file"
fi

#!/bin/bash
# coding: utf-8

# Import once
[ ${BJ_HAS_COMMON:-0} -ne 0 ] && return 0

# Decode Unicode escaped string to UTF-8 string
function decode()
{
  sed -e 's/\\u\(....\)/\&#x\1;/g' | nkf --numchar-input
}
export -f decode

# Escape charactor
function escape()
{
  sed -e 's/\\"/"/g' -e 's/\\\//\//g' -e 's/\\n/\n/g'
}
export -f escape

# 
function unref_char()
{
  sed \
  -e 's/&nbsp;/ /g' \
  -e 's/&quot;/"/g' \
  -e "s/&apos;/'/g" \
  -e 's/&lt;/</g'   \
  -e 's/&gt;/>/g'   \
  -e 's/&amp;/&/g'
}
export -f unref_char

# Strip HTML tags and remove spaces for indent
function strip_html_tag()
{
  sed -e 's/<[^>]*>//g' -e 's/^\s\s*//' -e 's/\s\s*$//' | decode | unref_char
}
export -f strip_html_tag

# Check
function is_same()
{
  if [ $(md5sum $1 $2 | cut -c -32 | uniq | wc -l) -eq 1 ]; then
    return 0
  else
    return 1
  fi
}
export -f is_same

# 
function now()
{
  date +"%Y-%m-%d_%H-%M-%S"
}
export -f now

# 
function save_with_backup()
{
  temp="$1"
  dest="$2"
  if [ -f "$dest" ]; then
    is_same "$dest" "$temp"
    if [ $? -eq 0 ]; then
      rm "$temp"
    else
      cp "$temp" "$dest"
    fi
  else
    mv "$temp" "$dest"
  fi
}
export -f save_with_backup

export BJ_HAS_COMMON=1


#!/bin/bash
indir="/mnt/c/Users/igor/Downloads"
cd "${indir}"
ftype="mp4|mov"
i="${1}"
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
if [ -z "${i}" ]; then i=10; fi
for fname in $(cd "${indir}" && ls -Art | grep -iE "\.${ftype}$" | grep -v _tvf | tail -n ${i})
do
  fext="$(echo ${fname} | awk -F. '{print $NF}')"
  outfile="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)_tvf.${fext}"
  ffmpeg -threads $(nproc) -i "${fname}" -vcodec libx264 \
  -vf 'scale=640:ih*640/iw,scale=trunc(iw/2)*2:trunc(ih/2)*2' \
  -acodec aac -b:v 0 -crf 20 -ar 44100 \
  -strict experimental -r 30 "${outfile}" && /bin/rm -f "${fname}"
  echo "${outfile}"
done
IFS=$SAVEIFS

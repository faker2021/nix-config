# This script will run patchelf --set-interpreter for all file in dir you spicified
# usage: dirspatchelf.sh /path/to/dir/
dir=$1
echo "dir: $1"
flist=$(find $dir -executable -type f)
res=""
cnt=0
ok_files=""

for file in $flist ; do
  ldd_lines_str=$(ldd $file 2>/dev/null)
  ok=0
  for lib_str in $ldd_lines_str ; do
    if [[ $lib_str == "/nix/store/"* ]]; then
      ok+=1
      res+="patchelf --set-interpreter $lib_str $file\n"
      patchelf --set-interpreter $lib_str $file
    fi
  done
  if [[ $ok > 0 ]]; then
    cnt+=1
    ok_files+="$file\n"
  fi
done

echo -e $res
echo -e "Successful patchelf files list: \n $ok_files"
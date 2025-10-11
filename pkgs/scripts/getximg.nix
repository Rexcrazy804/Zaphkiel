{
  writeShellScriptBin,
  gnused,
  curl,
}:
writeShellScriptBin "getximg" ''
  SED=${gnused}/bin/sed
  URL=$(echo $1 | $SED -r 's/x\.com/fxtwitter.com/')
  ${curl}/bin/curl $URL 2> /dev/null | \
    $SED 's/ /\n/g' | \
    grep "content=\"https://pbs.twimg.com/media/" | \
    $SED -r 's/content="(.*)\?.*".*/\1/' | \
    sort | uniq
''

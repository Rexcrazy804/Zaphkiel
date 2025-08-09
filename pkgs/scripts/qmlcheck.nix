# the cow knows everything
{
  writers,
  qt6,
}:
# yes I had a write a whole as fucking script to get this shitter to work
# I can't begin to descibe how little thought was put into qmlformat
writers.writeFishBin "qmlcheck" ''
  set -l tmpfile (mktemp --suffix=.qml)
  set -l tmpfile_fmt (mktemp --suffix=.qml)
  read -z stdin
  echo $stdin > $tmpfile
  sed -i '$ d' $tmpfile

  ${qt6.qtdeclarative}/bin/qmlformat -w 2 -l native -n --objects-spacing --functions-spacing $tmpfile > $tmpfile_fmt
  if ! cmp $tmpfile $tmpfile_fmt
    rm $tmpfile
    rm $tmpfile_fmt
    echo "owie hadda format your filie"
    exit 1
  end

  rm $tmpfile
  rm $tmpfile_fmt
''

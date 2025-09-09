# the cow knows everything
{
  writers,
  cowsay,
}:
writers.writeFishBin "cowask" ''
  set message $argv[1]
  if test "$message" = --help
    echo "Usage: cowask <message>"
    exit
  end

  set answer (random choice "yes lol" "no fuck you")
  ${cowsay}/bin/cowsay $message"?"\n $answer
''

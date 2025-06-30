# used with yazi to send stuff to phone
{writers}:
writers.writeNuBin "kde-send" ''
  def main [...files] {
    let device = kdeconnect-cli -a --name-only | fzf

    for $file in $files {
      kdeconnect-cli -n $"($device)" --share $"($file)"
    }
  }
''

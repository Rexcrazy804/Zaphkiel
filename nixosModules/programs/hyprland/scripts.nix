{pkgs}: {
  # small script to send files over kde connect on yazi
  kde-send = pkgs.writers.writeNuBin "kde-send" ''
    def main [...files] {
      let device = kdeconnect-cli -a --name-only | fzf

      for $file in $files {
        kdeconnect-cli -n $"($device)" --share $"($file)"
      }
    }
  '';
  gpurecording = pkgs.writers.writeNuBin "gpurecording" ''
    def "main start" [geometry?: string = ""] {
      let recording_count = ps | where name =~ wl-screenrec | length
      if $recording_count > 0 {
        notify-send -t 2000 -i nix-snowflake-white "Failed to start Recording" "Recording in Progress"
        return
      }
      notify-send -t 2000 -i nix-snowflake-white "Recording started" "Gpu screen recording has begun"
      if ($geometry | is-empty) {
        wl-screenrec --audio --audio-device "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" -f $"($env.HOME)/Videos/recording-(^date +%d%h%m_%H%M%S).mp4"
      } else {
        wl-screenrec $"-g($geometry | str trim)" --audio --audio-device "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" -f $"($env.HOME)/Videos/recording-(^date +%d%h%m_%H%M%S).mp4"
      }
      notify-send -t 2000 -i nix-snowflake-white "Recording stopped" "Gpu screen recording has concluded"
    }

    def "main stop" [] {
      try {
        ps
        | where name =~ wl-screenrec
        | kill -s 2 $in.0.pid
      } catch {
        notify-send -t 2000 -i nix-snowflake-white "Failed to stop Recording" "No active recording to be stopped"
      }
    }

    def main [] {
      print "Available subcommands:"
      print "start                 - Start gpu recording"
      print "stop                  - Stop gpu recording"
    }
  '';
  cowask = pkgs.writers.writeNuBin "cowask" ''
    def main [question] {
      cowsay $"($question)? \n (if (random bool) { 'yes lol' } else {'no fuck you' })"
    }
  '';
}

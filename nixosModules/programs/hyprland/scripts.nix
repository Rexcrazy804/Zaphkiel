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
  gpurecording = pkgs.writers.writeFishBin "gpurecording" ''
    function display_help
      echo "Usage: gpurecording <options>"
      echo ""
      echo "Options:"
      echo "--help              - display this help"
      echo "--start [geometry]  - start gpu recording"
      echo "--stop              - stop gpu recording"
    end

    function start_recording -a geometry
      if test -n "$(pidof wl-screenrec)"
        notify-send "Failed to start Recording" "Recording in Progress"
        return
      end

      set recording_file $HOME/Videos/recording-$(date +%d%h%m_%H%M%S)
      notify-send -t 2000  "Recording started" "Gpu screen recording has begun"
      wl-screenrec $(if test -n "$geometry"; echo -n -g$geometry; end) \
        --codec hevc \
        --audio \
        --audio-device alsa_output.pci-0000_00_1f.3.analog-stereo.monitor \
        -f $recording_file.mp4

      notify-send -t 2000  "Recording stopped" "Gpu screen recording has concluded"

      # left in here in case i forgor how to compress shit
      # ffmpeg -i $recording_file.mkv -vcodec libx265 -crf 28 $recording_file.mp4
    end

    function stop_recording
      set wlpid "$(pidof wl-screenrec)"
      if test -z "$wlpid"
        notify-send "Failed to stop Recording" "No active recording in progress"
      else
        kill -s 2 $wlpid
      end
    end

    switch $argv[1]
      case --help; display_help;
      case start; start_recording $argv[2];
      case stop; stop_recording;
      case '*'; echo "invalid option: $argv[1]" & display_help;
    end
  '';
  cowask = pkgs.writers.writeFishBin "cowask" ''
    set message $argv[1]
    if test "$message" = --help
      echo "Usage: cowask <message>"
      exit
    end

    set answer (random choice "yes lol" "no fuck you")
    cowsay $message"?"\n $answer
  '';
}

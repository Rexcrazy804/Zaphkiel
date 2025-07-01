# a shrimple script to crop my wallpapers
{
  writers,
  imagemagick,
}:
writers.writeFishBin "wallcrop" ''
  set image $argv[1]
  set offsetX $argv[2]
  set offsetY $argv[3]

  set scrnWidth 1920
  set scrnHeight 1080

  if test -n "$argv[4]"; set scrnWidth $argv[4]; end
  if test -n "$argv[5]"; set scrnHeight $argv[5]; end

  ${imagemagick}/bin/magick identify $image | awk '{print $4}' | string split + | read raw_data
  string split x $raw_data | read -L imgWidth imgHeight

  if test $imgWidth -gt $imgHeight
    set heightRatio (math $imgHeight / $scrnHeight)
    set reqWidth (math -s 0 $widthRatio x $scrnWidth)
    set reqHeight $imgHeight
  else
    set widthRatio (math $imgWidth / $scrnWidth)
    set reqHeight (math -s 0 $widthRatio x $scrnHeight)
    set reqWidth $imgWidth
  end
  ${imagemagick}/bin/magick $image -crop $reqWidth"x"$reqHeight"+"$offsetX"+"$offsetY -
''

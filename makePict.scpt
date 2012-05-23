set thePNG to ((path to home folder) as text) & "Pictures:Geek Tools:Default:albumArt.png" as alias
set thePICT to ((path to home folder) as text) & "Pictures:Geek Tools:Default:albumArt.pict"

tell application "Finder" to set creator type of thePNG to "????"
tell application "Image Events"
  set theImage to open thePNG
  save theImage as PICT in thePICT
end tell

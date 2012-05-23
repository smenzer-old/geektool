-- Paths and stuff
set ArtworkFromSpotify to ((path to home folder) as text) & "Pictures:Geek Tools:From Player:albumArt.png" as alias
set SpotifyArtwork to ((path to home folder) as text) & "Pictures:Geek Tools:From Player:albumArt.png"
set DefaultSpotifyArtwork to ((path to home folder) as text) & "Pictures:Geek Tools:Default:albumArt.png"
set DisplaySpotifyArtwork to ((path to home folder) as text) & "Pictures:Geek Tools:albumArt.png"
set thePNG to ((path to home folder) as text) & "Pictures:Geek Tools:From Player:albumArt.png" as alias

set ArtworkFromItunes to ((path to home folder) as text) & "Pictures:Geek Tools:From Player:albumArt.pict" as alias
set ItunesArtwork to ((path to home folder) as text) & "Pictures:Geek Tools:From Player:albumArt.pict"
set DefaultItunesArtwork to ((path to home folder) as text) & "Pictures:Geek Tools:Default:albumArt.pict"
set DisplayItunesArtwork to ((path to home folder) as text) & "Pictures:Geek Tools:albumArt.pict"
set thePICT to ((path to home folder) as text) & "Pictures:Geek Tools:albumArt.pict"

-- Unix versions of the above path strings
set unixSpotifyArtwork to the quoted form of POSIX path of SpotifyArtwork
set unixSpotifyDefaultArtwork to the quoted form of POSIX path of DefaultSpotifyArtwork
set unixSpotifyDisplayArtwork to the quoted form of POSIX path of DisplaySpotifyArtwork

set unixItunesArtwork to the quoted form of POSIX path of ItunesArtwork
set unixItunesDefaultArtwork to the quoted form of POSIX path of DefaultItunesArtwork
set unixItunesDisplayArtwork to the quoted form of POSIX path of DisplayItunesArtwork

set whichArt to "blank"

tell application "System Events"
  if exists process "Spotify" then -- Spotify is running
    tell application "Spotify"
      if player state is playing then -- Spotify is playing
        set aTrack to current track
        set aTrackArtwork to null
        set aTrackArtwork to artwork of aTrack
        set fileRef to (open for access ArtworkFromSpotify with write permission)
		        
		try
          write aTrackArtwork to fileRef
          close access fileRef
        on error errorMsg
          try
            close access fileRef
          end try
          error errorMsg
        end try
    
        tell application "Finder" to set creator type of ArtworkFromSpotify to "????"
        set whichArt to "Spotify"
      end if
    end tell
  else if exists process "iTunes" then -- iTunes is running
    tell application "iTunes"
	  if player state is playing then -- iTunes is playing
        set aLibrary to name of current playlist -- Name of Current Playlist
        set aTrack to current track
        set aTrackArtwork to null
        if (count of artwork of aTrack) ≥ 1 then -- there's an album cover
          -- "Running and playing and art"
          set aTrackArtwork to data of artwork 1 of aTrack
          set fileRef to (open for access ArtworkFromItunes with write permission)
          try
            write aTrackArtwork to fileRef
            close access fileRef
          on error errorMsg
			try
              close access fileRef
            end try
            error errorMsg
          end try
          
          tell application "Finder" to set creator type of ArtworkFromItunes to "????"
          set whichArt to "Itunes"
        end if
      end if
    end tell
  end if
end tell





if whichArt is "Spotify" then
  do shell script "ditto -rsrc " & unixSpotifyArtwork & space & unixSpotifyDisplayArtwork
  do shell script "ditto -rsrc " & unixItunesDefaultArtwork & space & unixItunesDisplayArtwork
else if whichArt is "Itunes" then
  do shell script "ditto -rsrc " & unixItunesArtwork & space & unixItunesDisplayArtwork
  do shell script "ditto -rsrc " & unixSpotifyDefaultArtwork & space & unixSpotifyDisplayArtwork
else 
  do shell script "ditto -rsrc " & unixSpotifyDefaultArtwork & space & unixSpotifyDisplayArtwork
  do shell script "ditto -rsrc " & unixItunesDefaultArtwork & space & unixItunesDisplayArtwork
end if


--tell application "Finder" to set creator type of thePNG to "????"
--tell application "Image Events"
--  set theImage to open thePNG
--  save theImage as PICT in thePICT
--end tell

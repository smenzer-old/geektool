on run
  set info to ""
  set numS to 0
  set numI to 0
  set what to ""
  set onwhat to ""

  tell application "System Events"
    set numS to count (every process whose name is "Spotify")
  end tell
  if numS > 0 then
    tell application "Spotify"
      if player state is playing then
        set who to artist of current track
        set what to name of current track
        set onwhat to album of current track
      end if
    end tell
  end if
  
  if numS <= 0 then
    tell application "System Events"
      set numI to count (every process whose name is "iTunes")
    end tell
    if numI > 0 then
      tell application "iTunes"
        if player state is playing then
          set who to artist of current track
          set what to name of current track
          set onwhat to album of current track
          set stars to (rating of current track) / 20 as integer
        end if
      end tell
    end if
  end if

  if numS > 0 or numI > 0 then
    -- set info to quote & what & quote & " by " & who & " from album " & onwhat as string
    set info to who & "
" & what & "
" & onwhat as string
  end if

  return info
end run

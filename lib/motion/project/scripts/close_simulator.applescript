tell application "iPhone Simulator"
    activate
end tell

tell application "System Events"
    tell process "iPhone Simulator"
        tell menu bar 1
            tell menu bar item "iOs Simulator"
                tell menu "iOs Simulator"
                    click menu item "Quit iOS Simulator"
                end tell
            end tell
        end tell
    end tell
end tell
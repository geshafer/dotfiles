function run_command(command)
  local file = io.popen(command)
  local output = file:read("*all"):gsub("^%s*(.-)%s*$", "%1")
  file:close()

  print(output)

  return output
end

hs.hotkey.bind({"cmd", "ctrl"}, "R", function()
  local recordingFile = "$HOME/tmp/note_recording.mp3"
  local toggleRecordingResult = run_command("$HOME/bin/toggle_recording " .. recordingFile)

  if toggleRecordingResult == "Recording Started" then
    print("Nothing to do while we wait for the user to finish recording")
  else
    print("Pass recording off to whisper")
  end

  hs.alert.show(toggleRecordingResult)
end)

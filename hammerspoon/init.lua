function get_command_output(command)
  local file = io.popen(command)
  local output = file:read("*all"):gsub("^%s*(.-)%s*$", "%1")
  file:close()

  print(output)

  return output
end

hs.hotkey.bind({"cmd", "ctrl"}, "R", function()
  local recordingFile = "/tmp/note_recording.mp3"
  local toggleRecordingResult = get_command_output("$HOME/bin/toggle_recording " .. recordingFile)

  if toggleRecordingResult == "Recording Started" then
    print("Nothing to do while we wait for the user to finish recording")
  else
    print("Pass recording off to whisper non-blocking")
    os.execute("($HOME/bin/transcribe " .. recordingFile .. " | $HOME/bin/summarize) &")
  end

  hs.alert.show(toggleRecordingResult)
end)

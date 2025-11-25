# VibeWave Setup Guide

## Quick Start - 3 Essential Steps

### Step 1: Add Microphone Permission (REQUIRED)

The app needs microphone access to record your voice. Add this permission in Xcode:

#### Method 1: Using Xcode UI (Recommended)
1. Open `VibeWave.xcodeproj` in Xcode
2. Click on the **VibeWave** project in the navigator (blue icon at top)
3. Select the **VibeWave** target (under TARGETS)
4. Click the **Info** tab
5. Hover over any row and click the **"+"** button
6. Type: `Privacy - Microphone Usage Description`
7. Set value to: `VibeWave needs access to your microphone to record your voice and detect your mood.`

#### Method 2: Using Info.plist File
If you have an `Info.plist` file, add:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>VibeWave needs access to your microphone to record your voice and detect your mood.</string>
```

### Step 2: Build the Project

1. Select your target device (iPhone or Simulator)
2. Press `Cmd + B` to build
3. Fix any build errors if they appear

### Step 3: Run the App

1. Press `Cmd + R` to run
2. When prompted, tap **"Allow"** for microphone access
3. Start recording your voice!

---

## Optional: Add Real Music Files

The app works without music files (uses fallback), but you can add real ambient music:

### Adding Music Files to Xcode:

1. **Create a Music folder** in Finder with your MP3 files
2. **Drag the folder** into Xcode's project navigator
3. **Check these options** in the dialog:
   - ✅ Copy items if needed
   - ✅ Create groups
   - ✅ Add to targets: VibeWave
4. Click **Finish**

### Required File Names:

Create 15 ambient music tracks (MP3 format):

**Happy Mood:**
- `happy1.mp3`
- `happy2.mp3`
- `happy3.mp3`

**Calm Mood:**
- `calm1.mp3`
- `calm2.mp3`
- `calm3.mp3`

**Sad Mood (Uplifting):**
- `uplifting1.mp3`
- `uplifting2.mp3`
- `uplifting3.mp3`

**Angry Mood (Soothing):**
- `soothing1.mp3`
- `soothing2.mp3`
- `soothing3.mp3`

**Neutral Mood:**
- `neutral1.mp3`
- `neutral2.mp3`
- `neutral3.mp3`

### Where to Find Ambient Music:

- **Free Sources**: 
  - YouTube Audio Library (royalty-free)
  - Free Music Archive
  - Incompetech
  - Bensound
  
- **Paid Sources**:
  - Epidemic Sound
  - AudioJungle
  - Artlist

---

## Troubleshooting

### "Microphone permission denied"
- Go to iPhone Settings → Privacy & Security → Microphone
- Enable access for VibeWave

### "Build failed"
- Make sure all files are added to the VibeWave target
- Check that you're using iOS 16.0 or later
- Clean build folder: `Cmd + Shift + K`

### "No audio playing"
- This is normal if you haven't added music files
- The app will still work and show the player UI
- Add MP3 files to hear actual music

### "Recording not working on Simulator"
- Microphone input is limited on Simulator
- Use a physical iPhone for best results
- Or test with a Mac with microphone

---

## Testing the App

### Test Flow:
1. ✅ Launch app → See recording screen
2. ✅ Tap "Start Recording" → See timer counting
3. ✅ Speak for 5 seconds → Recording stops automatically
4. ✅ See "Analyzing..." → Wait for mood detection
5. ✅ See mood result → Emoji and gradient appear
6. ✅ Tap "Play Music" → Music player opens
7. ✅ Test controls → Play/pause/next/previous work
8. ✅ Tap settings icon → Settings screen opens
9. ✅ Close player → Return to home screen
10. ✅ Tap "Record Again" → Start new recording

---

## Project Structure Overview

```
VibeWave/
├── VibeWaveApp.swift          # App entry point
├── Models/
│   └── Mood.swift             # Mood types and colors
├── Managers/
│   ├── AudioRecorderManager.swift  # Voice recording
│   └── MusicPlayerManager.swift    # Music playback
├── Services/
│   └── MoodDetectionService.swift  # AI mood detection
└── Views/
    ├── HomeView.swift         # Main screen
    ├── MusicPlayerView.swift  # Music player
    └── SettingsView.swift     # Settings
```

---

## Need Help?

Common issues and solutions:

**Q: Can I test on Simulator?**  
A: Yes, but microphone input is limited. Use a physical device for best experience.

**Q: Do I need real music files?**  
A: No, the app works without them. It will show the player UI but won't play audio.

**Q: How do I add a real CoreML model?**  
A: Train a model with CreateML, add the `.mlmodel` file to Xcode, and update `MoodDetectionService.swift`.

**Q: Can I customize the moods?**  
A: Yes! Edit `Mood.swift` to add new moods, emojis, and color gradients.

---

**You're all set! Enjoy VibeWave! 🎵✨**

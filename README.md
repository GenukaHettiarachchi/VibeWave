# VibeWave – Ambient Music Based on Your Mood

A beautiful SwiftUI iOS app that detects your mood from a 5-second voice recording and plays personalized ambient music to match or improve your emotional state.

## 🎯 Features

- **Voice Recording**: Record a 5-second voice clip with real-time timer
- **Mood Detection**: AI-powered emotion analysis (Happy, Calm, Sad, Angry, Neutral)
- **Adaptive UI**: Dynamic gradients and animations that match detected mood
- **Music Player**: Full-featured player with play/pause/next/previous controls
- **Smart Recommendations**: Uplifting music for sad/stressed moods
- **Settings**: Customizable sound options and app information
- **Elegant Design**: Modern UI with smooth animations and calming aesthetics

## 🛠️ Setup Instructions

### 1. Add Required Permissions

Add the following keys to your `Info.plist` file (or in Xcode's Info tab):

```xml
<key>NSMicrophoneUsageDescription</key>
<string>VibeWave needs access to your microphone to record your voice and detect your mood.</string>

<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

**In Xcode:**
1. Select your project in the navigator
2. Select the "VibeWave" target
3. Go to the "Info" tab
4. Click the "+" button to add new entries:
   - **Privacy - Microphone Usage Description**: "VibeWave needs access to your microphone to record your voice and detect your mood."

### 2. Add Sample Audio Files (Optional)

The app references music files but includes fallback behavior if they're not present. To add actual music:

1. Create a folder named `Music` in your project
2. Add MP3 files with these names:
   - **Happy mood**: `happy1.mp3`, `happy2.mp3`, `happy3.mp3`
   - **Calm mood**: `calm1.mp3`, `calm2.mp3`, `calm3.mp3`
   - **Sad mood** (uplifting): `uplifting1.mp3`, `uplifting2.mp3`, `uplifting3.mp3`
   - **Angry mood** (soothing): `soothing1.mp3`, `soothing2.mp3`, `soothing3.mp3`
   - **Neutral mood**: `neutral1.mp3`, `neutral2.mp3`, `neutral3.mp3`

3. Drag the files into Xcode and ensure "Copy items if needed" and "Add to target: VibeWave" are checked

### 3. Build and Run

1. Open `VibeWave.xcodeproj` in Xcode
2. Select your target device or simulator
3. Press `Cmd + R` to build and run
4. Grant microphone permissions when prompted

## 📱 How to Use

1. **Launch the app** - You'll see the main recording screen
2. **Tap "Start Recording"** - Speak naturally for up to 5 seconds
3. **Wait for analysis** - The app will detect your mood using AI
4. **View your mood** - See your detected emotion with a beautiful animation
5. **Play music** - Tap "Play Music" to hear tracks matched to your mood
6. **Control playback** - Use play/pause, next/previous, and volume controls
7. **Record again** - Tap "Record Again" to try a new mood detection

## 🎨 App Structure

```
VibeWave/
├── Models/
│   └── Mood.swift              # Mood enum with gradients and music tracks
├── Managers/
│   ├── AudioRecorderManager.swift  # Handles voice recording
│   └── MusicPlayerManager.swift    # Manages music playback
├── Services/
│   └── MoodDetectionService.swift  # AI mood detection (CoreML simulation)
├── Views/
│   ├── HomeView.swift          # Main recording and mood detection screen
│   ├── MusicPlayerView.swift   # Full-featured music player
│   └── SettingsView.swift      # Settings and about information
└── VibeWaveApp.swift           # App entry point
```

## 🧠 Mood Detection

The app currently uses a simulated CoreML model that analyzes:
- Audio energy levels
- Voice characteristics
- Recording patterns

**To implement real CoreML:**
1. Train a model using CreateML or external tools
2. Add the `.mlmodel` file to your project
3. Update `MoodDetectionService.swift` to use the actual model

## 🎵 Music Recommendations

- **Happy** → Upbeat, joyful ambient tracks
- **Calm** → Peaceful, relaxing nature sounds
- **Sad** → Uplifting, hopeful melodies (mood improvement)
- **Angry** → Soothing, calming compositions (mood improvement)
- **Neutral** → Balanced, gentle ambient music

## 🔧 Technical Details

- **Framework**: SwiftUI
- **Audio Recording**: AVAudioRecorder
- **Audio Playback**: AVAudioPlayer
- **Minimum iOS**: iOS 16.0+
- **Architecture**: MVVM pattern with ObservableObject managers

## 📝 Notes

- The app works on both simulator and physical devices
- Microphone recording requires a physical device for best results
- The mood detection is simulated - integrate a real CoreML model for production
- Audio files are optional - the app handles missing files gracefully

## 🚀 Future Enhancements

- [ ] Integrate real CoreML emotion detection model
- [ ] Add Spotify/Apple Music integration
- [ ] Save mood history and statistics
- [ ] Social sharing features
- [ ] Custom playlist creation
- [ ] Mood journaling

## 📄 License

Created for educational and demonstration purposes.

---

**Enjoy discovering music that matches your vibe! 🎵✨**

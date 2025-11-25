# VibeWave - App Architecture

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                     VibeWaveApp                         │
│                   (App Entry Point)                     │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                      HomeView                           │
│              (Main Recording Screen)                    │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   Recording  │  │  Analyzing   │  │ Mood Result  │ │
│  │    State     │→ │    State     │→ │    State     │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└────────────────────┬────────────────────────────────────┘
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
┌──────────────────┐  ┌──────────────────┐
│ MusicPlayerView  │  │   SettingsView   │
│   (Sheet Modal)  │  │   (Sheet Modal)  │
└──────────────────┘  └──────────────────┘
```

---

## 📦 Component Hierarchy

### 1. Models Layer
```
Mood.swift
├── Mood enum (Happy, Calm, Sad, Angry, Neutral)
├── Associated properties (emoji, gradient, description)
├── MusicTrack struct
└── Color extension (hex support)
```

### 2. Managers Layer
```
AudioRecorderManager.swift
├── AVAudioRecorder wrapper
├── Permission handling
├── Recording state management
└── File management

MusicPlayerManager.swift
├── AVAudioPlayer wrapper
├── Playlist management
├── Playback controls
└── Volume control
```

### 3. Services Layer
```
MoodDetectionService.swift
├── Audio analysis
├── Feature extraction
├── Mood prediction
└── CoreML simulation
```

### 4. Views Layer
```
HomeView.swift
├── Recording UI
├── Mood detection UI
├── Result display
└── Navigation

MusicPlayerView.swift
├── Album art visualization
├── Track information
├── Playback controls
└── Volume slider

SettingsView.swift
├── Sound settings
├── About information
└── App description
```

---

## 🔄 Data Flow

### Recording Flow
```
User Taps Button
    ↓
HomeView triggers
    ↓
AudioRecorderManager.startRecording()
    ↓
AVAudioRecorder starts
    ↓
Timer updates UI (0.0 → 5.0 seconds)
    ↓
Auto-stop at 5 seconds
    ↓
AudioRecorderManager.stopRecording()
    ↓
Recording saved to file
```

### Mood Detection Flow
```
Recording Complete
    ↓
HomeView calls MoodDetectionService
    ↓
Service analyzes audio file
    ↓
Extract features (energy, frequency)
    ↓
Predict mood (Happy/Calm/Sad/Angry/Neutral)
    ↓
Return Mood to HomeView
    ↓
Update UI with gradient & emoji
```

### Music Playback Flow
```
User taps "Play Music"
    ↓
HomeView loads playlist from Mood
    ↓
MusicPlayerManager.loadPlaylist()
    ↓
Load first track
    ↓
MusicPlayerManager.play()
    ↓
AVAudioPlayer starts
    ↓
Timer updates progress
    ↓
User controls (play/pause/next/previous)
    ↓
MusicPlayerManager handles commands
```

---

## 🎯 State Management

### HomeView States
```swift
@StateObject audioRecorder: AudioRecorderManager
@StateObject musicPlayer: MusicPlayerManager
@State moodDetectionService: MoodDetectionService
@State detectedMood: Mood?
@State isAnalyzing: Bool
@State showMusicPlayer: Bool
@State showSettings: Bool
@State permissionDenied: Bool
```

### AudioRecorderManager States
```swift
@Published isRecording: Bool
@Published recordingTime: TimeInterval
@Published hasRecording: Bool
private var audioRecorder: AVAudioRecorder?
private var recordingTimer: Timer?
```

### MusicPlayerManager States
```swift
@Published isPlaying: Bool
@Published currentTrack: MusicTrack?
@Published currentTime: TimeInterval
@Published duration: TimeInterval
@Published volume: Float
private var audioPlayer: AVAudioPlayer?
private var playbackTimer: Timer?
```

---

## 🎨 UI Component Breakdown

### HomeView Components
```
┌─────────────────────────────────────┐
│ Header (Title + Settings Button)   │
├─────────────────────────────────────┤
│                                     │
│         Main Content Area           │
│    (Recording / Analyzing / Result) │
│                                     │
├─────────────────────────────────────┤
│   Action Button (Record/Stop)       │
└─────────────────────────────────────┘
```

### MusicPlayerView Components
```
┌─────────────────────────────────────┐
│ Header (Close + Now Playing)        │
├─────────────────────────────────────┤
│                                     │
│      Album Art (Animated Circle)    │
│                                     │
├─────────────────────────────────────┤
│         Track Information           │
├─────────────────────────────────────┤
│         Progress Bar + Time         │
├─────────────────────────────────────┤
│    Playback Controls (◀ ⏯ ▶)      │
├─────────────────────────────────────┤
│         Volume Slider               │
└─────────────────────────────────────┘
```

### SettingsView Components
```
┌─────────────────────────────────────┐
│ Header (Title + Close Button)       │
├─────────────────────────────────────┤
│      App Icon + Description         │
├─────────────────────────────────────┤
│         Sound Settings              │
│  • Sound Effects Toggle             │
│  • Haptic Feedback Toggle           │
│  • Auto-play Next Toggle            │
├─────────────────────────────────────┤
│         About Section               │
│  • Version                          │
│  • Developer                        │
│  • Privacy Policy                   │
│  • Terms of Service                 │
├─────────────────────────────────────┤
│       How It Works Section          │
└─────────────────────────────────────┘
```

---

## 🔌 External Dependencies

### Apple Frameworks
- **SwiftUI** - UI framework
- **AVFoundation** - Audio recording and playback
- **Combine** - Reactive state management
- **Foundation** - Core utilities

### No Third-Party Dependencies
- ✅ Pure Swift implementation
- ✅ No CocoaPods
- ✅ No Swift Package Manager dependencies
- ✅ No Carthage

---

## 🎭 Animation System

### Continuous Animations
```swift
// Wave pulse effect
.scaleEffect(animateWave ? 1.2 : 1.0)
.animation(.easeInOut(duration: 1.5).repeatForever())

// Album art rotation
.rotationEffect(.degrees(isPlaying ? 360 : 0))
.animation(.linear(duration: 10.0).repeatForever())

// Mood emoji bounce
.scaleEffect(animateWave ? 1.1 : 1.0)
.animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true))
```

### Transition Animations
```swift
// Gradient color change
.animation(.easeInOut(duration: 1.0), value: detectedMood)

// State transitions
withAnimation {
    detectedMood = nil
}
```

---

## 🎨 Color System

### Gradient Generation
```swift
LinearGradient(
    colors: [startColor, endColor],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### Mood-Based Colors
- Each mood has unique gradient
- Smooth transitions between states
- Consistent opacity levels
- White-based overlays

---

## 📱 Navigation Pattern

```
HomeView (Root)
    │
    ├─→ MusicPlayerView (Sheet)
    │       └─→ Dismiss → Back to HomeView
    │
    └─→ SettingsView (Sheet)
            └─→ Dismiss → Back to HomeView
```

### Navigation Type
- **Sheet Presentation** - Modal overlays
- **Environment Dismiss** - SwiftUI dismiss action
- **No NavigationStack** - Simple flat hierarchy

---

## 🔐 Permission Flow

```
App Launch
    ↓
User taps "Start Recording"
    ↓
Check microphone permission
    ↓
┌───────────────┴───────────────┐
│                               │
▼                               ▼
Permission Granted        Permission Denied
    ↓                           ↓
Start Recording           Show Alert
    ↓                           ↓
Record Audio              Offer Settings Link
```

---

## 💾 File Management

### Recording Files
```
Location: Documents Directory
Format: .m4a (MPEG-4 Audio)
Naming: recording_[timestamp].m4a
Lifecycle: Created → Analyzed → Deleted
```

### Music Files
```
Location: App Bundle
Format: .mp3
Naming: [mood][number].mp3
Fallback: Silent/placeholder if missing
```

---

## 🧪 Testing Strategy

### Unit Tests (Recommended)
- AudioRecorderManager recording logic
- MusicPlayerManager playback logic
- Mood detection algorithm
- File management operations

### UI Tests (Recommended)
- Recording flow
- Mood detection flow
- Music player interactions
- Settings navigation

### Manual Tests
- Permission handling
- Audio quality
- UI responsiveness
- Animation smoothness

---

## 🚀 Performance Considerations

### Memory Management
- ✅ Weak self in closures
- ✅ Timer invalidation
- ✅ File cleanup after analysis
- ✅ Audio session management

### CPU Optimization
- ✅ Background thread for audio analysis
- ✅ Main thread for UI updates
- ✅ Efficient state updates

### Battery Optimization
- ✅ Stop timers when not needed
- ✅ Pause audio when backgrounded
- ✅ Minimal background activity

---

## 🔮 Extension Points

### Easy to Add
- New mood types (edit Mood.swift)
- More music tracks (add to Mood.musicTracks)
- Custom color schemes (edit gradients)
- Additional settings (extend SettingsView)

### Moderate Complexity
- Real CoreML model integration
- Cloud storage for recordings
- User profiles and history
- Social sharing features

### Advanced Features
- Spotify/Apple Music API
- Real-time audio visualization
- Advanced analytics
- Multi-language support

---

## 📊 Code Metrics

```
Total Swift Files: 10
Total Lines of Code: ~1,500
Average File Size: ~150 lines

Breakdown:
- Models: 150 lines
- Managers: 400 lines
- Services: 150 lines
- Views: 800 lines
```

---

## 🎓 Best Practices Used

✅ **MVVM Architecture** - Clear separation of concerns
✅ **ObservableObject** - Reactive state management
✅ **Protocol-Oriented** - Delegate patterns
✅ **Error Handling** - Try-catch blocks
✅ **Resource Management** - Proper cleanup
✅ **SwiftUI Best Practices** - Modern declarative UI
✅ **Code Organization** - Logical folder structure
✅ **Documentation** - Comprehensive comments

---

**This architecture provides a solid foundation for a production-ready app! 🏗️✨**

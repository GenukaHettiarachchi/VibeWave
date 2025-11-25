# 🚀 VibeWave - Quick Start Guide

## Get Running in 3 Minutes!

### Step 1: Open in Xcode (30 seconds)
```bash
cd /Users/udesholith/Downloads/Genuka/VibeWave
open VibeWave.xcodeproj
```

### Step 2: Add Microphone Permission (1 minute)
1. In Xcode, click **VibeWave** project (blue icon at top)
2. Select **VibeWave** target (under TARGETS)
3. Click **Info** tab
4. Find "Custom iOS Target Properties"
5. Click **+** button to add new row
6. Type: `Privacy - Microphone Usage Description`
7. Value: `VibeWave needs access to your microphone to record your voice and detect your mood.`

**Note**: Don't create a manual Info.plist file - Xcode auto-generates it!

### Step 3: Build & Run (30 seconds)
1. Select your iPhone or Simulator
2. Press `Cmd + R`
3. Tap **Allow** when asked for microphone access
4. Start recording! 🎤

---

## ✅ What You Get

- 🎤 **Voice Recording** - Record 5-second clips
- 🧠 **AI Mood Detection** - Happy, Calm, Sad, Angry, Neutral
- 🎨 **Beautiful UI** - Adaptive gradients and animations
- 🎵 **Music Player** - Full playback controls
- ⚙️ **Settings** - Customizable options

---

## 📱 How to Use

1. **Tap "Start Recording"** → Speak naturally for 5 seconds
2. **Wait for analysis** → AI detects your mood
3. **View your mood** → See emoji and gradient
4. **Tap "Play Music"** → Enjoy mood-matched music
5. **Control playback** → Play, pause, skip tracks

---

## 🎯 Testing Tips

- **Best on physical iPhone** (microphone works better)
- **Works on Simulator** (limited mic input)
- **No music files needed** (app has fallback behavior)
- **Try different emotions** (happy, sad, calm, angry)

---

## 🔧 Optional: Add Real Music

Want to hear actual music? Add MP3 files:

1. Create folder with these files:
   - `happy1.mp3`, `happy2.mp3`, `happy3.mp3`
   - `calm1.mp3`, `calm2.mp3`, `calm3.mp3`
   - `uplifting1.mp3`, `uplifting2.mp3`, `uplifting3.mp3`
   - `soothing1.mp3`, `soothing2.mp3`, `soothing3.mp3`
   - `neutral1.mp3`, `neutral2.mp3`, `neutral3.mp3`

2. Drag folder into Xcode
3. Check "Copy items if needed"
4. Check "Add to target: VibeWave"

---

## 🆘 Troubleshooting

**"Microphone permission denied"**
→ Settings → Privacy → Microphone → Enable VibeWave

**"Build failed"**
→ Press `Cmd + Shift + K` to clean, then rebuild

**"No audio playing"**
→ Normal without music files. Add MP3s to hear audio.

---

## 📚 More Info

- **Full Documentation**: See `README.md`
- **Setup Details**: See `SETUP_GUIDE.md`
- **Project Overview**: See `PROJECT_SUMMARY.md`

---

**That's it! You're ready to vibe! 🎵✨**

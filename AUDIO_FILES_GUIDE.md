# 🎵 Audio Files Guide for VibeWave

## Required Audio Files

VibeWave requires **15 ambient music files** for full functionality. The app will work without them (using fallback behavior), but adding real music creates the complete experience.

---

## 📁 File Structure

```
VibeWave/
└── VibeWave/
    └── Resources/
        └── Music/
            ├── happy1.mp3
            ├── happy2.mp3
            ├── happy3.mp3
            ├── calm1.mp3
            ├── calm2.mp3
            ├── calm3.mp3
            ├── uplifting1.mp3
            ├── uplifting2.mp3
            ├── uplifting3.mp3
            ├── soothing1.mp3
            ├── soothing2.mp3
            ├── soothing3.mp3
            ├── neutral1.mp3
            ├── neutral2.mp3
            └── neutral3.mp3
```

---

## 🎼 Required Files by Mood

### Happy Mood (3 files)
- `happy1.mp3` - Joyful Vibes
- `happy2.mp3` - Sunshine Day
- `happy3.mp3` - Happy Moments

**Style**: Upbeat, cheerful, positive energy
**Duration**: 2-5 minutes each
**BPM**: 120-140

---

### Calm Mood (3 files)
- `calm1.mp3` - Ocean Waves
- `calm2.mp3` - Forest Breeze
- `calm3.mp3` - Peaceful Mind

**Style**: Relaxing, peaceful, ambient
**Duration**: 3-5 minutes each
**BPM**: 60-80

---

### Sad Mood - Uplifting (3 files)
- `uplifting1.mp3` - Rise Up
- `uplifting2.mp3` - New Beginnings
- `uplifting3.mp3` - Hope Restored

**Style**: Gentle, hopeful, mood-lifting
**Duration**: 3-5 minutes each
**BPM**: 80-100

**Note**: These should help improve sad moods, not match them

---

### Angry Mood - Soothing (3 files)
- `soothing1.mp3` - Calm Waters
- `soothing2.mp3` - Inner Peace
- `soothing3.mp3` - Serenity Now

**Style**: Calming, gentle, stress-reducing
**Duration**: 3-5 minutes each
**BPM**: 60-75

**Note**: These should help calm angry moods

---

### Neutral Mood (3 files)
- `neutral1.mp3` - Ambient Flow
- `neutral2.mp3` - Gentle Rhythm
- `neutral3.mp3` - Balanced Energy

**Style**: Balanced, ambient, neutral
**Duration**: 3-5 minutes each
**BPM**: 90-110

---

## 🎹 Where to Find Royalty-Free Music

### Free Sources

#### 1. **YouTube Audio Library**
- URL: https://studio.youtube.com/channel/UC.../music
- License: Free to use
- Quality: High
- Genres: Ambient, Relaxing, Upbeat

#### 2. **Free Music Archive**
- URL: https://freemusicarchive.org
- License: Various Creative Commons
- Quality: High
- Search: "ambient", "relaxing", "uplifting"

#### 3. **Incompetech**
- URL: https://incompetech.com/music/
- License: Creative Commons (attribution)
- Quality: High
- Filter by mood

#### 4. **Bensound**
- URL: https://www.bensound.com
- License: Free with attribution
- Quality: High
- Categories: Acoustic, Ambient

#### 5. **Pixabay Music**
- URL: https://pixabay.com/music/
- License: Free for commercial use
- Quality: High
- Search by mood

### Paid Sources (Professional Quality)

#### 1. **Epidemic Sound**
- URL: https://www.epidemicsound.com
- Cost: ~$15/month
- Quality: Professional
- Huge library

#### 2. **AudioJungle**
- URL: https://audiojungle.net
- Cost: $1-20 per track
- Quality: Professional
- One-time purchase

#### 3. **Artlist**
- URL: https://artlist.io
- Cost: ~$25/month
- Quality: Professional
- Unlimited downloads

---

## 📥 How to Add Files to Xcode

### Step 1: Prepare Your Files

1. Download 15 ambient music tracks
2. Convert to **MP3 format** (if needed)
3. Rename according to the list above
4. Keep file sizes reasonable (< 10MB each)

### Step 2: Create Music Folder

1. In Finder, create a folder named `Music`
2. Place all 15 MP3 files in this folder

### Step 3: Add to Xcode Project

1. **Open Xcode** with your VibeWave project
2. **Right-click** on the `VibeWave` folder in the navigator
3. Select **"New Group"**
4. Name it **"Resources"**
5. **Right-click** on "Resources" folder
6. Select **"New Group"**
7. Name it **"Music"**
8. **Drag the Music folder** from Finder into the "Music" group in Xcode
9. In the dialog that appears:
   - ✅ Check **"Copy items if needed"**
   - ✅ Check **"Create groups"**
   - ✅ Check **"Add to targets: VibeWave"**
10. Click **"Finish"**

### Step 4: Verify Files

1. Select any MP3 file in Xcode
2. Open **File Inspector** (right panel)
3. Verify **"Target Membership"** shows ✅ VibeWave
4. Build the project (`Cmd + B`)
5. Files should now be accessible

---

## 🎨 Creating Your Own Ambient Music

If you want to create custom tracks:

### Tools

1. **GarageBand** (Mac/iOS) - Free
2. **Audacity** (Free, cross-platform)
3. **Logic Pro** (Mac, $200)
4. **Ableton Live** (Cross-platform, $99+)

### Tips for Ambient Music

#### Happy Mood:
- Major keys (C, G, D)
- Bright instruments (piano, guitar, bells)
- Upbeat tempo (120-140 BPM)
- Add nature sounds (birds, water)

#### Calm Mood:
- Slow tempo (60-80 BPM)
- Soft pads and strings
- Nature sounds (ocean, rain, forest)
- Minimal percussion

#### Uplifting (for Sad):
- Gentle build-up
- Major keys
- Hopeful melodies
- Warm instruments

#### Soothing (for Angry):
- Very slow tempo (60-75 BPM)
- Soft, flowing sounds
- No sudden changes
- Calming nature sounds

#### Neutral:
- Balanced tempo (90-110 BPM)
- Neither too bright nor dark
- Ambient textures
- Minimal melody

---

## 🔧 Technical Specifications

### Recommended Format
- **Format**: MP3
- **Bitrate**: 128-192 kbps (good quality, reasonable size)
- **Sample Rate**: 44.1 kHz
- **Channels**: Stereo
- **Duration**: 2-5 minutes

### File Size Guidelines
- Target: 3-8 MB per file
- Total: ~75-120 MB for all 15 files
- Keep under 10 MB per file for app size

### Converting Audio Files

#### Using iTunes/Music App (Mac):
1. Import audio file
2. Select file
3. File → Convert → Create MP3 Version

#### Using Online Converter:
1. Go to https://cloudconvert.com/mp3-converter
2. Upload your audio file
3. Select MP3 format
4. Set bitrate to 192 kbps
5. Download converted file

---

## 🎯 Testing Without Audio Files

The app works without audio files:

1. **Fallback Behavior**: Silent playback with UI working
2. **Duration**: Shows 3:00 (180 seconds)
3. **Controls**: All buttons functional
4. **Equalizer**: Animates normally

This allows you to:
- Test the app immediately
- Add music files later
- Demo the UI and flow

---

## 📝 Quick Start Checklist

- [ ] Download 15 ambient music tracks
- [ ] Convert to MP3 format (if needed)
- [ ] Rename files according to list
- [ ] Create Music folder in Finder
- [ ] Add folder to Xcode project
- [ ] Verify "Copy items if needed" is checked
- [ ] Verify "Add to targets: VibeWave" is checked
- [ ] Build project to confirm
- [ ] Test each mood to hear music

---

## 🎵 Sample Track Suggestions

### From YouTube Audio Library:

**Happy:**
- "Sunny" by Bensound
- "Happy Alley" by Bensound
- "Ukulele" by Bensound

**Calm:**
- "Relaxing Piano" by Kevin MacLeod
- "Meditation" by Bensound
- "Ambient Piano" by Kevin MacLeod

**Uplifting:**
- "Inspiring" by Bensound
- "New Dawn" by Bensound
- "Hope" by Bensound

**Soothing:**
- "Calm" by Bensound
- "Zen Garden" by Bensound
- "Peace" by Bensound

**Neutral:**
- "Ambient" by Bensound
- "Lounge" by Bensound
- "Chill" by Bensound

---

## ⚖️ Legal Considerations

### Always Check:
- ✅ License type (commercial use allowed?)
- ✅ Attribution requirements
- ✅ Modification rights
- ✅ Distribution rights

### Safe Options:
1. **Public Domain** - No restrictions
2. **Creative Commons Zero (CC0)** - No attribution needed
3. **Creative Commons BY** - Attribution required
4. **Paid Licenses** - Clear commercial rights

### Avoid:
- ❌ Copyrighted music without license
- ❌ Music from streaming services
- ❌ Unclear licensing terms

---

## 🎉 You're Ready!

Once you've added the audio files:

1. **Build and run** the app
2. **Record your voice**
3. **Detect your mood**
4. **Hear the music** play!

The app will automatically load and play the correct tracks based on detected mood.

---

**Enjoy creating the perfect ambient soundtrack for VibeWave! 🎵✨**

# 🔧 Step-by-Step: Fix Build Error & Add Permissions

## ✅ Error Fixed!
The `Info.plist` conflict has been resolved. The manual file was removed.

---

## 🎯 Follow These Steps Exactly:

### Step 1: Open Xcode
```bash
cd /Users/udesholith/Downloads/Genuka/VibeWave
open VibeWave.xcodeproj
```
Wait for Xcode to fully load the project.

---

### Step 2: Navigate to Project Settings

1. **Look at the left sidebar** (Navigator)
2. **Click on the top item** - the blue icon labeled "VibeWave"
   - This is the PROJECT, not a folder
   - It should be at the very top of the file list

---

### Step 3: Select the Target

1. **Look at the main editor area** (center of Xcode)
2. **Find the section labeled "TARGETS"**
3. **Click on "VibeWave"** under TARGETS
   - NOT the one under PROJECT
   - It should have a small app icon next to it

---

### Step 4: Go to Info Tab

1. **Look at the tabs at the top** of the editor
   - You'll see: General, Signing & Capabilities, Resource Tags, **Info**, Build Settings, Build Phases, Build Rules
2. **Click on "Info"**

---

### Step 5: Add Microphone Permission

1. **Find the section** "Custom iOS Target Properties"
   - It's a list with columns: Key, Type, Value
   
2. **Hover over any existing row**
   - You'll see a small **"+"** button appear
   
3. **Click the "+" button**
   - A new row appears with a dropdown
   
4. **Start typing**: `Privacy - Microphone`
   - The dropdown will filter
   - Select: **"Privacy - Microphone Usage Description"**
   
5. **Set the value**:
   - Click in the Value column
   - Type: `VibeWave needs access to your microphone to record your voice and detect your mood.`

6. **Press Enter** to confirm

---

### Step 6: Verify the Permission

You should now see a row like this:

| Key | Type | Value |
|-----|------|-------|
| Privacy - Microphone Usage Description | String | VibeWave needs access to your microphone to record your voice and detect your mood. |

---

### Step 7: Clean Build Folder

1. **Go to menu**: Product → Clean Build Folder
2. **Or press**: `Cmd + Shift + K`
3. Wait for "Clean Finished"

---

### Step 8: Build the Project

1. **Go to menu**: Product → Build
2. **Or press**: `Cmd + B`
3. **Wait for build to complete**
4. **Check for success**: Should say "Build Succeeded"

---

### Step 9: Run the App

1. **Select a simulator** from the device dropdown (top toolbar)
   - Recommended: iPhone 17 or iPhone 17 Pro
   
2. **Press the Play button** or press `Cmd + R`

3. **Wait for simulator to launch**

4. **Grant permission** when prompted:
   - A popup will ask for microphone access
   - Tap **"Allow"**

---

### Step 10: Test the App

1. **Tap "Start Recording"**
2. **Speak into your Mac's microphone** for 5 seconds
3. **Wait for mood detection**
4. **See your mood result** with emoji and gradient
5. **Tap "Play Music"** to open the player
6. **Test the controls**: play, pause, next, previous

---

## ✅ Success Checklist

- [ ] Xcode project opens without errors
- [ ] Info.plist conflict is gone
- [ ] Microphone permission is added in Info tab
- [ ] Build succeeds (Cmd + B)
- [ ] App runs on simulator (Cmd + R)
- [ ] Microphone permission prompt appears
- [ ] Recording works after granting permission
- [ ] Mood detection completes
- [ ] Music player opens and works

---

## 🆘 Common Issues

### Issue 1: "Can't find the Info tab"
**Solution**: Make sure you selected the TARGET (under TARGETS section), not the PROJECT.

### Issue 2: "Don't see Custom iOS Target Properties"
**Solution**: You're in the wrong tab. Click the "Info" tab at the top.

### Issue 3: "Build still fails"
**Solution**: 
1. Close Xcode completely
2. Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData/VibeWave-*`
3. Reopen Xcode
4. Clean and build again

### Issue 4: "Permission prompt doesn't appear"
**Solution**: 
1. Check that the permission is added correctly in Info tab
2. Reset simulator: Device → Erase All Content and Settings
3. Run app again

### Issue 5: "Recording doesn't work"
**Solution**: 
1. Make sure you granted microphone permission
2. Check System Settings → Privacy & Security → Microphone
3. Enable for Xcode or the Simulator

---

## 📱 Alternative: Test on Physical Device

For best results, test on a real iPhone:

1. **Connect your iPhone** via USB
2. **Select your iPhone** from device dropdown
3. **Trust the computer** on your iPhone if prompted
4. **Run the app** (Cmd + R)
5. **Grant microphone permission** on device
6. **Test with real voice input**

---

## 🎉 You're Done!

The app should now be working perfectly. Enjoy discovering music based on your mood!

---

## 📚 Additional Resources

- **Full Documentation**: `README.md`
- **Quick Start**: `QUICK_START.md`
- **Project Overview**: `PROJECT_SUMMARY.md`
- **Architecture**: `APP_ARCHITECTURE.md`

---

**Need more help? Check the troubleshooting section above or review the documentation files.**

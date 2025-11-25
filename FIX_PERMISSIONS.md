# 🔧 Fix: Add Microphone Permission in Xcode

## ✅ The Info.plist conflict has been resolved!

The manual `Info.plist` file has been removed. Modern Xcode projects auto-generate this file.

---

## 📝 Add Microphone Permission (Required)

Follow these steps in Xcode:

### Step-by-Step Instructions:

1. **Open the project** in Xcode
   ```bash
   open VibeWave.xcodeproj
   ```

2. **Select the project** (blue icon at top of navigator)
   - Click on **VibeWave** (the blue project icon)

3. **Select the target**
   - Under **TARGETS**, click **VibeWave**

4. **Go to Info tab**
   - Click the **Info** tab at the top

5. **Add microphone permission**
   - Find the section "Custom iOS Target Properties"
   - Hover over any row and click the **"+"** button
   - In the dropdown, type: `Privacy - Microphone Usage Description`
   - Or paste the raw key: `NSMicrophoneUsageDescription`
   - Set the value to:
     ```
     VibeWave needs access to your microphone to record your voice and detect your mood.
     ```

6. **Optional: Add background audio** (if you want music to play in background)
   - Click **"+"** again
   - Select: `Required background modes`
   - Click the arrow to expand
   - Click **"+"** in the array
   - Select: `App plays audio or streams audio/video using AirPlay`

---

## 🚀 Build and Run

1. Press `Cmd + Shift + K` to clean build folder
2. Press `Cmd + B` to build
3. Press `Cmd + R` to run
4. Grant microphone permission when prompted

---

## ✅ Expected Result

- ✅ No build errors
- ✅ App launches successfully
- ✅ Microphone permission prompt appears
- ✅ Recording works after granting permission

---

## 🎯 Alternative: Add via Info.plist (if needed)

If your project still uses a manual Info.plist:

1. Right-click on **VibeWave** folder in navigator
2. Select **New File...**
3. Choose **Property List**
4. Name it `Info.plist`
5. Add these keys:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSMicrophoneUsageDescription</key>
	<string>VibeWave needs access to your microphone to record your voice and detect your mood.</string>
</dict>
</plist>
```

---

## 🆘 Still Having Issues?

### Error: "Multiple commands produce Info.plist"
**Solution**: Make sure you deleted the manual Info.plist file and are using Xcode's auto-generated one.

### Error: "Microphone permission not working"
**Solution**: Check that the permission string is added in the Info tab of your target settings.

### Error: "Build failed"
**Solution**: 
1. Clean build folder: `Cmd + Shift + K`
2. Close and reopen Xcode
3. Try building again

---

**You're all set! The app should build successfully now! 🎉**

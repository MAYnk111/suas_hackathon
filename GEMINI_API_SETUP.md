# 🔑 GEMINI API KEY SETUP

## Quick Setup (2 minutes)

### Step 1: Get Your Gemini API Key
1. Go to: https://makersuite.google.com/app/apikey
2. Click "Create API Key"
3. Copy the API key

### Step 2: Add API Key to App

**Option A: Direct in Code (Fastest for Hackathon)**

Open: `lib/services/gemini_medicine_service.dart`

Replace line 11:
```dart
static const String _geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

With your actual key:
```dart
static const String _geminiApiKey = 'AIzaSyC...your-actual-key...';
```

**Option B: Environment Variable (Production Ready)**

1. Create `.env` file in project root:
```env
GEMINI_API_KEY=AIzaSyC...your-actual-key...
```

2. Update `lib/services/gemini_medicine_service.dart` line 11:
```dart
static final String _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_KEY_HERE';
```

3. Load .env in `main.dart`:
```dart
await dotenv.load(fileName: ".env");
```

### Step 3: Run App
```bash
flutter run -d YOUR_DEVICE_ID
```

---

## 🎯 How It Works (No Backend!)

### Two-Step Validation Process

**STEP 1: DETECTION** (First Gate)
- Gemini checks: "Is this a medicine image?"
- Returns: is_medicine + confidence score
- Threshold: confidence >= 0.7

**STEP 2: HARD STOP** (Critical Gate)
- If NOT medicine OR confidence < 0.7:
  - ❌ STOPS HERE
  - Shows error message
  - NO percentage generated
  - NO analysis runs

**STEP 3: ANALYSIS** (Only if passed)
- Gemini analyzes: "Is this fake or real medicine?"
- Returns: confidence + risk level + details
- ✅ Shows percentage result

---

## 🚨 Expected Behavior

### ❌ Non-Medicine Images
```
User uploads: Book/Food/Random object
    ↓
Gemini Detection: is_medicine=false, confidence=0.2
    ↓
HARD STOP: Validation error thrown
    ↓
User sees: Orange warning "Medicine not detected"
NO PERCENTAGE shown
```

### ✅ Medicine Images
```
User uploads: Medicine strip
    ↓
Gemini Detection: is_medicine=true, confidence=0.9
    ↓
PASSED: Proceeds to analysis
    ↓
Gemini Analysis: fake/real check
    ↓
User sees: "85% Real" or "Fake detected"
```

---

## 🐛 Troubleshooting

### Error: "API key not found"
- Make sure you replaced `YOUR_GEMINI_API_KEY_HERE` with your actual key
- Check for typos in the API key

### Error: "Invalid API key"
- Generate a new API key from Google AI Studio
- Make sure the key is enabled for Gemini API

### Detection always fails
- Check image quality (not too blurry)
- Ensure medicine packaging is clearly visible
- Try with a clear medicine strip photo

### Analysis takes too long
- First time may take 5-10 seconds (Gemini API call)
- Subsequent calls should be faster
- Check internet connection

---

## 💡 Hackathon Tips

1. **Use Option A** (direct in code) for fastest setup
2. Test with 2-3 medicine images first
3. Test with random objects to verify rejection works
4. Debug logs print in console - watch for:
   - 🔍 DETECTION results
   - 🛑 HARD STOP triggers
   - 🔬 ANALYSIS results

---

## 🔒 Security Note

**For Production:**
- Move API key to .env file
- Add .env to .gitignore
- Use Firebase Remote Config or similar for key management
- Never commit API keys to Git

**For Hackathon:**
- Direct in code is fine for demo
- Just don't push to public repo with real key
- Can use environment variable if you prefer

---

## 📝 Benefits of Client-Side Implementation

✅ **No Backend Needed** - Deploy-free, works instantly
✅ **Real Gemini AI** - Same quality as backend solution
✅ **Two-Step Gating** - Percentage NEVER shown for non-medicine
✅ **Offline-First** - Only needs internet for Gemini API
✅ **Easy Testing** - Just run Flutter, no server setup
✅ **Debug Logs** - See detection/analysis in console
✅ **Fast Iteration** - Change logic, hot reload

---

## 🚀 Performance

- **Detection**: ~2-5 seconds (first Gemini call)
- **Analysis**: ~3-7 seconds (second Gemini call)
- **Total**: ~5-12 seconds for full verification
- **Network**: ~100-500 KB per image upload to Gemini

For better performance in production:
- Cache detection results (same image hash)
- Use Gemini Pro for faster responses
- Add loading animations for better UX

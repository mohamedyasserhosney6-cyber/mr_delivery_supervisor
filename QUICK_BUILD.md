# بناء APK بسرعة - MR DELIVERY Supervisor

## الخطوات السريعة

### 1. تحديث Base URL

افتح `lib/core/network/api_client.dart` وحدّث:
```dart
static const String baseUrl = 'http://YOUR_IP:8000';
```

**للتطوير:**
- Emulator: `http://10.0.2.2:8000`
- جهاز حقيقي: `http://192.168.1.XXX:8000` (IP جهازك)

### 2. بناء APK

#### الطريقة 1: استخدام ملف .bat (الأسهل)
```powershell
cd mr_delivery_supervisor
.\build_apk.bat
```

#### الطريقة 2: استخدام Flutter مباشرة
```powershell
cd mr_delivery_supervisor
flutter pub get
flutter build apk --debug
```

### 3. موقع APK

بعد البناء، APK موجود في:
```
mr_delivery_supervisor\build\app\outputs\flutter-apk\app-debug.apk
```

## المتطلبات

- ✅ Flutter SDK مثبت
- ✅ Android SDK مثبت
- ✅ Flutter في PATH

للتحقق:
```powershell
flutter doctor
```

## نصائح

1. **للاختبار السريع:** استخدم Debug APK
2. **للنشر:** استخدم Release APK (يحتاج keystore)
3. **لتقليل الحجم:** استخدم `--split-per-abi`

## استكشاف الأخطاء

### Flutter not found
أضف Flutter إلى PATH:
```powershell
$env:PATH += ";C:\path\to\flutter\bin"
```

### Gradle build failed
```powershell
cd android
.\gradlew clean
cd ..
flutter clean
flutter pub get
```

### Base URL connection failed
- تأكد من أن السيرفر يعمل
- تحقق من IP address
- على Emulator: استخدم `10.0.2.2`
- على جهاز حقيقي: استخدم IP الكمبيوتر


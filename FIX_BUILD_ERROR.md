# 🔧 إصلاح خطأ "Access is denied" في Flutter Build

## المشكلة:
```
PathAccessException: Cannot delete file, path = '...\.dart_tool\flutter_build\...\debug_android_application.stamp'
OS Error: Access is denied, errno = 5
```

## ✅ الحل السريع:

### 1. استخدم ملف `.bat` لإصلاح المشكلة:

```powershell
cd D:\Tb\TB\mr_delivery_supervisor
.\fix_build_permission.bat
```

### 2. أو قم بالخطوات يدوياً:

---

## 📋 الحل اليدوي:

### 1. إيقاف جميع العمليات:

```powershell
# في PowerShell (كمسؤول)
taskkill /F /IM flutter.exe /T
taskkill /F /IM dart.exe /T
taskkill /F /IM java.exe /T
taskkill /F /IM javaw.exe /T
taskkill /F /IM gradle.exe /T
```

**أو أغلق:**
- ✅ Android Studio
- ✅ VS Code (إذا كان مفتوحاً)
- ✅ أي Terminal مفتوح يعمل Flutter/Gradle

### 2. تنظيف مجلدات البناء:

```powershell
cd D:\Tb\TB\mr_delivery_supervisor

# حذف مجلدات البناء
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force android\.gradle -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force android\app\build -ErrorAction SilentlyContinue
```

### 3. تنظيف Flutter:

```powershell
flutter clean
```

### 4. تحديث الحزم:

```powershell
flutter pub get
```

### 5. البناء مرة أخرى:

```powershell
flutter build apk --debug
```

---

## 🔧 حلول إضافية:

### الحل 1: تشغيل PowerShell كمسؤول:

1. **افتح PowerShell كمسؤول:**
   - اضغط Windows + X
   - اختر "Windows PowerShell (Admin)" أو "Terminal (Admin)"

2. **انتقل إلى مجلد المشروع:**
   ```powershell
   cd D:\Tb\TB\mr_delivery_supervisor
   ```

3. **شغّل الأوامر أعلاه**

### الحل 2: إغلاق Android Studio:

1. **أغلق Android Studio تماماً**
2. **انتظر 10 ثوانٍ**
3. **جرّب البناء مرة أخرى**

### الحل 3: حذف ملفات معينة يدوياً:

```powershell
cd D:\Tb\TB\mr_delivery_supervisor

# حذف ملفات محددة
Remove-Item -Force ".dart_tool\flutter_build\*\*.stamp" -ErrorAction SilentlyContinue -Recurse

# تنظيف Flutter
flutter clean
flutter pub get
```

### الحل 4: استخدام `flutter clean` عدة مرات:

```powershell
flutter clean
flutter clean
flutter clean
flutter pub get
flutter build apk --debug
```

---

## ✅ الخطوات الكاملة (الموصى بها):

### 1. أغلق جميع البرامج:
- ✅ Android Studio
- ✅ VS Code
- ✅ أي Terminal مفتوح

### 2. افتح PowerShell كمسؤول:

### 3. شغّل الملف `.bat`:

```powershell
cd D:\Tb\TB\mr_delivery_supervisor
.\fix_build_permission.bat
```

### 4. أو شغّل الأوامر يدوياً:

```powershell
cd D:\Tb\TB\mr_delivery_supervisor

# إيقاف العمليات
taskkill /F /IM flutter.exe /T 2>$null
taskkill /F /IM dart.exe /T 2>$null
taskkill /F /IM java.exe /T 2>$null
taskkill /F /IM javaw.exe /T 2>$null

# تنظيف
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force android\.gradle -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force android\app\build -ErrorAction SilentlyContinue

# Flutter
flutter clean
flutter pub get
flutter build apk --debug
```

---

## 🎯 جرب الآن:

### الطريقة الأسهل:

```powershell
cd D:\Tb\TB\mr_delivery_supervisor
.\fix_build_permission.bat
```

### أو يدوياً:

```powershell
cd D:\Tb\TB\mr_delivery_supervisor

# 1. إيقاف العمليات
Get-Process | Where-Object { $_.ProcessName -like "*flutter*" -or $_.ProcessName -like "*dart*" -or $_.ProcessName -like "*java*" -or $_.ProcessName -like "*gradle*" } | Stop-Process -Force -ErrorAction SilentlyContinue

# 2. تنظيف
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force android\app\build -ErrorAction SilentlyContinue

# 3. البناء
flutter pub get
flutter build apk --debug
```

---

## ⚠️ ملاحظات مهمة:

1. **أغلق Android Studio** قبل البناء
2. **أغلق VS Code** إذا كان مفتوحاً
3. **شغّل PowerShell كمسؤول** إذا استمرت المشكلة
4. **انتظر 10 ثوانٍ** بعد إغلاق البرامج قبل البناء

---

## ✅ بعد البناء الناجح:

1. **ثبت التطبيق على الهاتف:**
   ```powershell
   flutter install
   ```

2. **أو انسخ APK:**
   ```
   android\app\build\outputs\flutter-apk\app-debug.apk
   ```

3. **شغّل Backend API:**
   ```powershell
   cd D:\Tb\TB
   py -m uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
   ```

4. **جرّب تسجيل الدخول:**
   - رقم الموبايل: `01019645374`
   - كلمة المرور: `zxc159ZXC#`

---

**جرب الآن! 🎉**


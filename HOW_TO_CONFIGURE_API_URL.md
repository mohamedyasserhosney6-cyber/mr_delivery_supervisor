# 🔧 كيفية تعديل إعدادات API URL في التطبيق المحمول

## ❌ خطأ شائع:

**لا تحاول تنفيذ كود Dart في Terminal!**

```powershell
# ❌ خطأ - لا تعمل في PowerShell!
static const String baseUrl = 'http://10.0.2.2:8000';
```

**السبب:** PowerShell لا يفهم كود Dart!

---

## ✅ الحل الصحيح:

### 1. افتح ملف `api_client.dart` في محرر النصوص:

```
mr_delivery_supervisor/lib/core/network/api_client.dart
```

### 2. ابحث عن السطر:

```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

### 3. غيّر الرابط حسب نوع الاستخدام:

#### أ) للإيموليتر (Android Emulator):
```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

#### ب) للجهاز الحقيقي (Real Device):
```dart
static const String baseUrl = 'http://YOUR_COMPUTER_IP:8000';
```

**استبدل `YOUR_COMPUTER_IP` بـ IP الكمبيوتر الخاص بك.**

---

## 🔍 كيفية الحصول على IP الكمبيوتر:

### في PowerShell:

```powershell
ipconfig | findstr IPv4
```

**مثال للنتيجة:**
```
IPv4 Address. . . . . . . . . . . : 192.168.1.100
```

**استخدم هذا IP في التطبيق:**
```dart
static const String baseUrl = 'http://192.168.1.100:8000';
```

---

## 📋 الخطوات الكاملة:

### 1. افتح ملف `api_client.dart`:

**المسار الكامل:**
```
D:\Tb\TB\mr_delivery_supervisor\lib\core\network\api_client.dart
```

### 2. ابحث عن السطر رقم 9:

```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

### 3. غيّر الرابط حسب الحاجة:

**للإيموليتر (افتراضي):**
```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

**للجهاز الحقيقي:**
```dart
static const String baseUrl = 'http://192.168.1.100:8000';  // استبدل IP
```

### 4. احفظ الملف

### 5. إذا غيرت الكود، أعد بناء التطبيق:

```powershell
cd mr_delivery_supervisor
flutter clean
flutter pub get
flutter build apk --debug
```

---

## ⚠️ ملاحظات مهمة:

### 1. **للإيموليتر:**
- ✅ استخدم: `http://10.0.2.2:8000`
- ✅ لا يحتاج تغيير IP

### 2. **للجهاز الحقيقي:**
- ✅ تأكد أن Backend API يعمل على `0.0.0.0` وليس `127.0.0.1`
- ✅ تأكد أن الهاتف والكمبيوتر على نفس الشبكة (Wi-Fi)
- ✅ استخدم IP الكمبيوتر

### 3. **Backend API يجب أن يعمل:**
```powershell
cd D:\Tb\TB
py -m uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
```

**مهم:** استخدم `--host 0.0.0.0` وليس `--host 127.0.0.1`

---

## 🎯 مثال كامل:

### 1. احصل على IP الكمبيوتر:

```powershell
ipconfig | findstr IPv4
```

**النتيجة:**
```
IPv4 Address. . . . . . . . . . . : 192.168.1.100
```

### 2. افتح ملف `api_client.dart`:

```
mr_delivery_supervisor/lib/core/network/api_client.dart
```

### 3. غيّر السطر 9:

**من:**
```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

**إلى:**
```dart
static const String baseUrl = 'http://192.168.1.100:8000';
```

### 4. احفظ الملف

### 5. أعد بناء التطبيق:

```powershell
cd mr_delivery_supervisor
flutter clean
flutter pub get
flutter build apk --debug
```

---

## ✅ ملخص:

1. ❌ **لا تنفذ كود Dart في Terminal**
2. ✅ **عدّل ملف `api_client.dart` مباشرة**
3. ✅ **للإيموليتر:** `http://10.0.2.2:8000`
4. ✅ **للجهاز الحقيقي:** `http://YOUR_IP:8000`
5. ✅ **أعد بناء التطبيق** بعد التعديل

---

## 🔧 إذا لم يعمل:

### 1. تأكد أن Backend API يعمل:
```powershell
curl http://localhost:8000/health
```

يجب أن ترى:
```json
{"status": "ok"}
```

### 2. تأكد أن Backend API يعمل على `0.0.0.0`:
```powershell
# شغّل Backend API بهذا الشكل:
py -m uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
```

### 3. تحقق من إعدادات Firewall:
- تأكد أن Windows Firewall يسمح بالاتصال على البورت 8000
- أو أوقف Firewall مؤقتاً للاختبار

### 4. للجهاز الحقيقي:
- تأكد أن الهاتف والكمبيوتر على **نفس الشبكة Wi-Fi**
- تأكد أن IP الكمبيوتر صحيح

---

## 🎯 جرب الآن:

1. **افتح ملف:**
   ```
   mr_delivery_supervisor/lib/core/network/api_client.dart
   ```

2. **تحقق من السطر 9:**
   ```dart
   static const String baseUrl = 'http://10.0.2.2:8000';  // للإيموليتر
   ```

3. **إذا كنت تستخدم إيموليتر:** اتركه كما هو ✅

4. **إذا كنت تستخدم جهاز حقيقي:** غيّره إلى IP الكمبيوتر

5. **احفظ الملف**

6. **أعد بناء التطبيق** إذا غيرت الكود

---

**تذكر:** الكود Dart يُعدّل في ملفات التطبيق، وليس يُنفذ في Terminal! 🎉


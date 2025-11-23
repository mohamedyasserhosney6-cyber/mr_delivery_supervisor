# MR DELIVERY Supervisor App - Setup Guide

## البناء والتشغيل

### المتطلبات
- Flutter SDK 3.0.0 أو أحدث
- Android Studio / VS Code
- Android SDK

### الخطوات

1. **تثبيت الحزم:**
```bash
cd mr_delivery_supervisor
flutter pub get
```

2. **تحديث Base URL:**
افتح `lib/core/network/api_client.dart` وحدّث:
```dart
static const String baseUrl = 'https://api.mr-delivery.local/api';
```
إلى رابط API الخاص بك.

3. **تشغيل التطبيق:**
```bash
flutter run
```

## البنية

```
lib/
├── main.dart                    # نقطة الدخول
├── app_router.dart             # إعدادات التوجيه
├── core/
│   ├── theme/                  # الثيم والألوان
│   ├── network/                # API Client و Dio
│   └── constants/              # الثوابت
└── features/
    ├── auth/                   # المصادقة
    │   ├── domain/models/      # User model
    │   ├── data/               # API & Repository
    │   └── presentation/       # Screens & Providers
    └── dashboard/              # لوحة التحكم
        ├── domain/models/      # Rider, Attendance models
        ├── data/               # API & Repository
        └── presentation/       # Screens, Widgets, Providers
```

## الميزات

- ✅ تسجيل الدخول مع JWT
- ✅ عرض قائمة الطيارين
- ✅ اختيار التاريخ (اليوم/أمس/مخصص)
- ✅ إحصائيات الحضور
- ✅ تفاصيل الطيار مع الحضور
- ✅ بحث عن الطيارين
- ✅ Pull to refresh
- ✅ واجهة عربية RTL
- ✅ ثيم داكن

## API Endpoints المطلبة

التطبيق يتوقع هذه الـ Endpoints:

1. `POST /auth/login`
   - Body: `{ "phone": "...", "password": "..." }`
   - Response: `{ "id": 1, "name": "...", "token": "..." }`

2. `GET /supervisor/me`
   - Headers: `Authorization: Bearer <token>`
   - Response: `{ "id": 1, "name": "...", "role": "supervisor" }`

3. `GET /supervisor/riders?date=YYYY-MM-DD`
   - Headers: `Authorization: Bearer <token>`
   - Response: `{ "riders": [RiderAttendance...] }`

4. `GET /supervisor/riders/{riderId}`
   - Headers: `Authorization: Bearer <token>`
   - Response: `RiderAttendance`

## ملاحظات

- التطبيق يستخدم SharedPreferences لحفظ JWT token
- عند انتهاء الجلسة (401) يتم تسجيل الخروج تلقائياً
- جميع النصوص بالعربية
- التصميم متوافق مع الشاشات الصغيرة (360x640+)


# دليل إنشاء حساب مشرف لتطبيق الهاتف المحمول

## نظرة عامة

تطبيق الهاتف المحمول (`mr_delivery_supervisor`) يحتاج إلى:
- **رقم الموبايل**: من جدول `supervisors`
- **كلمة المرور**: من جدول `users`

## الخطوات المطلوبة

### 1. تشغيل تطبيق الديسكتوب (MR DELIVERY Desktop)

افتح تطبيق `main.py` أو `MR-DELVERY-Desktop.exe`

### 2. إنشاء مشرف جديد

1. اضغط على **"⚙ الإعدادات"** في الشريط العلوي
2. اختر تبويب **"المشرفين"**
3. اضغط **"إضافة مشرف"**
4. أدخل:
   - **الاسم**: اسم المشرف (مثال: "أحمد محمد")
   - **التليفون**: رقم الموبايل الذي سيستخدمه المشرف في التطبيق (مثال: "01234567890")
   - **المجموعة**: اسم المجموعة (اختياري)

### 3. إنشاء مستخدم (User) للمشرف

1. في نفس نافذة الإعدادات، اختر تبويب **"مستخدم جديد"**
2. أدخل:
   - **البريد الإلكتروني**: أي بريد (مثال: "supervisor1@example.com")
   - **الاسم**: نفس اسم المشرف أو أي اسم
   - **كلمة المرور**: كلمة المرور التي سيستخدمها المشرف (مثال: "password123")
   - **رابط الشيت**: رابط Google Sheet الذي يحتوي على بيانات الطيارين
   - **GID**: GID الشيت (عادة "0")
3. اضغط **"إنشاء المستخدم وربط الشيت"**

⚠️ **مهم**: هذا ينشئ مستخدم بـ role="admin" فقط. نحتاج تغيير role إلى "supervisor" يدوياً أو عبر SQL.

### 4. ربط المستخدم بالمشرف

**الطريقة 1: عبر SQL (الأسهل)**

افتح قاعدة البيانات `mr_delivery.db` في أي برنامج SQLite (مثل DB Browser for SQLite) ونفذ:

```sql
-- 1. إنشاء أو تحديث المستخدم مع role="supervisor"
UPDATE users 
SET role = 'supervisor' 
WHERE email = 'supervisor1@example.com';

-- 2. ربط المشرف بالمستخدم (استبدل supervisor_id و user_id بالقيم الصحيحة)
-- أولاً، ابحث عن ID المشرف:
SELECT id, name, phone FROM supervisors WHERE phone = '01234567890';

-- ثانياً، ابحث عن ID المستخدم:
SELECT id, email, role FROM users WHERE email = 'supervisor1@example.com';

-- ثالثاً، ربطهما:
UPDATE supervisors 
SET user_id = (SELECT id FROM users WHERE email = 'supervisor1@example.com')
WHERE phone = '01234567890';
```

**الطريقة 2: تعديل الكود (متقدم)**

يمكن تعديل `app/models.py` لدعم إنشاء مستخدم بـ role="supervisor" مباشرة.

### 5. التحقق من البيانات

نفذ هذه الاستعلامات للتحقق:

```sql
-- التحقق من المشرف
SELECT * FROM supervisors WHERE phone = '01234567890';

-- التحقق من المستخدم
SELECT * FROM users WHERE role = 'supervisor';

-- التحقق من الربط
SELECT 
    s.id as supervisor_id,
    s.name as supervisor_name,
    s.phone,
    u.id as user_id,
    u.email,
    u.role
FROM supervisors s
LEFT JOIN users u ON s.user_id = u.id
WHERE s.phone = '01234567890';
```

### 6. تشغيل Backend API

تأكد أن Backend API يعمل:

```powershell
cd D:\Tb\TB
.\run_backend_direct.bat
```

أو:
```powershell
python run_backend.py
```

Backend يجب أن يعمل على: `http://localhost:8000`

### 7. إعداد التطبيق المحمول

افتح `mr_delivery_supervisor/lib/core/network/api_client.dart` وتأكد أن:
- Base URL يشير إلى Backend API (عادة `http://localhost:8000` أو IP السيرفر)

### 8. تسجيل الدخول في التطبيق المحمول

استخدم:
- **رقم الموبايل**: الرقم الذي أدخلته في جدول `supervisors` (مثال: "01234567890")
- **كلمة المرور**: كلمة المرور التي أدخلتها عند إنشاء `user` (مثال: "password123")

---

## ملخص سريع

```
1. افتح تطبيق Desktop → الإعدادات → المشرفين → إضافة مشرف
   - الاسم: "أحمد محمد"
   - التليفون: "01234567890"

2. الإعدادات → مستخدم جديد → إنشاء مستخدم
   - البريد: "supervisor1@example.com"
   - كلمة المرور: "password123"
   - رابط الشيت: [رابط Google Sheet]

3. عدّل في قاعدة البيانات:
   UPDATE users SET role = 'supervisor' WHERE email = 'supervisor1@example.com';
   UPDATE supervisors SET user_id = [user_id] WHERE phone = '01234567890';

4. شغّل Backend API

5. في التطبيق المحمول:
   - رقم الموبايل: 01234567890
   - كلمة المرور: password123
```

---

## استكشاف الأخطاء

### الخطأ: "بيانات الدخول غير صحيحة"
- تأكد أن رقم الموبايل موجود في جدول `supervisors`
- تأكد أن `supervisors.user_id` مرتبط بـ `users.id`
- تأكد أن `users.role = 'supervisor'`
- تأكد أن كلمة المرور صحيحة

### الخطأ: "هذا الحساب ليس لمشرف"
- تأكد أن `users.role = 'supervisor'` وليس `'admin'`

### الخطأ: "لم يتم ربط شيت بهذا الحساب"
- تأكد أن جدول `user_sheets` يحتوي على صف مرتبط بـ `user_id`
- تأكد أن `sheet_url` صحيح ومتاح

### Backend API لا يعمل
- تأكد أن Backend يعمل على `http://localhost:8000`
- تأكد أن قاعدة البيانات موجودة وصحيحة
- راجع ملفات `RUN_API_WINDOWS.md` أو `QUICK_START.md`


# Tafsila - Body Measurement App

## متطلبات تشغيل المشروع
1. تثبيت Flutter SDK
   - قم بتحميل وتثبيت Flutter SDK من [الموقع الرسمي](https://flutter.dev/docs/get-started/install)
   - أضف Flutter لمتغيرات النظام (PATH)
   - تأكد من تثبيت Flutter بنجاح عن طريق تشغيل الأمر `flutter doctor` في Terminal

2. تثبيت Android Studio
   - قم بتحميل وتثبيت Android Studio من [الموقع الرسمي](https://developer.android.com/studio)
   - قم بتثبيت Android SDK
   - قم بإنشاء Android Virtual Device (AVD) للمحاكاة

3. تثبيت Visual Studio Code (اختياري)
   - قم بتحميل وتثبيت VS Code من [الموقع الرسمي](https://code.visualstudio.com/)
   - قم بتثبيت إضافة Flutter في VS Code

## إصدارات الأدوات المستخدمة
- Java: JDK 11
- Kotlin: متوافق مع JVM target 11
- NDK: الإصدار 26.3.1157926
- Minimum SDK: يتم تحديده بواسطة Flutter
- Target SDK: يتم تحديده بواسطة Flutter
- Compile SDK: يتم تحديده بواسطة Flutter

## خطوات تشغيل المشروع
1. فتح المشروع
   ```bash
   cd Tafsila
   ```

2. تثبيت المكتبات المطلوبة
   ```bash
   flutter pub get
   ```

3. تشغيل المشروع
   ```bash
   flutter run
   ```

## المكتبات المستخدمة
- camera: ^0.10.5+9
- path_provider: ^2.1.2
- path: ^1.8.3
- google_mlkit_pose_detection: ^0.10.0
- image: ^4.1.6
- shared_preferences: ^2.2.2
- url_launcher: ^6.2.5

## ملاحظات هامة
- تأكد من تفعيل وضع المطور على هاتف Android المستخدم للتجربة
- تأكد من تثبيت تطبيق Gmail للتواصل مع الدعم الفني
- تأكد من وجود كاميرا في الجهاز المستخدم للتجربة

## المتطلبات الأساسية للنظام
- Flutter 3.0.0 أو أحدث
- Dart 2.17.0 أو أحدث
- Android Studio Arctic Fox أو أحدث
- Android SDK version 21 أو أحدث
- 4GB RAM على الأقل
- مساحة تخزين 10GB على الأقل

## حل المشاكل الشائعة
1. مشكلة عدم العثور على Flutter SDK
   - تأكد من إضافة Flutter لمتغيرات النظام
   - قم بتشغيل `flutter doctor` للتحقق من المشكلة

2. مشكلة في تشغيل المحاكي
   - تأكد من تفعيل Virtualization في إعدادات BIOS
   - تأكد من تثبيت HAXM

3. مشكلة في تثبيت المكتبات
   - قم بحذف ملف pubspec.lock وتشغيل `flutter pub get` مرة أخرى

## للمساعدة والدعم
في حالة وجود أي مشاكل، يرجى التواصل مع:
- Email: michealprojectteam@gmail.com

---

# Project Setup Guide (English)

## Prerequisites
1. Install Flutter SDK
   - Download and install Flutter SDK from [official website](https://flutter.dev/docs/get-started/install)
   - Add Flutter to system PATH
   - Verify installation with `flutter doctor`

2. Install Android Studio
   - Download and install from [official website](https://developer.android.com/studio)
   - Install Android SDK
   - Create Android Virtual Device (AVD)

3. Install VS Code (optional)
   - Download and install from [official website](https://code.visualstudio.com/)
   - Install Flutter extension

## Build Tool Versions
- Java: JDK 11
- Kotlin: Compatible with JVM target 11
- NDK: Version 26.3.1157926
- Minimum SDK: Determined by Flutter
- Target SDK: Determined by Flutter
- Compile SDK: Determined by Flutter

## Setup Steps
1. Open project
   ```bash
   cd Tafsila
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run project
   ```bash
   flutter run
   ```

## Dependencies
- camera: ^0.10.5+9
- path_provider: ^2.1.2
- path: ^1.8.3
- google_mlkit_pose_detection: ^0.10.0
- image: ^4.1.6
- shared_preferences: ^2.2.2
- url_launcher: ^6.2.5

## Important Notes
- Enable Developer options on Android device
- Install Gmail app for support contact
- Ensure device has a camera

## System Requirements
- Flutter 3.0.0 or higher
- Dart 2.17.0 or higher
- Android Studio Arctic Fox or higher
- Android SDK version 21 or higher
- Minimum 4GB RAM
- Minimum 10GB storage

## Troubleshooting
1. Flutter SDK not found
   - Verify PATH environment variable
   - Run `flutter doctor`

2. Emulator issues
   - Enable Virtualization in BIOS
   - Install HAXM

3. Package installation issues
   - Delete pubspec.lock and run `flutter pub get`

## Support
For any issues, please contact:
- Email: michealprojectteam@gmail.com

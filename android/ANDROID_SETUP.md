# Android setup (run AFTER `flutter create . --platforms=android,web`)

## android/app/src/main/AndroidManifest.xml
Above `<application ...>` add:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```
Inside `<application ...>` (before the closing tag) add:
```xml
<receiver android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"/>
<receiver android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
    </intent-filter>
</receiver>
```

## android/app/build.gradle.kts
```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
```
(Groovy `build.gradle`: `coreLibraryDesugaringEnabled true` and
`coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'`.)

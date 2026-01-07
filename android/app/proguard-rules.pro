# Flutter-specific ProGuard rules

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Dart classes that might be accessed via reflection
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# flutter_secure_storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Play Core library (for deferred components, even if not used)
-dontwarn com.google.android.play.core.**

# Kotlin Coroutines (if used by plugins)
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}

# Gson (if used)
-keepattributes Signature
-keep class com.google.gson.** { *; }

# General Android
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}

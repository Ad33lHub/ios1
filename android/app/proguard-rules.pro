# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Keep Flutter Local Notifications plugin classes
-keep class * extends com.dexterous.flutterlocalnotifications.** { *; }

# Preserve notification classes
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep timezone classes
-keep class tzdata.** { *; }
-dontwarn tzdata.**

# Keep generic type information
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses


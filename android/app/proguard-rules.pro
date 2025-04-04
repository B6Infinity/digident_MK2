# Keep TensorFlow Lite GPU classes
-keep class org.tensorflow.lite.** { *; }
-keep class com.google.android.play.** { *; }
-dontwarn org.tensorflow.lite.**

# Keep Play Core SplitInstall classes
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.**
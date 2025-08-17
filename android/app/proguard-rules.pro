# -----------------------------
# Flutter specific rules
# -----------------------------
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.view.** { *; }

# -----------------------------
# ML Kit - Chinese text model
# -----------------------------
-keep class com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions { *; }
-keep class com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions$Builder { *; }

# -----------------------------
# General ML Kit rules
# -----------------------------
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit.** { *; }
-keep class com.google.mlkit.vision.text.** { *; }

# -----------------------------
# TensorFlow Lite + GPU delegate
# -----------------------------
# Keep all TFLite classes
-keep class org.tensorflow.lite.** { *; }

# Keep GPU delegate and options
-keep class org.tensorflow.lite.gpu.** { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options$GpuBackend { *; }

# This rule is also often needed to keep the basic TFLite interpreter
-keep class org.tensorflow.lite.Interpreter { *; }

# Ignore warnings for TFLite GPU
-dontwarn org.tensorflow.lite.gpu.**

# -----------------------------
# Google Play Core (SplitInstall, SplitCompat)
# -----------------------------
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# -----------------------------
# Play Core tasks (Task, OnSuccessListener, etc.)
# -----------------------------
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.tasks.**
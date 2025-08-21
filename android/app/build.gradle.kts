import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}


android {
    namespace = "com.csuzarte.easycart.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.csuzarte.easycart.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // bom para ML Kit + TFLite (muitas libs)
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
        kotlinOptions.jvmTarget = "11"
    }

    buildTypes {
		signingConfigs {
			create("release") {
				keyAlias = keystoreProperties["keyAlias"] as String
				keyPassword = keystoreProperties["keyPassword"] as String
				storeFile = keystoreProperties["storeFile"]?.let { file(it) }
				storePassword = keystoreProperties["storePassword"] as String
			}
		}
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug")
			signingConfig = signingConfigs.getByName("release")
        }
        debug {
            isMinifyEnabled = false
        }
    }
}

dependencies {
    // AndroidX multidex (evita limite de 65k métodos)
    implementation("androidx.multidex:multidex:2.0.1")

    // Google Material
    implementation("com.google.android.material:material:1.12.0")

    // Play Core (necessário para FlutterPlayStoreSplitApplication / deferred components)
    implementation("com.google.android.play:core:1.10.3")

    // ML Kit Text Recognition (Latin e outros idiomas)
    implementation("com.google.mlkit:text-recognition:16.0.0")
    implementation("com.google.mlkit:text-recognition-chinese:16.0.0")
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.0")
    implementation("com.google.mlkit:text-recognition-japanese:16.0.0")
    implementation("com.google.mlkit:text-recognition-korean:16.0.0")

    // TensorFlow Lite GPU (se realmente precisar de aceleração de GPU)
    implementation("org.tensorflow:tensorflow-lite-gpu:2.12.0")
}

flutter {
    source = "../.."
}
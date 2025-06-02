import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
  namespace = "com.adibasa.app"
  compileSdk = flutter.compileSdkVersion
  ndkVersion = "29.0.13113456"

  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
  }

  kotlinOptions {
    jvmTarget = JavaVersion.VERSION_11.toString()
  }

  defaultConfig {
    applicationId = "com.adibasa.app"
    minSdk = 23
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
  }

  signingConfigs {
    create("release") {
      keyAlias = keystoreProperties.getProperty("keyAlias")
      keyPassword = keystoreProperties.getProperty("keyPassword")
      storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
      storePassword = keystoreProperties.getProperty("storePassword")
    }
  }
  buildTypes {
    release {
      // TODO: Add your own signing config for the release build.
      // Signing with the debug keys for now,
      // so `flutter run --release` works.
      // signingConfig = signingConfigs.getByName("debug")
      signingConfig = signingConfigs.getByName("release")
    }
  }
}

flutter {
    source = "../.."
}

dependencies {
    // In‑App Updates (core + Kotlin extensions)
    implementation("com.google.android.play:app-update:2.1.0")
    implementation("com.google.android.play:app-update-ktx:2.1.0")

    // In‑App Review
    implementation("com.google.android.play:review:2.0.1")

    // Asset Delivery (if you bundle large assets)
    implementation("com.google.android.play:asset-delivery:2.3.0")
    implementation("com.google.android.play:asset-delivery-ktx:2.3.0")

    // Dynamic Feature Delivery (if you use on‑demand modules)
    implementation("com.google.android.play:feature-delivery:2.1.0")
    implementation("com.google.android.play:feature-delivery-ktx:2.1.0")

    // Google Play Tasks API (for callbacks)
    implementation("com.google.android.gms:play-services-tasks:18.0.2")
}


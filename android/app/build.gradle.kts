plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
  namespace = "com.example.adibasa_app"
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
    applicationId = "com.example.adibasa_app"
    minSdk = 23
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
  }

  buildTypes {
    release {
      // Kotlin-DSL properties:
      isMinifyEnabled    = false
      isShrinkResources  = false

      // still using debug keys for now:
      signingConfig = signingConfigs.getByName("debug")

      // call the method, don’t assign to it:
      proguardFiles(
        getDefaultProguardFile("proguard-android.txt"),
        "proguard-rules.pro"
      )
    }
  }
}

flutter {
    source = "../.."
}

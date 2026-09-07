plugins {
    id("com.android.application")

    // O Flutter Gradle Plugin deve ser aplicado
    // depois do Android Gradle Plugin.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.poc_unimed"

    /*
     * Mantido em 36 para compatibilidade com a versão atual
     * do Android Gradle Plugin utilizada pelo projeto.
     */
    compileSdk = 36

    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        /*
         * Identificador provisório da POC.
         * Antes da publicação, substituir por um identificador definitivo,
         * por exemplo: br.com.unimedpoa.poc
         */
        applicationId = "com.example.poc_unimed"

        /*
         * Android 7.0 ou superior.
         * Essa configuração oferece compatibilidade adequada
         * com os plugins utilizados pela POC.
         */
        minSdk = 24

        /*
         * Mantido em 36 para não habilitar antecipadamente
         * alterações comportamentais do Android API 37.
         */
        targetSdk = 36

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            /*
             * Configuração provisória para a POC.
             * Antes da publicação, criar uma chave própria de assinatura.
             */
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
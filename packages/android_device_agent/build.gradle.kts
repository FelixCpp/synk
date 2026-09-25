import java.util.Properties

plugins {
  kotlin("jvm") version "2.0.21"
  id("com.gradleup.shadow") version "9.6.1"
}

repositories {
  mavenCentral()
}

val localProperties = Properties().apply {
  load(rootDir.resolve("local.properties").inputStream())
}

val sdkDir = localProperties.getProperty("sdk.dir")

dependencies {
    compileOnly(files("$sdkDir/platforms/android-34/android.jar"))
    implementation("com.google.protobuf:protobuf-javalite:4.36.2")
}

kotlin {
    jvmToolchain(17)
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // Note: -Xlint:-options removed as it's not compatible with Java 17+
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Set JVM toolchain to suppress Java version warnings
    project.plugins.withType<JavaPlugin> {
        project.extensions.getByType<JavaPluginExtension>().toolchain {
            languageVersion.set(JavaLanguageVersion.of(11))
        }
    }
    
    // Configure Java compatibility for all subprojects (including Android plugins)
    afterEvaluate {
        // Configure Android projects
        extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_11
                targetCompatibility = JavaVersion.VERSION_11
            }
        }
        
        // Configure all Java compilation tasks to use Java 11 and suppress obsolete warnings
        tasks.withType<JavaCompile>().configureEach {
            sourceCompatibility = "11"
            targetCompatibility = "11"
            // Suppress warnings about obsolete Java 8 options
            options.compilerArgs.add("-Xlint:-options")
        }
        
        // Also configure for Kotlin projects
        extensions.findByType<org.jetbrains.kotlin.gradle.dsl.KotlinJvmOptions>()?.apply {
            jvmTarget = "11"
        }
    }
    
    // Note: -Xlint:-options removed as it's not compatible with Java 17+
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
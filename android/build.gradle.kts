allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // Suppress Java 8 obsolete warnings
    tasks.withType<JavaCompile> {
        options.compilerArgs.addAll(listOf("-Xlint:-options"))
    }
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
    
    // Suppress Java 8 obsolete warnings for all subprojects
    tasks.withType<JavaCompile> {
        options.compilerArgs.addAll(listOf("-Xlint:-options"))
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
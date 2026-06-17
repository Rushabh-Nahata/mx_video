allprojects {
    repositories {
        google()
        mavenCentral()
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
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Force all plugins to compile against at least SDK 36 so that
// transitive AndroidX dependencies (which require 34+) don't fail.
subprojects {
    val applySdk = Action<Project> {
        extensions.findByType<com.android.build.gradle.BaseExtension>()?.let { android ->
            if ((android.compileSdkVersion?.removePrefix("android-")?.toIntOrNull() ?: 0) < 36) {
                android.compileSdkVersion(36)
            }
        }
    }
    if (state.executed) {
        applySdk.execute(this)
    } else {
        afterEvaluate(applySdk)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

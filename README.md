# SrfGroupMobile

A new Flutter project.

## Check list devices
$ flutter devices

## Run app 
$ flutter run

## Build debug apk
$ flutter build apk

## Build apk with Stacktrace
cd android
gradlew assembleDebug --stacktrace

## Build signed apk
in /android/app/build.gradle: 
    buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
$ flutter build apk

## Upgrade
$ flutter upgrade

## Generate translation
$ flutter gen-l10n

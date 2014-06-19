iOS mobile-sdk-harness
==================

* Run ./update.platform.sh -p ios to get the latest platform libraries and headers.
* The accompanying project has no code signing, so run in the simulator (or provide your own credentials).
* The platform needs an API key to operate. Sign up at https://appstore.eegeo.com/ to get your API key and introduce it into the following line in ViewController.mm : 
	#define API_KEY "OBTAIN API_KEY FROM https://appstore.eegeo.com AND INSERT IT HERE".
* Scroll between the examples using the Next and Previous buttons; the current example name is displayed at the top of the screen.
* To build at the command line, run ./build -p ios from the repository root.

android mobile-sdk-harness
==========================

* Install the Android SDK and NDK
* Run ./update.platform.sh -p android to get the latest platform libraries and headers.
* Open an ADT Eclipse workspace, importing this repository as an Android project
* Set the NDK location in the ADT Eclipse workspace to where it was installed (Menu->ADT->Android->NDK)
* Configure your workspace:
    * File -> Import -> Android: 'Existing Android Code Into Workspace'
    * Select the 'android' directory in the repository
    * ADT -> Preferences -> Android -> NDK : Set NDK location
    * Select imported activity -> Android Tools : 'Add native support'
    * Select jni directory -> New folder -> Advanced -> Linked folder : mobile-sdk-harness/src
* Bring up the project menu, from within Android Tools add native support to the project
* The platform needs an API key to operate. Sign up at https://appstore.eegeo.com/ to get your API key and introduce it into the following line in jni/main.cpp : 
	#define API_KEY "OBTAIN API_KEY FROM https://appstore.eegeo.com AND INSERT IT HERE"
* Build and debug from within ADT Eclipse
* build.sh can be used to generate the native library if you want to manually package the .apk
* Scroll between the examples using the Next and Previous buttons, or select the example from the drop-down list; the current example name is displayed at the top of the screen. 
* To build at the command line, run ./build -p android from the repository root.

iOS c++11 support
=================
* ./update.platform.sh -p ios -c will fetch c++11/libc++ ABI compatible versions of the SDK for libc++
* ./build -p ios -c from the command line will build targeting c++11 / libc++
* An additional target in the XCode project file is provided for c++11 support: ExampleAppCpp11

android c++11 support
=====================
* Coming Soon(tm)

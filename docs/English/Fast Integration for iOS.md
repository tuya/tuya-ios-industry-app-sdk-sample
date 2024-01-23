This topic describes how to quickly integrate **Tuya Industry App SDK** for iOS into your development environment, such as Xcode. It also sheds light on the initialization method and how to enable the debugging mode with a few simple steps. This allows you to run the demo app and get started with your app development by using the Industry App SDK.

## Prerequisites

1. Before you start, consult with the project manager (PM) about account registration and requesting the key.
2. The following software is installed:
   - Xcode 12.0 or later
   - CocoaPods 1.10.0 or later
3. Your project must be targeted to iOS 10.0 or later.

## Integrate with the SDK

### Step 1: Create an iOS project

Create a project in Xcode.

### Step 2: Import the SDK

1. (Optional) If you have not created the `Podfile`, create one.

	```bash
	$ cd your-project-directory
	```

	```bash
	$ pod init
	```

2. In the `Podfile`, add the Industry App SDK and source.

	```ruby
	source 'https://cdn.cocoapods.org/'
	source 'https://github.com/tuya/TuyaPublicSpecs.git'
	source 'https://github.com/tuya/tuya-industry-pod-specs'

	target 'your-project' do
	pod 'IndustryLinkSDK', '2.0.0-beta.2'
	end
	```

3. Install a pod, open the `.xcworkspace` file, and then view the project in Xcode.

	```bash
	$ pod install
	```

	```bash
	$ open your-project.xcworkspace
	```

:::info
The Industry App SDK is a closed-source Swift library. To use this library in a pure Objective-C project, you must add an empty Swift file in your project. Xcode will ask you whether to create a bridging header file. Choose to create it.
source 'https://github.com/tuya/tuya-industry-pod-specs'
If you cannot download the code from GitHub, contact your project manager (PM) and provide your GitHub account so they can grant you permission.
:::

### Step 3: Initialize the SDK

In `AppDelegate.swift`, add the following code block to `didFinishLaunchingWithOptions`:

```swift
IndustryLinkSDK.initialize(withAppKey: "appKey", appSecret: "appSecret", clientId: "clientID", clientSecret: "clientSecret")
```

Obtain the `appKey`, `appSecret`, `clientID`, and `clientSecret` from your PM.

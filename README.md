# Tuya Industry App SDK iOS Sample

## Functional Overview

This sample provides Tuya Industry App SDK examples of basic functions such as device network configuration, login and registration, and asset management of Tuya Open API.

Industry App SDK Sample has the following functions:

- User module (login, logout)
- Asset module (asset query, selection)
- Equipment distribution module (AP, QRcode mode)
- Equipment module (equipment query, equipment unbinding)

## API Reference Docs

iOS Industry App SDK API Reference: https://tuya.github.io/tuya-ios-iot-app-sdk-sample/

## Prerequisites

1. A developer account is registered on the [Tuya IoT Development Platform](https://auth.tuya.com/register?from=https%3A%2F%2Fdeveloper.tuya.com%2Fcn%2Fdocs%2Fapp-development%2F).

2. Your account identity is verified.

	![Identity Verification](https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/163159555453b1793f68b.png)

## Before you start

This section describes the steps to configure an industry project on top of Cloud Development. For more information, see [Quick Start](https://developer.tuya.com/en/docs/iot/quick-start1?id=K95ztz9u9t89n).

1. Log in to the [Tuya IoT Development Platform](https://iot.tuya.com/).

2. In the left-side navigation bar, choose **Cloud** > **Development**.

3. On the page that appears, click **Create Cloud Project**.

4. In the **Create Cloud Project** dialog box:

	- Set **Project Name**, **Description**, **Industry**, and **Data Center**.

	> **Info:**
	>	Tuya deploys six data centers globally and provides reliable IoT cloud services for customers worldwide. You can select one or more data centers where your services are deployed. This setting can be changed later.

	- From the **Development Method** drop-down list, select **Custom**.

		<img src="https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/16389595613504029df2c.png" width="550">

5. Click **Create** to continue with project configuration.

6. On the **Authorize API Services** page, besides the default selections, you need to subscribe to the API products such as **Device Status Notification** and **Industry Project Client Service**, and click **Authorize**.

	<img src="https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/16389596785f317e74027.png" width="550">

> **Info:**
>	By default, the API services **IoT Core** and **Authorization** are selected.
	

7. Click **Authorize**.

8. Enter the asset and account information. Then, the asset will be automatically created and the account will be granted access to the asset. For more information, see [Asset Management](https://developer.tuya.com/en/docs/app-development/iot_app_sdk_core_asset?id=Kaq76kp0ifm74).

> **Info:**
>	Tuya provides [IoT Core](https://www.tuya.com/vas/tmpl/apply?code=IOT_CORE) that drives your success with industry-specific device connection and management capabilities. This service can quickly integrate with existing systems and boost your development of IoT core applications targeted to different industry scenarios.


## Create an application

This section describes how to create an application in the cloud project.

1. Open your cloud project.

2. Choose **Authorization** > **App Authorization**.

	![App Authorization](https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/1638959749fee62767c17.png)

3. In the **Add Application** dialog box, configure the application information. Select an application type for **Android** or **iOS**.

	<img src="https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/16389595617bdc33fa878.png" width="550">

4. Enter the information in the fields for the specified application type. If you select the application for Android, you must get the value of **SHA1**. For more information, see [How to Get SHA1 and SHA256 Keys](https://developer.tuya.com/en/docs/app-development/iot_app_sdk_core_sha1?id=Kao7c7b139vrh).

> **Important:**
>	The generated keystore file and encryption information must be kept well. They will be used for subsequent [SDK integration](https://developer.tuya.com/en/docs/app-development/iot_app_sdk_core_integrate?id=Kao6tmwqq0va3).


## Quick Start

1. The Tuya Industry App SDK is distributed through [CocoaPods](http://cocoapods.org/) and other dependencies in this sample. Make sure that you have installed CocoaPods. If not, run the following command to install CocoaPods first:

```bash
sudo gem install cocoapods
pod setup
```

2. Clone or download this sample, change the directory to the one that includes **Podfile**, and then run the following command:

```bash
pod install
```

3. Obtain the Client ID and Client Secret of the created iOS application on the **Applications**>**App**.
   <img src="https://images.tuyacn.com/app/hass/ios_keys_intro.png" style="zoom:50%;" />
4. Open the `TuyaIoTAppSDKSample-iOS-Swift.xcworkspace` pod generated for you.

5. Fill in the AppKey and AppSecret in the **AppKey.swift** file.

```swift
struct AppKey {
    static let appKey = "Client ID"
    static let secretKey = "Client Secret"
}
```

**Note**: The bundle ID, AppKey, and AppSecret must be the same as your app on the [Tuya IoT Platform](https://iot.tuya.com). Otherwise, the sample cannot request the API.

## Sample App Features Overview

### Account Login

<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_login.png" width="30%" /> 
<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_sample_home.png" width="30%" /> 

### Swich Asset

<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_switchAsset.png" width="30%" /> 

### Device Network Pairing

<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_ap.png" width="30%" /> 
<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_qrMode.png" width="30%" /> 
<img src="https://images.tuyacn.com/app/IoTAppSDK/android_nb_device.png" width="30%" /> 
<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_wired_home.png" width="30%" /> 

### Device List and Details

<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_deviceList.png" width="30%" /> 
<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_deviceDetail2.png" width="30%" /> 

## Issue Feedback

You can provide feedback on your issue via **GitHub Issue** or [Ticket](https://service.console.tuya.com).

## License

Tuya Industry App SDK Sample is available under the MIT license. Please see the [LICENSE](LICENSE) file for more info.

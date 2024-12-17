# Tuya Industry App SDK iOS Sample

## Functional Overview

This sample provides Tuya Industry App SDK examples of basic functions such as device network configuration, login and registration, and asset management of Tuya Open API.

Industry App SDK Sample has the following functions:

- User module (login, logout)
- Asset module (asset query, selection)
- Equipment distribution module (AP, QRcode mode)
- Equipment module (equipment query, equipment unbinding)

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


## Quick Start

### Integrate SDK
Execute `$ pod update` and the downloaded SDK will be automatically integrated into the iOS project.

### Package name
- Open the project settings, click **Target** > **General**, and then modify **Bundle Identifier** to the iOS Bundle ID set on the Tuya IoT Platform

### Secret Info
<img src="https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/content-platform/hestia/1682247340ea33064cc2d.png" width="650"/>

### Cloud project Info
The user needs the projectCode information when logging in.
<img src="https://images.tuyacn.com/rms-static/ae4d89e0-11d8-11ef-9eac-b120705c4c0c-1715680780670.png?tyName=smart-industry-link-ios-cloudproject-info-en.png" width="650" />

### Authorization in cloud project
When initializing the SDK, you need the Client ID and Client Secret information.
<img src="https://images.tuyacn.com/rms-static/35886c50-11c4-11ef-8f06-49ae7b2fadcf-1715671988117.png?tyName=52c2d9ad-2aa1-43d9-a054-8e42a352ee1b.png" width="650"/>

### Initialize the SDK
Objective-C
```objc
// init url
[IndustryLinkSDK setHost:<#your_app_host#>];

// IndustryLinkSDK
[IndustryLinkSDK initializeWithAppKey:<#your_app_key#>
                            appSecret:<#your_app_secret_key#>
                             clientId:<#your_clientId#>
                         clientSecret:<#your_client_secret#>];

[MQTTBusinessPlugin initializePlugin];
```   
Swift
```
// init url
IndustryLinkSDK.host = <#your_app_host#>

// IndustryLinkSDK
IndustryLinkSDK.initialize(withAppKey: <#your_app_key#>, 
                            appSecret: <#your_app_secret_key#>, 
                            clientId: <#your_clientId#>, 
                            clientSecret: <#your_client_secret#>)

// If need mqtt
MQTTBusinessPlugin.initializePlugin()
```

> **Note**
> In the Preparation topic, get the `AppKey`, `AppSecret`, `BundleId`, `ClientId` and `ClientSecret` for iOS. Make sure that the values are consistent with those used on the Tuya IoT Platform. Any mismatch will cause the SDK development or demo app to be failed.
> Please initialize the host using the domain names from the domain.txt file downloaded from the platform.

The requested host must be consistent with the data center of the cloud project, as the data in different data centers is isolated from one another.
```
AY: China Data Center
EU: Central Europe Data Center
AZ: Western America Data Center
WE: Western Europe Data Center
UE: Eastern America Data Center
IN: India Data Center
```

## Notes
Development version SDK is for testing purposes only, not for commercial use. To use in commercial scenarios, please purchase the formal version SDK on the platform.

**After purchasing the formal version SDK:**
1. You need to rebuild and download the formal version SDK on the IoT platform.
2. Reintegrate the formal version SDK into your project.

## Issue Feedback

You can provide feedback on your issue via **GitHub Issue** or [Ticket](https://service.console.tuya.com).

## License

Tuya Industry App SDK Sample is available under the MIT license. Please see the [LICENSE](LICENSE) file for more info.

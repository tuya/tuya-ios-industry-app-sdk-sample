# Tuya IoT App SDK iOS Sample

## Functional Overview

Tuya IoT App SDK is an important part of the Tuya SaaS Development Framework product series. This sample provides examples of basic functions such as device network configuration, login and registration, and asset management of Tuya Open API.

IoT App SDK Sample has the following functions:

- User module (login, logout)
- Asset module (asset query, selection)
- Equipment distribution module (AP, QRcode mode)
- Equipment module (equipment query, equipment unbinding)

## API Reference Docs

iOS IoT App SDK API Reference: https://tuya.github.io/tuya-ios-iot-app-sdk-sample/

## Quick Start

1. The Tuya IoT App SDK is distributed through [CocoaPods](http://cocoapods.org/) and other dependencies in this sample. Make sure that you have installed CocoaPods. If not, run the following command to install CocoaPods first:

```bash
sudo gem install cocoapods
pod setup
```

2. Clone or download this sample, change the directory to the one that includes **Podfile**, and then run the following command:

```bash
pod install
```

3. This sample requires you to have a pair of keys from the [Tuya IoT Platform](https://developer.tuya.com/), and register a developer account if you don't have one. Then, perform the following steps:

   1. Log in to Tuya Smart [IoT Platform](https://iot.tuya.com/cloud/) and verify your account with enterprise authentication.
   2. Create **Industry Solutions** type project.
   3. On the **Projects** page, click **Create**.
      ![Create Project](https://images.tuyacn.com/app/iotappsample/en/cr_product_new.png)
   4. On the **Create Project** page, configure **Project Name**, **Project Type**, **Description** and **Industry**.

   > **Description:** Select **Industry Solutions** in **Industry Type** . That is, based on assets and user systems, build IoT SaaS projects in any industry scenario. Multiple applications can be created under industry projects to share the same assets and user resources.

   5. Click **OK** to complete the project creation.

4. Create an application.

   1. In the **Projects**>**My Project** area, click the target project.
   2. In the top navigation bar, click **Applications**>**App**.
      ![image.png](https://images.tuyacn.com/app/iotappsample/en/cr_app_new.png)
   3. In the **Add Application** window, configure the application information. Select the iOS application type. Please make sure the bundle identifier is the same as your created Xcode project.
      ![image.png](https://images.tuyacn.com/fe-static/docs/img/a17b897e-4db2-4b1a-8097-d49f6eb74f34.png)

5. Create users.

   1. In the **Projects**>**My Project** area, click the target project.
   2. In the top navigation bar, click **Users**.
      ![image.png](https://images.tuyacn.com/app/iotappsample/en/cr_user_new.png)
   3. Click **Add User**.
   4. In the **Add User** window, enter the user account and password, and click **OK**.

6. Create assets.

   1. In the **Projects**>**My Project** area, click the target project.
   2. In the top navigation bar, click **Assets**.
      ![image.png](https://images.tuyacn.com/app/iotappsample/en/addAsset.png)
   3. Click **New Asset**.
   4. In the **New Asset** window, enter the asset name and click **OK**.

7. Asset authorized users.

   1. In the **Projects**>**My Project** area, click the target project.
   2. In the top navigation bar, click **Assets**.
      ![image.png](https://images.tuyacn.com/app/iotappsample/en/cr_auth_new.png)
   3. Click **Manage** under the **Operation** column of the target project.
   4. On the **Authorized User** tab, click **Add Authorization**.
   5. In the **Add Authorized User** window, add the account information to be authorized, and click **OK**.
   
8. API Products Subscription

   **1.** Go to **Projects** > **API Products** > **All Products**, click **Industry Project**, and subscribe to your desired API products.
	![image.png](https://images.tuyacn.com/app/Hanh/APIproducts.png)
	
	**You need to subscribe to these API Products to use this sample.**
	
	![image.png](https://images.tuyacn.com/app/hass/open_api_products.jpg)
	
	**2.** Go to **Projects** > **API Products** > **Subscribed Products**. Click one of the API products to subscribe.
	
	![image.png](https://images.tuyacn.com/app/Hanh/buyapi.png)
	
	**3.** Click **Project** > **New Authorization** to authorize your project to use this API.
	![image.png](https://images.tuyacn.com/app/Hanh/tip.png)
	![image.png](https://images.tuyacn.com/app/Hanh/newauthorization.png)
	![image.png](https://images.tuyacn.com/app/Hanh/apiproductauthorization.png)

9. Obtain the Client ID and Client Secret of the created iOS application on the **Applications**>**App**.
   <img src="https://images.tuyacn.com/app/hass/ios_keys_intro.png" style="zoom:50%;" />
10. Open the `TuyaIoTAppSDKSample-iOS-Swift.xcworkspace` pod generated for you.

11. Fill in the AppKey and AppSecret in the **AppKey.swift** file.

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
<img src="https://images.tuyacn.com/app/IoTAppSDK/android_home.png" width="30%" /> 

### Swich Asset

<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_switchAsset.png" width="30%" /> 

### Device Network Pairing

<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_ap.png" width="30%" /> 
<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_qrMode.png" width="30%" /> 
<img src="https://images.tuyacn.com/app/IoTAppSDK/android_nb_device.png" width="30%" /> 
<img src="https://images.tuyacn.com/app/IoTAppSDK/android_wired.png" width="30%" /> 

### Device List and Details

<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_deviceList.png" width="30%" /> 
<img src="https://images.tuyacn.com/app/IoTAppSDK/ios_iot_sdk_deviceDetail2.png" width="30%" /> 

## Issue Feedback

You can provide feedback on your issue via **GitHub Issue** or [Ticket](https://service.console.tuya.com).

## License

Tuya iOS IoT App SDK Sample is available under the MIT license. Please see the [LICENSE](LICENSE) file for more info.

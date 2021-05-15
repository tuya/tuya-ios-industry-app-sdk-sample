# Tuya iOS Device Manager App

## Features Overview

Tuya iOS Device Manager App is developed using iOS IoT App SDK. This App provides several basic features such as device pairing, asset management, and device management of Tuya Open API. Here are the feature details:

- User module (login, logout)

- Asset management module (asset query, selection)

- Device pairing module (AP mode, QR code mode)

- Device Management module (equipment query)

## Quick Start

1. This App requires you to have a developer account, which you can register it in [Tuya IoT Platform](https://developer.tuya.com/). Then, perform the following steps:

   **1.** Log in to Tuya Smart [IoT Platform](https://iot.tuya.com/cloud/) and verify your account with enterprise authentication.
   
   **2.** Create **Industry Solutions** type project.
   
   **3.** On the **Projects** page, click **Create**.

   ![Create Project](https://images.tuyacn.com/app/iotappsample/en/cr_product_new.png)

   **4.** On the **Create Project** page, configure **Project Name**, **Project Type**, **Description** and **Industry**.

      > **Description:** Select **Industry Solutions** *in* **Industry Type**. That is, based on assets and user systems, build IoT SaaS projects in any industry scenario. Multiple applications can be created under industry projects to share the same assets and user resources.

   **5.** Click **OK** to complete the project creation.

2. Create an application.

   **1.** In the **Projects** > **My Project** area, click the target project.
   
   **2.** In the top navigation bar, click **Applications** > **App**.

   ![image.png](https://images.tuyacn.com/app/iotappsample/en/cr_app_new.png)

   **3.** In the **Add Application** window, configure the application information. Select the **Tuya Device Manager (iOS)** type. The **Bundle Identifier** field is fixed.

   ![ios](https://images.tuyacn.com/app/IoTAppSDK/add_ios_application.png)

3. Create users.

     1. In the **Projects** > **My Project** area, click the target project.

     2. In the top navigation bar, click **Users**.   

        ![image.png](https://images.tuyacn.com/app/iotappsample/en/cr_user_new.png)

     3. Click **Add User**.

     4. In the **Add User** window, enter the user account and password, and click **OK**.

4. Create assets.

   1. In the **Projects** > **My Project** area, click the target project.

   2. In the top navigation bar, click **Assets**.

      ![image.png](https://images.tuyacn.com/app/iotappsample/en/addAsset.png)

   3. Click **New Asset**.

   4. In the **New Asset** window, enter the asset name and click **OK**.

5. Asset authorized users.
   1.  In the **Projects** > **My Project** area, click the target project.
   2.  In the top navigation bar, click **Assets**.   ![image.png](https://images.tuyacn.com/app/iotappsample/en/cr_auth_new.png)
   3. Click **Manage** under the **Operation** column of the target project.
   4. On the **Authorized User** tab, click **Add Authorization**.
   5. In the **Add Authorized User** window, add the account information to be authorized, and click **OK**.

6. API Products Subscription

   **1.** Go to **Projects**  >  **API Products** > **All Products**, click **Industry Project**, and subscribe to your desired API products.

   ![image.png](https://images.tuyacn.com/app/Hanh/APIproducts.png)

   **You need to subscribe to these API Products to use this sample.**

   ![image.png](https://images.tuyacn.com/app/hass/open_api_products.jpg)

   **2.** Go to **Projects** > **API Products** >  **Subscribed Products**. Click one of the API products to subscribe.    
   
   ![image.png](https://images.tuyacn.com/app/Hanh/buyapi.png)

   **3.** Click **Project** > **New Authorization** to authorize your project to use this API.

   ![image.png](https://images.tuyacn.com/app/Hanh/tip.png)

   ![image.png](https://images.tuyacn.com/app/Hanh/newauthorization.png)

   ![image.png](https://images.tuyacn.com/app/Hanh/apiproductauthorization.png)

7. Mouse on **Try Tuya Device Manager App** on the right side of the application, build and run the iOS Device Manager App to your iOS mobile device. Use the app to scan the QR code to set the **Access ID** and **Access Secret**.

  ![qrCode](https://images.tuyacn.com/app/IoTAppSDK/qr_code.png)

8. Login using the user account which is created in step **3**.

## DeviceManager App Features Overview

### Account Login

<img src="https://images.tuyacn.com/app/IoTAppSDK/login_ios.png" width="35%" /> 

### Scan QR Code to Configure Authorization Keys

<img src="https://images.tuyacn.com/app/IoTAppSDK/scan_code_ios.png" width="35%" /> 
  
### Home Page

<img src="https://images.tuyacn.com/app/IoTAppSDK/homepage_ios.png" width="35%" /> 

### Asset Managerment

<img src="https://images.tuyacn.com/app/IoTAppSDK/asset_selection_ios.png" width="35%" /> 

### Device Pairing

<img src="https://images.tuyacn.com/app/IoTAppSDK/set_wifi_ios.png" width="35%" /> 

<img src="https://images.tuyacn.com/app/IoTAppSDK/qr_code_ios.png" width="35%" /> 

<img src="https://images.tuyacn.com/app/IoTAppSDK/adding_device_ios.png" width="35%" /> 

### Device List

<img src="https://images.tuyacn.com/app/IoTAppSDK/device_list_ios.png" width="35%" /> 

## Issue Feedback

You can provide feedbacks via **GitHub Issue**.

## License

Tuya iOS Device Manager App is available under the MIT license. Please see the [LICENSE](LICENSE) file for more info.
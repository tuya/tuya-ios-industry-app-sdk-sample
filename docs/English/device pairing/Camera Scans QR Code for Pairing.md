## Initialize IActivator

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `mode` | `ActivatorMode` | Yes | The pairing mode. |

**Example**

```
self.pair = ActivatorService.shared.activator(.QRCode)
```

## Get a pairing token

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `assetId` | `String` | Yes | The ID of the specified asset. |
| `longitude` | `String` | No | The longitude. |
| `latitude` | `String` | No | The latitude. |
| `success` | `((String)->(Void))?` | No | The success callback. |
| `failure` | `((Error)->(Void))?` | No | The failure callback. |

**Example**

```
// Get the asset activation token.
ActivatorService.shared.activatorToken(assetId: "123456", longitude: "30.1234", latitude: "120.5678", success: { token in
    // The success callback. 
    print("The activation token: \(token)")
}, failure: { error in
    // The failure callback.
    print("Failed to get the activation token, with an error: \(error.localizedDescription)")
})
```

## Generate a QR code

**`QRCodeDataForQRCodeActivatorMode` parameters**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| ssid | String | Yes | The SSID of the target Wi-Fi access point. |
| password | String | Yes | The password of the target Wi-Fi access point. |
| pairingToken | String | Yes | The token for device pairing. |

**Example**

```
self.qrCodeData = ActivatorService.shared.QRCodeDataForQRCodeActivatorMode(ssid: self.ssid, password: self.password, pairToken: self.pairingToken)

if let filter = CIFilter(name: "CIQRCodeGenerator") {
    filter.setValue(self.qrCodeData, forKey: "inputMessage")
    
    if let output = filter.outputImage {
        let scale = 300 / output.extent.size.width
        let qrImage = output.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        self.qrCodeImage.image = UIImage(ciImage: qrImage)
    }
}
```

## Register `IActivatorListener` to listen for pairing result

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `deviceModel` | `IActivatedDevice?` | Yes | If the operation is successful, it indicates the information about the activated device. Otherwise, it is `nil`. |
| `params` | `ActivatorParams?` | Yes | The parameters of actions. |

**Callbacks**

| Function name | Parameters | Description |
| --- | --- | --- |
| `onSuccess` | `deviceModel: IActivatedDevice?, params: ActivatorParams?` | The success callback, returning the information about the activated device. |
| `onError` | `error: Error, params: ActivatorParams?` | The failure callback, returning an error message. |

**Example**

```
private func start() {
    pair.listener = self    
}

extension ViewController: IActivatorListener {
    func onSuccess(deviceModel: IActivatedDevice?, params: ActivatorParams?) {
        SVProgressHUD.dismiss()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onError(error: Error, params: ActivatorParams?) {
        SVProgressHUD.dismiss()
        SVProgressHUD.showInfo(withStatus: error.localizedDescription)
    }
}
```

## Start pairing

This method initiates device pairing.

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `params` | `ActivatorParams` | Yes | The parameters of the pairing action. See the example. |

**Example**

```swift
// Create QRCodeActivatorParams instance
let params = QRCodeActivatorParams(ssid: "my_wifi_ssid", password: "my_wifi_password", pairToken: "my_pair_token")

// Start device pairing. pair is generated in the initialization step.
// self.pair = ActivatorService.shared.activator(.QRCode)
pair.startPair(params)
```

## Stop pairing

**Example**

```
// Stop device pairing. pair is generated in the initialization step.
// self.pair = ActivatorService.shared.activator(.QRCode)
pair.stopPair()
```

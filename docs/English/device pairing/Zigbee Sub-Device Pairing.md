## Initialize IActivator

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `mode` | `ActivatorMode` | Yes | The pairing mode. |

**Example**

```
self.pair = ActivatorService.shared.activator(.zigbeeSubDevice)
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

extension TableViewController: IActivatorListener {
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
| `gwId` | `String` | Yes | The ID of the gateway, which is the `device.deviceId`. |
| `localKey` | `String` | Yes | The key for local communication. |
| `pv` | `Double` | Yes | The protocol version, which is the `device.pv` of the gateway. |

**Example**

```swift
// Create ZigbeeSubDeviceActivatorParams instance
let params = ZigbeeSubDeviceActivatorParams(gwId: "my_gwId", localKey: "my_local_key", pv: "my_pv")

// Start device pairing. pair is generated in the initialization step.
// self.pair = ActivatorService.shared.activator(.zigbeeSubDevice)
pair.startPair(params)
```

## Stop pairing

**Example**

```
// Stop device pairing. pair is generated in the initialization step.
// self.pair = ActivatorService.shared.activator(.zigbeeSubDevice)
pair.stopPair()
```

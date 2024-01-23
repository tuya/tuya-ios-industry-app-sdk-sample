## Initialize IActivator

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `mode` | `ActivatorMode` | Yes | The pairing mode. |

**Example**

```
self.pair = ActivatorService.shared.activator(.BLE)
```

## Initialize device scanning`IDiscoveryService`

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `mode` | `DiscoveryMode` | Yes | The scanning mode. |

**Example**

```
self.discovery = DiscoveryService.shared.discovery(.BLE)
```

## Register `IDiscoveryListener` to listen for scanning result

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `device` | `AnyObject` | Yes | The discovered device object. If the device is Bluetooth Low Energy (LE), the object is `TYBLEAdvModel`. |

**Example**

```
private func start() {
    discovery.listener = self    
}

extension BluetoothModeViewController: IDiscoveryListener {
    func didDiscover(device: AnyObject) {
        guard let model = device as? TYBLEAdvModel, let uuid = model.uuid else {return}
        self.deviceInfos[uuid] = model
        self.tableView.reloadData()
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

## Start scanning

This method initiates device scanning.

**Parameter description**

This method has no parameters.

**Example**

```swift
self.discovery.startDiscovery()
```

## Stop scanning

**Example**

```
// Stop device scanning. discovery is generated in the initialization step.
// self.discovery = DiscoveryService.shared.discovery(.BLE)
discovery.stopDiscovery()
```

## Start pairing

This method initiates device pairing.

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `params` | `ActivatorParams` | Yes | The parameters of the pairing action. See the example. |
| deviceInfo | `DeviceInfo` | Yes | Device information, an array that stores the `TYBLEAdvModel` object. |
| assetId | `String` | Yes | The asset ID. |

**Example**

```swift
// Create BLEActivatorParams instance
let params = BLEActivatorParams(deviceInfo: devInfo, assetId: assetID)

// Start device pairing. pair is generated in the initialization step.
// self.pair = ActivatorService.shared.activator(.BLE)
pair.startPair(params)
```

## Stop pairing

**Example**

```
// Stop device pairing. pair is generated in the initialization step.
// self.pair = ActivatorService.shared.activator(.BLE)
pair.stopPair()
```

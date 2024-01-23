## IMQTTService

The MQTT service protocol defines the basic operations of the MQTT service.

**Methods**

- `connect()`: Connect to the MQTT service.
- `disconnect()`: Disconnect from the MQTT service.
- `subscribe(_ topic: String, success: (()->Void)?, failure: ((Error)->Void)?)`: Subscribe to a specific topic.
- `unsubscribe(_ topic: String, success: (()->Void)?, failure: ((Error)->Void)?)`: Unsubscribe from a specific topic.

**Description**

### `connect()`

Connect to the MQTT service. This method has no parameters.

### `disconnect()`

Disconnect from the MQTT service. This method has no parameters.

### Subscribe to a topic

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| topic | String | Yes | The topic to subscribe to. |
| success | (() -> Void)? | No | The success callback. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
MQTTService.shared.subscribe("topic", success: {
    print("Subscription succeeded")
}, failure: { error in
    print("Subscription failed: \(error.localizedDescription)")
})
```

### Unsubscribe from a topic

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| topic | String | Yes | The topic to unsubscribe from. |
| success | (() -> Void)? | No | The success callback. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
MQTTService.shared.unsubscribe("topic", success: {
    print("Unsubscription succeeded")
}, failure: { error in
    print("Unsubscription failed: \(error.localizedDescription)")
})
```

## Initialize device

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| deviceId | NSString | Yes | The ID of the device to be queried. |

**`Device` object**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| deviceId | String? | No | The device ID. |
| uuid | String? | No | The universally unique identifier (UUID) of the device. |
| name | String? | No | The name of the device. |
| icon | String? | No | The device icon. |
| productId | String? | No | The product ID. |
| category | String? | No | The device category. |
| timezoneId | String? | No | The ID of the device's time zone. |
| isCloudOnline | Bool | No | Indicates whether the device is online over the internet. |
| isLocalOnline | Bool | No | Indicates whether the device is online over the local network. |
| isOnline | Bool | No | Indicates whether the device is online. |
| latitude | String? | No | The latitude of the device. |
| longitude | String? | No | The longitude of the device. |
| dps | [String : Any]? | No | The data point (DP). |
| schemas | [String : IndustryDeviceKit.DpSchema]? | No | The DP schema. |
| deviceType | IndustryDeviceKit.DeviceType | No | Device type |
| localKey | String? | No | The device's local key. |
| pv | Double | No | The version of the device protocol. |
| wifiBackup | IndustryDeviceKit.IDeviceBackupNet | No | The alternative Wi-Fi network. |
| ota | IndustryDeviceKit.IDeviceOTA | No | Device OTA update. |
| delegate | IndustryDeviceKit.IDeviceDelegate? | No | The delegate of the device. |

**Example**

```
let device = DeviceService.shared.device(withDeviceId: "123456")
```

## Get device details

Load the device object by device ID.

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| deviceId | String | Yes | The ID of the device to be loaded. |
| success | ((IndustryDeviceKit.IDevice) -> Void)? | No | The success callback. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
DeviceService.shared.load("123456", success: { device in
    // The success callback.
}, failure: { error in
    // The failure callback.
})
```

## Rename a device

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| deviceId | String | Yes | The ID of the target device. |
| newName | String | Yes | The new name of the device. |
| success | (() -> Void)? | No | The success callback. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
DeviceService.shared.rename("123456", newName: "New Device Name", success: {
    // The success callback.
}, failure: { error in
    // The failure callback.
})
```

## Remove a device

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| deviceId | String | Yes | The ID of the target device. |
| success | (() -> Void)? | No | The success callback. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
DeviceService.shared.remove("123456", success: {
    // The success callback.
}, failure: { error in
    // The failure callback.
})
```

## Factory reset

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| deviceId | String | Yes | The device ID. |
| success | (() -> Void)? | No | The success callback. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
// Call resetFactory
DeviceService.shared.resetFactory("your_device_id", success: {
    print("Factory reset succeeded")
}) { (error) in
    print("Factory reset failed: \(error.localizedDescription)")
}
```

## IDeviceDelegate

Listen for device status.

### Optional methods

#### deviceInfoUpdated

Device information update callback

```swift
@objc optional func deviceInfoUpdated(device: IndustryDeviceKit.IDevice)
```

| Parameter | Type | Description |
| --- | --- | --- |
| device | IndustryDeviceKit.IDevice | The device object. |

#### deviceDpsUpdated

Device data update callback

```swift
@objc optional func deviceDpsUpdated(device: IndustryDeviceKit.IDevice)
```

| Parameter | Type | Description |
| --- | --- | --- |
| device | IndustryDeviceKit.IDevice | The device object. |

#### deviceRemoved

Device removal callback

```swift
@objc optional func deviceRemoved(device: IndustryDeviceKit.IDevice)
```

| Parameter | Type | Description |
| --- | --- | --- |
| device | IndustryDeviceKit.IDevice | The device object. |

#### device(_:signalStrength:)

Device signal strength callback

```swift
@objc optional func device(_ device: IndustryDeviceKit.IDevice, signalStrength: String)
```

| Parameter | Type | Description |
| --- | --- | --- |
| device | IndustryDeviceKit.IDevice | The device object. |
| signalStrength | String | The signal strength of the device. |

#### device(_:otaStatusChanged:)

OTA status update callback

```swift
@objc optional func device(_ device: IndustryDeviceKit.IDevice, otaStatusChanged: String)
```

| Parameter | Type | Description |
| --- | --- | --- |
| device | IndustryDeviceKit.IDevice | The device object. |
| otaStatusChanged | String | The OTA status change. |

## OTA update

### Method

#### Get the update information

```swift
// Call checkFirmwareUpgrade 
industryOTAService.checkFirmwareUpgrade(success: { (firmwareUpgradeModels) in
    if firmwareUpgradeModels.count > 0 {
        print("A firmware update is available")
        for firmwareUpgradeModel in firmwareUpgradeModels {
            print("- \(firmwareUpgradeModel.version)")
        }
    } else {
        print("No firmware update is available")
    }
}) { (error) in
    print("Check for update failed: \(error.localizedDescription)")
}
```

| Parameter | Type | Description |
| --- | --- | --- |
| success | (([IndustryDeviceKit.IFirmwareUpgradeModel]) -> Void)? | The success callback, returning the update information. |
| failure | ((Error) -> Void)? | The failure callback. |


#### Start update

```swift
industryOTAService.startFirmwareUpgrade(firmwares)
```

| Parameter | Type | Description |
| --- | --- | --- |
| firmwares | [IndustryDeviceKit.IFirmwareUpgradeModel] | The update information. |

#### Continue with update

```swift
industryOTAService.confirmWarningUpgradeTask(true)
```

| Parameter | Type | Description |
| --- | --- | --- |
| isContinue | Bool | Indicates whether to continue with the update. |

#### Cancel update

```swift
// Define the success and failure callbacks.
let onSuccess = {
    print("The update is canceled")
}

let onFailure = { (error: Error) in
    print("Failed to cancel the update: \(error.localizedDescription)")
}

// Call cancelFirmwareUpgrade 
industryOTAService.cancelFirmwareUpgrade(success: onSuccess, failure: onFailure)
```

| Parameter | Type | Description |
| --- | --- | --- |
| success | (() -> Void)? | The success callback. |
| failure | ((Error) -> Void)? | The failure callback. |

#### Get update status

```swift
// Define the success and failure callbacks.
let onSuccess = { (statusModel: IndustryDeviceKit.IFirmwareUpgradeStatusModel) in
    print("The update status: \(statusModel.status)")
}

let onFailure = { (error: Error) in
    print("Failed to get the update status: \(error.localizedDescription)")
}

// Call getFirmwareUpgradingStatus
industryOTAService.getFirmwareUpgradingStatus(success: onSuccess, failure: onFailure)
```

| Parameter | Type | Description |
| --- | --- | --- |
| success | ((IndustryDeviceKit.IFirmwareUpgradeStatusModel) -> Void)? | The success callback, returning the update status. |
| failure | ((Error) -> Void)? | The failure callback. |

#### Get the device's local firmware information

```swift
// Define the success and failure callbacks.
let onSuccess = { (firmwareModels: [IndustryDeviceKit.IFirmwareUpgradeModel]) in
    for firmwareModel in firmwareModels {
        print("Firmware version: \(firmwareModel.version), Firmware path: \(firmwareModel.path)")
    }
}

let onFailure = { (error: Error) in
    print("Failed to get the local firmware information: \(error.localizedDescription)")
}

// Call getDeviceLocalFirmwareInfo
industryOTAService.getDeviceLocalFirmwareInfo(success: onSuccess, failure: onFailure)
```

| Parameter | Type | Description |
| --- | --- | --- |
| success | (([IndustryDeviceKit.IFirmwareUpgradeModel]) -> Void)? | The success callback, returning the local firmware version. |
| failure | ((Error) -> Void)? | The failure callback. |

## Device control

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `dps` | `IndustryDeviceKit.DpCommand` | Yes | The DP command. |
| `success` | `(() -> Void)?` | No | The success callback. |
| `failure` | `((Error) -> Void)?` | No | The failure callback. |

**Example**

```swift
// Define the DP command.
let dps = IndustryDeviceKit.DpCommand()

// Define the success and failure callbacks.
let onSuccess = {
    print("The DP command is sent successfully")
}

let onFailure = { (error: Error) in
    print("Failed to send the DP command: \(error.localizedDescription)")
}

// Call publish 
device.publish(dps: dps, success: onSuccess, failure: onFailure)
```

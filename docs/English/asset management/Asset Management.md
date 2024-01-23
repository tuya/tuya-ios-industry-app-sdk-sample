## Add asset

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| name | String | Yes | The name of the asset. |
| parentAssetId | String | No | The ID of the parent asset. |
| success | (() -> Void)? | No | The success callback. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
AssetService.shared.create(name: text, parentAssetId: self.assetId) {
    print("Success")
    self.requestAssetList()
} failure: { error in
    print("Failure: \(error.localizedDescription)")
}
```

## Rename asset

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| assetId | String | Yes | The ID of the target asset. |
| name | String | Yes | The new name of the asset. |
| success | (() -> Void)? | No | The success callback. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
AssetService.shared.update(assetId: asset.assetId, name: text) {
	print("Success")
    self.requestAssetList()
} failure: { error in
    print("Failure: \(error.localizedDescription)")
}
```

## Delete asset

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| assetId | String | Yes | The ID of the target asset. |
| success | (() -> Void)? | No | The success callback. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
AssetService.shared.remove(assetId: assetId) {
    print("Success")
} failure: { error in
    print("Failure: \(error.localizedDescription)")
}
```

## Get the property of a single asset

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| assetId | String | Yes | The ID of the target asset. |
| success | ((IAsset) -> Void)? | No | The success callback, returning the queried asset instance. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
AssetService.shared.asset(assetId: "123", success: { asset in
    print("The name of the asset: \(asset.name)")
}, failure: { error in
    print("Failure: \(error.localizedDescription)")
})
```

## Get the list of sub-asset properties

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| assetId | String? | No | The ID of the asset to be queried. If the value is `nil`, all sub-assets will be queried. |
| success | ((IAsset) -> Void)?[] | No | The success callback, returning an array of the queried sub-asset instance. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
AssetService.shared.subAssets(assetId: "123", success: { assets in
    print("The number of the sub-assets: \(assets.count)")
}, failure: { error in
    print("Failure: \(error.localizedDescription)")
})
```

## Query device list by asset ID

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| assetId | String | Yes | The ID of the target asset. |
| lastRowKey | String? | No | The `RowKey` of the last row returned from the previous query, used for pagination. |
| success | ((IAssetDeviceListResult) -> Void)? | No | The success callback, returning the list of devices. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
AssetService.shared.devices(assetId: "123", lastRowKey: nil, success: { result in
    print("The number of devices: \(result.devices.count)")
    if let nextRowKey = result.nextRowKey {
        print("The lastRowKey of the next page data: \(nextRowKey)")
    }
}, failure: { error in
    print("Failure: \(error.localizedDescription)")
})
```

## Get the management instance of a single asset

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| assetId | String | Yes | The ID of the target asset. |
| success | ((IAssociatedModel) -> Void)? | No | The success callback, returning the queried associated model. |
| failure | ((Error) -> Void)? | No | The failure callback. |

**Example**

```swift
AssetService.shared.associatedModel(assetId: "123", success: { model in
    print("The associated models: \(model)")
}, failure: { error in
    print("Failure: \(error.localizedDescription)")
})
```

## IActivator初始化

**参数说明**

| 参数名 | 类型 | 是否必填 | 说明 |
| --- | --- | --- | --- |
| `mode` | `ActivatorMode` | 是 | 配网模式 |

**代码示例**

```
self.pair = ActivatorService.shared.activator(.zigbeeSubDevice)
```

## 注册IActivatorListener监听配网结果

**参数说明**

| 参数名 | 类型 | 是否必填 | 说明 |
| --- | --- | --- | --- |
| `deviceModel` | `IActivatedDevice?` | 是 | 若操作成功，表示被激活的设备信息，否则为 `nil` |
| `params` | `ActivatorParams?` | 是 | 操作相关的参数信息 |

**回调函数说明**

| 函数名 | 参数 | 说明 |
| --- | --- | --- |
| `onSuccess` | `deviceModel: IActivatedDevice?, params: ActivatorParams?` | 操作成功回调函数，返回被激活的设备信息 |
| `onError` | `error: Error, params: ActivatorParams?` | 操作失败回调函数，返回错误信息 |

**代码示例**

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

## 开始配网

该方法用于开始设备配对操作。

**参数说明**

| 参数名 | 类型 | 是否必填 | 说明 |
| --- | --- | --- | --- |
| `params` | `ActivatorParams` | 是 | 配对操作相关的参数信息，见示例代码 |
| `gwId` | `String` | 是 | 网关设备的 ID, 即网关设备的device.deviceId。 |
| `localKey` | `String` | 是 | 用于本地通信的密钥。 |
| `pv` | `Double` | 是 | 协议版本号, 即网关设备的device.pv。 |

**代码示例**

```swift
// 创建 ZigbeeSubDeviceActivatorParams 实例
let params = ZigbeeSubDeviceActivatorParams(gwId: "my_gwId", localKey: "my_local_key", pv: "my_pv")

// 开始设备配对操作,pair是在上一步的初始化生成的
// self.pair = ActivatorService.shared.activator(.zigbeeSubDevice)
pair.startPair(params)
```

## 停止方法

**代码示例**

```
// 停止设备配对操作,pair是在上一步的初始化生成的
// self.pair = ActivatorService.shared.activator(.zigbeeSubDevice)
pair.stopPair()
```
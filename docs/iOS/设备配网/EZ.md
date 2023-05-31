## IActivator初始化

**参数说明**

| 参数名 | 类型 | 是否必填 | 说明 |
| --- | --- | --- | --- |
| `mode` | `ActivatorMode` | 是 | 配网模式 |

**代码示例**

```
self.pair = ActivatorService.shared.activator(.EZ)
```

## 获取配网token

**参数说明**

| 参数名 | 类型 | 是否必填 | 说明 |
| --- | --- | --- | --- |
| `assetId` | `String` | 是 | 指定的资产 ID |
| `longitude` | `String` | 否 | 经度信息 |
| `latitude` | `String` | 否 | 纬度信息 |
| `success` | `((String)->(Void))?` | 否 | 成功回调函数 |
| `failure` | `((Error)->(Void))?` | 否 | 失败回调函数 |

**代码示例**

```
// 获取资产激活令牌
ActivatorService.shared.activatorToken(assetId: "123456", longitude: "30.1234", latitude: "120.5678", success: { token in
    // 成功回调函数
    print("激活令牌为：\(token)")
}, failure: { error in
    // 失败回调函数
    print("获取激活令牌失败，错误信息为：\(error.localizedDescription)")
})
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

extension WiFiModeTableViewController: IActivatorListener {
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

**代码示例**

```swift
// 创建 EZActivatorParams 实例
let params = EZActivatorParams(ssid: "my_wifi_ssid", password: "my_wifi_password", pairToken: "my_pair_token")

// 开始设备配对操作,pair是在上一步的初始化生成的
// self.pair = ActivatorService.shared.activator(.EZ)
pair.startPair(params)
```

## 停止方法

**代码示例**

```
// 停止设备配对操作,pair是在上一步的初始化生成的
// self.pair = ActivatorService.shared.activator(.EZ)
pair.stopPair()
```
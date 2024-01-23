## Initialize IActivator

**Parameter description**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `mode` | `ActivatorMode` | Yes | The pairing mode. |

**Example**

```
self.pair = ActivatorService.shared.activator(.QRScan)
```

## Example of scanning QR code to get code

**Property description**

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| session | AVCaptureSession | No | The session object used to capture video and audio data. |
| callBack | CallBack | No | The callback to invoke when scanning is finished. |

**Description**

| Method | Parameters | Return value | Description |
| --- | --- | --- | --- |
| `addScaningVideo()` | None | None | Add the video scanning feature. |
| `metadataOutput(_:didOutput:from:)` | output: AVCaptureMetadataOutput, metadataObjects: [AVMetadataObject], connection: AVCaptureConnection | None | Process the scanned metadata. |

**Example**

```swift
typealias CallBack = (_ code : String? ) -> ()

class QRScanViewController: UIViewController {
    let session = AVCaptureSession()
    var callBack:CallBack?
    
    override func viewDidLoad() {
        self.addScaningVideo()
    }
    
    private func addScaningVideo(){
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else { return }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        }
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
        }
        
        metadataOutput.metadataObjectTypes = [.qr, .code128, .code39, .code93, .code39Mod43, .ean8, .ean13, .upce, .pdf417, .aztec]
        
        let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        
        session.startRunning()
    }
}

extension QRScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        session.stopRunning()
        
        for result in metadataObjects {
            if let code = result as? AVMetadataMachineReadableCodeObject {
                self.callBack?(code.stringValue ?? "")
            }
        }
        
        self.navigationController?.popViewController(animated: true)
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
// Create QRScanActivatorParams instance
let params = QRScanActivatorParams(code: "code_from_scan_image", assetId: "assetId", longitude: nil, latitude: nil)

// Start device pairing. pair is generated in the initialization step.
// self.pair = ActivatorService.shared.activator(.QRScan)
pair.startPair(params)
```

## Stop pairing

**Example**

```
// Stop device pairing. pair is generated in the initialization step.
// self.pair = ActivatorService.shared.activator(.QRScan)
pair.stopPair()
```

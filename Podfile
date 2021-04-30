source 'https://cdn.cocoapods.org/'
source 'https://github.com/TuyaInc/TuyaPublicSpecs.git'
source 'https://registry.code.tuya-inc.top/tuyaIOS/TYSpecs.git'
source 'https://registry.code.tuya-inc.top/tuyaIOS/TYSpecsThird.git' # 三方库源

target 'TuyaIoTAppSDKSample-iOS-Swift' do
  pod 'SVProgressHUD'
  pod 'TuyaSmartUtil', :path => '../TuyaSmartUtil/'
#  pod 'TuyaIoTAppSDK', :podspec=> '~/tuyaiotappsdk-ios/TuyaIoTAppSDK.podspec'
  pod 'TuyaIoTAppSDK', :path=> '~/tuyaiotappsdk-ios/'
#  pod 'TuyaIoTAppSDK'
end

post_install do |installer|
  `cd TuyaIoTAppSDKSample-iOS-Swift; [[ -f AppKey.swift ]] || cp AppKey.swift.default AppKey.swift;`
end


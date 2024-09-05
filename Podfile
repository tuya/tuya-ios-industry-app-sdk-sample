source 'https://cocoapods.tuya-inc.top:7799/'
source 'git@github.com:tuya/tuya-pod-specs.git'


target 'TuyaIoTAppSDKSample-iOS-Swift' do
  pod 'SVProgressHUD'
  pod 'Masonry', :modular_headers => true

  pod 'ThingSmartCryption', :path => './'
  pod 'IndustryLinkSDK', '2.3.0-indy.3'

end


post_install do |installer|
  `cd TuyaIoTAppSDKSample-iOS-Swift; [[ -f AppKey.swift ]] || cp AppKey.swift.default AppKey.swift;`
  
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "11.0"
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"

        # 请替换为您的 TeamID
        # replace to your teamid
        config.build_settings["DEVELOPMENT_TEAM"] = "your TeamID"
      end
    end
end


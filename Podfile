source 'https://cocoapods.tuya-inc.top:7799/'
source 'https://github.com/tuya/tuya-industry-pod-specs'

target 'TuyaIoTAppSDKSample-iOS-Swift' do
  pod 'SVProgressHUD'
  pod 'Masonry', :modular_headers => true

  pod 'IndustryLinkSDK', '2.0.0-beta.2'
  
end

post_install do |installer|
  `cd TuyaIoTAppSDKSample-iOS-Swift; [[ -f AppKey.swift ]] || cp AppKey.swift.default AppKey.swift;`
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # 消除文档警告
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
      # iOS 模拟器去除 arm64
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      # Xcode 14 编译问题
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end


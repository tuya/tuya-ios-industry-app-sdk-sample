source 'https://cocoapods.tuya-inc.top:7799/'
source 'https://github.com/tuya/tuya-industry-pod-specs'


target 'TuyaIoTAppSDKSample-iOS-Swift' do
  pod 'SVProgressHUD'
  pod 'Masonry', :modular_headers => true

  
  pod 'IndustryLinkSDK', '2.0.0-beta.2'

end

post_install do |installer|
  `cd TuyaIoTAppSDKSample-iOS-Swift; [[ -f AppKey.swift ]] || cp AppKey.swift.default AppKey.swift;`
end


platform :ios, '9.0'

target 'StopTechnician' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for StopTechician
  pod 'Alamofire'
  pod 'IQKeyboardManagerSwift'
  pod 'Kingfisher', '~> 4.0'
  pod 'ViewAnimator'
  pod 'HTCopyableLabel'
  pod 'Spring', :git => 'https://github.com/trongnhan68/Spring'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'SwiftyJSON'
  pod 'CollieGallery', :git => 'https://github.com/balitax/CollieGallery/'
  pod 'XLPagerTabStrip'
  pod 'KeychainAccess', '~> 3.1.0'
  pod 'ESPullToRefresh', :git => 'https://github.com/phpmaple/pull-to-refresh', :branch => 'swift-4.2'
  pod 'ActionSheetPicker-3.0'
  pod 'OneSignal'

  target 'StopTechnicianTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'StopTechnicianUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
  end

end


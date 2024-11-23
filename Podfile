project 'NewsApplication.xcodeproj'

platform :ios, '18.0'

target 'NewsApplication' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire'
  pod 'SnapKit'

  target 'NewsApplicationTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'NewsApplicationUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '18.0'
    end
  end
end

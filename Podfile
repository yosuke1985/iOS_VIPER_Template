project 'Todo.xcodeproj'
platform :ios, '14.1'

target 'Todo' do
  use_frameworks!

  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxDataSources', '~> 4.0'

  pod 'SwiftLint'
  pod 'SwiftFormat/CLI'
  
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'

  target 'TodoTests' do
    inherit! :search_paths

    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
  end

  target 'TodoUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end

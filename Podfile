project 'Todo.xcodeproj'
platform :ios, '14.1'

target 'Todo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxSwift', '6.0.0-rc.1'
  pod 'RxCocoa', '6.0.0-rc.1'

  pod 'SwiftLint'
  pod 'SwiftFormat/CLI'

  target 'TodoTests' do
    inherit! :search_paths

    pod 'RxBlocking', '6.0.0-rc.1'
    pod 'RxTest', '6.0.0-rc.1'
  end

  target 'TodoUITests' do
    # Pods for testing
  end

end

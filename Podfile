# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FitPals' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FitPals
  # Firebase (database, cloud storage, authentication)
  pod 'Firebase/Core'
  pod 'Firebase/Storage'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'
  
  # Date/Time Management
  pod 'SwiftDate', '~> 4.5.1'
  
  # Progress HUD
  pod 'PKHUD', '~> 5.0'
  
  # Networking & Parsing
  pod 'SwiftyJSON'
  pod 'Alamofire'
  
  # Map Annotations
  pod 'MapViewPlus'
  
  # Image Management
  pod 'ImagePicker'
  
  # Color Management + UI
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'TextFieldEffects'

  target 'FitPalsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FitPalsUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings.delete('CODE_SIGNING_ALLOWED')
          config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
  end

end

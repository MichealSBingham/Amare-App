# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'Amare' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Amare

 
  #pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift', '> 7.0-beta'
  pod 'GeoFire/Utils'
  pod 'Firebase/Storage'

  
 



  target 'AmareTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AmareUITests' do
    # Pods for testing
  end

end


post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.name == 'MyPOD' 
                config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'Yes'
            end
        end
    end
end

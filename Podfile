# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ReadiCloudStorage' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ReadiCloudStorage
#  pod 'iCloudDocumentSync'
  # pod 'GoogleAPIClientForREST/Drive', '~> 1.2.1'
  pod 'GoogleAPIClientForREST/Drive', '~> 2.0'
  # pod 'GoogleAPIClientForREST', '~> 2.0'
  pod 'GoogleSignIn', '~> 4.1.1'
  # pod 'GoogleSignIn', '~> 5.0.2'
  #pod 'GoogleSignIn', '~> 6.2'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Alamofire'
  # pod 'SwiftyJSON'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'NotificationBannerSwift'
  pod 'SnapKit', '~> 5.0.1'
  pod 'MarqueeLabel'
  pod 'leveldb-library', '~> 1.22'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        # Force CocoaPods targets to always build for x86_64
        config.build_settings['ARCHS[sdk=iphonesimulator*]'] = 'x86_64'
      end
    end
  end

  target 'ReadiCloudStorageTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ReadiCloudStorageUITests' do
    # Pods for testing
  end

end

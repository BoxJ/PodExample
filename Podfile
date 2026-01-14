#source 'https://jmgit.jiamiantech.com/sdk-public/ios.git'
source 'git@gitlab-ee.jiamiantech.com:zy/architecture/ios/jiamianspecs.git'
source 'https://cdn.cocoapods.org'
platform :ios, '13.0'

#use_frameworks!
#use_frameworks! :linkage => :static

target 'PodExample' do

#  pod 'JMLogxtSDK'
#  pod 'JMVoyageSDK', '1.1.3.3'
#  pod 'JMIMSDK'
#  
#  pod 'QY_iOS_SDK', '~>10.13.0'
  
  pod 'JMBoomSDK','3.0.5.1'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end

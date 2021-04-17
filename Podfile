# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Chance Upon' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'RangeSeekSlider'
   pod 'IQKeyboardManagerSwift'
   pod 'Alamofire', '~> 5.2'
   pod 'SDWebImage'
   pod 'FBSDKLoginKit'
   pod 'Socket.IO-Client-Swift'
  
   pod 'GooglePlaces', '4.1.0'
   pod "ImageSlideshow/SDWebImage"
   pod 'SVProgressHUD'

post_install do |installer_representation|
    puts "Splitting up Gooogle Framework - It's just too big to be presented in the Github :("
    Dir.chdir("Pods/GoogleMaps/Frameworks/GoogleMaps.framework/Versions/Current") do
       # Remove previous split files if any
       `rm GoogleMaps_Split_*`
       # Split current framework into smaller parts
       `split -b 30m GoogleMaps GoogleMaps_Split_`
    end
end

  # Pods for Chance Upon

end

require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name         = "react-native-multiple-image-picker"
  s.version      = package['version']
  s.homepage     = "https://github.com/thesocialstation/react-native-multiple-image-picker"
  s.summary      = "A simple native multiple image picker without all the cruft."
  s.source_files  = "*.{h,m}"

  s.platform     = :ios, "8.0"
  s.dependency 'React', '>= 0.29.0'
  s.dependency 'QBImagePickerController', '3.4.0'
end

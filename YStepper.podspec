Pod::Spec.new do |s|
  s.name                    = 'YStepper'
  s.version                 = '1.0.0'
  s.summary                 = 'Accessible and customizable shopping cart-style stepper for iOS'
  s.homepage                = 'https://github.com/yml-org/ystepper-ios'
  s.license                 = { :type => 'Apache 2.0' }
  s.authors                 = { 'Y Media Labs' => 'support@ymedialabs.com' }
  s.source                  = { :git => 'https://github.com/virginiapujols-yml/ystepper-ios.git', :tag => s.version }
  s.ios.deployment_target   = '14.0'
  s.swift_version           = '5.5'
  s.source_files            = 'Sources/YStepper/**/*'
end

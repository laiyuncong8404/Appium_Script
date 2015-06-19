# encoding: utf-8

require 'rubygems'
require 'rspec'
require 'appium_lib'
require 'net/http'
require File.expand_path (File.join('.', 'public_method.rb'))
# require_relative 'public_method'

APP_PATH = 'E:\SSC_长虹软服中心\项目文档\智能冰箱技术研究与应用\低成本WiFi模块开发（QCA4004方案）\IceBoxControl_20150608.apk'

def desired_caps
   {
      caps: {
         app:               APP_PATH,
         appActivity:      'com.iceboxcontrol.activitys.LoginActivity',
         appPackage:       'com.iceboxcontrol',
         platformName:     'android',
         platformVersion:  '4.4.4',#API:19
         #deviceName:       'emulator-5554',
         deviceName:       '274b3f06',#MI 3真机
         unicodeKeyboard:  'true',
         resetKeyboard:    'true',
         noReset:   	   'false'
         # newCommandTimeout:'60'
      },
      appium_lib: {
         sauce_username: nil, # don't run on sauce
         sauce_access_key: nil,
         wait: 10,
      }
   }
end


module TestHelpers
  include Selenium
  include Appium

  def setup
    	$driver = Appium::Driver.new(desired_caps).start_driver
    	Appium.promote_appium_methods RSpec::Core::ExampleGroup
    	@username = "13540774227"
    	@old_password = @new_password = "123456"
     	@wrong_username = "13340774227"
     	@wrong_password = @short_password = "12345"
      @new_nickname = "Lucy"
  end

  def teardown
    $driver.quit
  end
end
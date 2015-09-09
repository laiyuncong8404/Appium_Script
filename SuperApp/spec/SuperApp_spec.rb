# encoding: utf-8
=begin
#运行本脚本前，请开启appium_server；
#手机API18(4.3)及以上，手机连接WiFi路由；#手机连接电脑; 
#脚本中未做异常网络处理，因此网络需要稳定，平台连接稳定
=end
require 'rubygems'
require 'rspec'
require 'appium_lib'
# require File.join(File.dirname(__FILE__),'..', 'public_method')

# right_username = "13688406231"
# right_password = old_password = new_password = "1234567890"
# wrong_username = "13340774227"
# wrong_password = short_password = "12345"
# new_nickname = "Lucy"
# new_fridgeNewPwd = "4008111666"
# device_name = 'CHiQ_1S'
# device_sn = "CDTEST400911700407014001" #CHiQ_1S
APP_PATH = '../SuerApp9_6.apk'
def desired_caps
  {
    caps: {
      app:                APP_PATH,
      appPackage:         'com.chonghong.ssc.cookbook',
      appActivity:        'com.chonghong.superapp.activity.SplashActivity',
      appWaitActivity:    'com.chonghong.superapp.activity.main.MainActivity',
      platformName:       'android',
      platformVersion:    '4.4.4',#API:19
      deviceName:         '274b3f06',#MI 3真机
      unicodeKeyboard:    'true',
      resetKeyboard:      'true',
      noSign:             'true', #Skip checking and signing of app with debug keys
      noReset:            'false'
      # browserName:        'chrome', 
      # autoWebview:        'true',
      # newCommandTimeout:'60'
    },
    appium_lib: {
      sauce_username:     nil, # don't run on sauce
      sauce_access_key:   nil,
      wait: 10,
    }
  }
end

describe 'SuperApp' do
  before(:all) do
    @driver = Appium::Driver.new(desired_caps).start_driver
    Appium.promote_appium_methods RSpec::Core::ExampleGroup
  end
  after(:all) do
    @driver_quit
  end
  context 'Device list' do
    before(:all) do
      @devices_list = id('com.changhong.ssc.cookbook:id/devices_list')
      @health_living = id('com.changhong.ssc.cookbook:id/health_living')
      @personal_center = id('com.changhong.ssc.cookbook:id/personal_center')
    end
    # let(:devices_list) {id('com.changhong.ssc.cookbook:id/devices_list')}
    # let(:health_living) {id('com.changhong.ssc.cookbook:id/health_living')}
    # let(:personal_center) {id('com.changhong.ssc.cookbook:id/personal_center')}
    it 'personal_center click' do
      @personal_center.click
      expect(exists{text_exact('请登录')}).to be true
    end
  end
end

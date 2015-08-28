# encoding: utf-8
=begin
运行本脚本前，请开启appium_server；
手机API18(4.3)及以上，手机连接WiFi路由；#手机连接电脑; 
WiFi模块工作在STA模式
脚本中未做异常网络处理，因此网络需要稳定，平台连接稳定
=end

require 'rubygems'
require 'rspec'
require 'appium_lib'
require File.join(File.dirname(__FILE__), 'public_method')

APP_PATH = '../IceBoxControl_CHiQ1U_20150824.apk'

def desired_caps
   {
      caps: {
         app:               APP_PATH,
         appActivity:      'com.iceboxcontrol.activitys.LoginActivity',
         appPackage:       'com.iceboxcontrol',
         platformName:     'android',
         platformVersion:  '4.4.4',#API:19
         deviceName:       '274b3f06',#MI 3真机
         unicodeKeyboard:  'true',
         resetKeyboard:    'true',
         noReset:          'false'
      },
      appium_lib: {
         sauce_username: nil, # don't run on sauce
         sauce_access_key: nil,
         wait: 10,
      }
   }
end

describe 'iceboxcontrol_STA_mode' do
   before(:all) do
      @driver = Appium::Driver.new(desired_caps).start_driver
      Appium.promote_appium_methods RSpec::Core::ExampleGroup
      @username = "13540774227"
      @old_password = @new_password = "123456"
      @wrong_username = "13340774227"
      @wrong_password = @short_password = "12345"
      @new_nickname = "Lucy"
      @wrong_fridgePwd = @short_fridgeNewPwd = "12345"
      @new_fridgeNewPwd = "4008111666"
      @device_name = '成都21'
      @device_sn = "FRTEST400911700407014921"
   end
   after(:all) do
      @driver_quit
   end

   context 'after user login as STA mode' do
      before :all do
         @username_textfiled = find_element(:id, 'com.iceboxcontrol:id/login_username')
         @password_textfiled = find_element(:id, 'com.iceboxcontrol:id/login_password')
         @login_button = find_element(:id, 'com.iceboxcontrol:id/login_btn')
         @autoLogin_button = find_element(:id, 'com.iceboxcontrol:id/auto_login')
         @rememberPassword_button = find_element(:id, 'com.iceboxcontrol:id/remember_psw')
         @forgotPassword_textview = find_element(:id, 'com.iceboxcontrol:id/forgot_psw')
         @registerId_textview = find_element(:id, 'com.iceboxcontrol:id/register_id')
         @mode_textview = find_element(:id, 'android:id/text1')
      end
      after :each do
         sleep 2
      end

      it 'check the login page elements' do
         expect(@username_textfiled.displayed?).to be true
         expect(@password_textfiled.displayed?).to be true
         expect(@login_button.displayed?).to be true
         expect(@autoLogin_button.displayed?).to be true
         expect(@rememberPassword_button.displayed?).to be true
         expect(@forgotPassword_textview.displayed?).to be true
         expect(@registerId_textview.displayed?).to be true
      end
      it 'can not login as AP mode' do
         if @mode_textview.text == '远程模式'
            @mode_textview.click
            modes = find_elements(:class_name, 'android.widget.CheckedTextView')
            modes[0].click #点击‘本地模式’
         elsif @mode_textview.text == '本地模式'
         end
         @login_button.click
         expect((@mode_textview.text) == '本地模式').to be true
         expect(@login_button.displayed?).to be true
      end
      it 'confirm the work mode is STA' do
         if @mode_textview.text == '本地模式'
            @mode_textview.click
            modes = find_elements(:class_name, 'android.widget.CheckedTextView')
            modes[1].click #点击‘远程模式’
         elsif @mode_textview.text == '远程模式'
         end
         expect(@login_button.displayed?).to be true
         expect((@mode_textview.text) == '远程模式').to be true
      end
      it 'can not login with empty username and empty password' do
         login()
         expect(@login_button.displayed?).to be true
      end
      it 'can not login with empty username and no-empty password' do
         login(nil,@old_password)
         expect(@login_button.displayed?).to be true
      end
      it 'can not login with no-empty username and empty password' do
         login(@username,nil)
         expect(@login_button.displayed?).to be true
      end
      it 'can not login with wrong username and wrong password' do
         login(@wrong_username,@wrong_password)
         expect(@login_button.displayed?).to be true
      end
      it 'can not login with right username and wrong password' do
         login(@username,@wrong_password)
         expect(@login_button.displayed?).to be true
      end
      it 'can not login with wrong username and right password' do
         login(@wrong_username,@old_password)
         expect(@login_button.displayed?).to be true
      end
      it 'can be login with right username and right password' do
         login(@username,@old_password)
         sleep 5
         enter_wkzx_page()
         back_click
         expect(button('确定').displayed?).to be true
         alert_click('确定')
      end
   end
end

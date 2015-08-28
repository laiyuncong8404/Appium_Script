# encoding: utf-8
#运行本脚本前，请开启appium_server；
#手机API18(4.3)及以上，手机需连接AP一次；#手机连接电脑;

require 'rubygems'
require 'rspec'
require 'appium_lib'
require 'net/http'
require File.join(File.dirname(__FILE__),'..', 'public_method')

APP_PATH = '../../IceBoxControl_CHiQ1U_20150824_debug.apk'

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
			wait: 60,
		}
	}
end

describe 'iceboxcontrol_CHiQ1U_AP_mode_reliability' do
	before(:all) do
		@driver = Appium::Driver.new(desired_caps).start_driver
		Appium.promote_appium_methods RSpec::Core::ExampleGroup
		# @driver.set_network_connection(2) #(ConnectionType:Open Wifi only)
		@login_username = "13540774227"
		@login_password = "123456"
		@total_num = 100
	end
	after(:all) do
		@driver_quit
	end

	context 'reliability for fridge\'s AP_mode' do
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

		it 'login with the work mode is AP' do
			fail_sum = pass_sum = 0
			set_AP_mode_before_login()
			@total_num.times do
				begin
					@login_button.click
					sleep 5
					enter_wkzx_page()
					sleep 2
					if exists{id('com.iceboxcontrol:id/home')} == true #设备不在线
						fail_sum += 1
						puts "fail num is:#{fail_sum}"
					else pass_sum += 1
						puts "pass num is:#{pass_sum}"
					end
					enter_setting_page()
					id('com.iceboxcontrol:id/unlogin').click
					button('确定').click
					sleep 3
				ensure
					sleep 3
					start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
					sleep 1
				end
			end
			puts "*****************************************************************"
			Fail_Rate = (fail_sum/@total_num.to_f * 100).round(2)
			Pass_Rate = (pass_sum/@total_num.to_f * 100).round(2)
			puts "Fail total number is: #{fail_sum},the Fail Rate is: #{Fail_Rate}%"
			puts "Pass total number is: #{pass_sum},the Pass Rate is: #{Pass_Rate}%"
			puts "*****************************************************************"
		end
	end
end

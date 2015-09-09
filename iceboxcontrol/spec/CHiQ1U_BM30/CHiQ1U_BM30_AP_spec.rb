# encoding: utf-8
=begin
#运行本脚本前，请开启appium_server；
#手机API18(4.3)及以上，手机连接AP；#手机连接电脑; 
#WiFi模块工作在AP模式
#脚本中未做异常网络处理，因此网络需要稳定，平台连接稳定
=end

require 'rubygems'
require 'rspec'
require 'appium_lib'
require 'net/http'
require File.join(File.dirname(__FILE__),'..', 'public_method')

APP_PATH = '../../IceBoxControl_CHiQ1U_debug.apk'

def desired_caps
	{
		caps: {
			app:               APP_PATH,
			appActivity:      'com.iceboxcontrol.activitys.LoginActivity',
			appPackage:       'com.iceboxcontrol',
			platformName:     'android',
			platformVersion:  '4.4.4',#API:19
			deviceName:       '274b3f06',#MI 3真机
			# deviceName:       'emulator-5554',
			# platformVersion:  '5.1',#API:22
			# deviceName:       '15584d42', #MI 4真机
			unicodeKeyboard:  'true',
			resetKeyboard:    'true',
			noReset:       'false'
			# newCommandTimeout:'60'
		},
		appium_lib: {
			sauce_username: nil, # don't run on sauce
			sauce_access_key: nil,
			wait: 10,
		}
	}
end

describe 'iceboxcontrol_CHiQ1U_BM30_AP_mode' do
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
		@device_name = 'CHiQ_BM30'
		# @device_sn = "FRTEST400911700407014921" #QCA4004_WiFI
		@device_sn = "FRTEST400911700407014000" #CHiQ_1U_BM30
	end
	after(:all) do
		@driver_quit
	end

	context 'after user login as AP mode' do
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

		context 'login_page' do
			after :each do
				sleep 3
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
			it 'can not login as STA mode' do
				if @mode_textview.text == '本地模式'
					@mode_textview.click
					modes = find_elements(:class_name, 'android.widget.CheckedTextView')
					modes[1].click #点击‘远程模式’
				elsif @mode_textview.text == '远程模式'
				end
				@login_button.click
				expect((@mode_textview.text) == '远程模式').to be true
				expect(@login_button.displayed?).to be true
			end
			it 'confirm the work mode is AP' do
				if @mode_textview.text == '远程模式'
					@mode_textview.click
					modes = find_elements(:class_name, 'android.widget.CheckedTextView')
					modes[0].click #点击‘本地模式’
				elsif @mode_textview.text == '本地模式'
				end
				expect(@login_button.displayed?).to be true
				expect((@mode_textview.text) == '本地模式').to be true
			end

			it 'AP_mode can login with empty username and empty password' do
				begin
					login()
					sleep 5
					expect(@login_button.displayed?).to be false
					enter_wkzx_page()
					sleep 3
					back_click
					expect(button('确定').displayed?).to be true
					alert_click('确定')
				ensure
					start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
				end
			end
			it 'AP_mode can login with empty username and no-empty password' do
				begin
					login(nil,@old_password)
					sleep 5
					expect(@login_button.displayed?).to be false
					enter_wkzx_page()
					sleep 3
					back_click
					expect(button('确定').displayed?).to be true
					alert_click('确定')
				ensure
					start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
				end
			end
			it 'AP_mode can login with no-empty username and empty password' do
				begin
					login(@username,nil)
					sleep 5
					expect(@login_button.displayed?).to be false
					enter_wkzx_page()
					sleep 3
					back_click
					expect(button('确定').displayed?).to be true
					alert_click('确定')
				ensure
					start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
				end
			end
			it 'AP_mode can login with wrong username and wrong password' do
				begin
					login(@wrong_username,@wrong_password)
					sleep 5
					expect(@login_button.displayed?).to be false
					enter_wkzx_page()
					sleep 3
					back_click
					expect(button('确定').displayed?).to be true
					alert_click('确定')
				ensure
					start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
				end
			end
			it 'AP_mode can login with right username and wrong password' do
				begin
					login(@username,@wrong_password)
					sleep 5
					expect(@login_button.displayed?).to be false
					enter_wkzx_page()
					sleep 3
					back_click
					expect(button('确定').displayed?).to be true
					alert_click('确定')
				ensure
					start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
				end
			end
			it 'AP_mode can not login with wrong username and right password' do
				begin
					login(@wrong_username,@old_password)
					sleep 5
					expect(@login_button.displayed?).to be false
					enter_wkzx_page()
					sleep 3
					back_click
					expect(button('确定').displayed?).to be true
					alert_click('确定')
				ensure
					start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
				end
			end
			it 'AP_mode can be login with right username and right password' do
				login(@username,@old_password)
				sleep 5
				enter_wkzx_page()
				back_click
				expect(button('确定').displayed?).to be true
				alert_click('确定')
			end
			it 'AP_mode auto-login worked' do
				start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
				@username_textfiled.clear
				@username_textfiled.type @username
				@password_textfiled.clear
				@password_textfiled.type @old_password
				@autoLogin_button.click
				# @rememberPassword_button.click
				@login_button.click
				sleep 5
				enter_wkzx_page()
				sleep 3
				back_click
				expect(button('确定').displayed?).to be true
				alert_click('确定')
				start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
				sleep 5
				enter_wkzx_page()
				@handle = find_element(:id, 'com.iceboxcontrol:id/handle')
				expect(@handle.displayed?).to be true
			end
		end #login_page

		context 'WenKongZhongXin_page' do
			before :all do
				@wkzx_title = id('com.iceboxcontrol:id/wkzx_title')
				@wkzx_lcs_switch = id('com.iceboxcontrol:id/wkzx_lcs_switch')
				@wkzx_bws_switch = id('com.iceboxcontrol:id/wkzx_bws_switch')
				@wkzx_smart_switch = id('com.iceboxcontrol:id/wkzx_smart_switch')
				@wkzx_holiday_switch = id('com.iceboxcontrol:id/wkzx_holiday_switch')
				@wkzx_leco_switch = id('com.iceboxcontrol:id/wkzx_leco_switch')
				# @wkzx_foodfirst_switch = id('com.iceboxcontrol:id/wkzx_foodfirst_switch')
				@wkzx_quickcool_switch = id('com.iceboxcontrol:id/wkzx_quickcool_switch')
				@wkzx_quickcold_switch = id('com.iceboxcontrol:id/wkzx_quickcold_switch')
			end
			after :each do
				sleep 2
			end

			it 'check the wkzx page elements' do
				expect(@wkzx_title.displayed?).to be true
				expect(@wkzx_lcs_switch.displayed?).to be true
				expect(@wkzx_bws_switch.displayed?).to be true
				expect(@wkzx_smart_switch.displayed?).to be true
				expect(@wkzx_holiday_switch.displayed?).to be true
				expect(@wkzx_leco_switch.displayed?).to be true
				# expect(@wkzx_foodfirst_switch.displayed?).to be true
				expect(@wkzx_quickcool_switch.displayed?).to be true
				expect(@wkzx_quickcold_switch.displayed?).to be true
			end
			context 'lcs_OFF_mode check' do
				before :each do
					wkzx_uncheck_all_mode()
				end

				it 'lcs_OFF_mode should OFF when smart_mode ON' do
					@wkzx_smart_switch.click
					wkzx_OnProgress?()
					expect(id('com.iceboxcontrol:id/wkzx_lcs_temperature').text).to eq('5.0℃')
					expect(id('com.iceboxcontrol:id/wkzx_bws_temperature').text).to eq('0.0℃')
					expect(id('com.iceboxcontrol:id/wkzx_lds_temperature').text).to eq('-18.0℃')
					expect(@wkzx_smart_switch.attribute('checked')).to eq('true')
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('true')
					expect(@wkzx_bws_switch.attribute('checked')).to eq('true')
					@wkzx_lcs_switch.click
					exists{button('确定')}? button('确定').click : nil
					wkzx_OnProgress?()
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('false')
					expect(@wkzx_bws_switch.attribute('checked')).to eq('true')
					expect(@wkzx_smart_switch.attribute('checked')).to eq('false')
				end
				it 'lcs_OFF_mode should OFF when holiday_mode ON' do
					@wkzx_holiday_switch.click
					wkzx_OnProgress?()
					expect(id('com.iceboxcontrol:id/wkzx_lcs_temperature').text).to eq('14.0℃')
					expect(@wkzx_holiday_switch.attribute('checked')).to eq('true')
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('true')
					@wkzx_lcs_switch.click
					exists{button('确定')}? button('确定').click : nil
					wkzx_OnProgress?()
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('false')
					expect(@wkzx_holiday_switch.attribute('checked')).to eq('false')
				end
				it 'lcs_OFF_mode should OFF when quickcool_mode ON' do
					@wkzx_quickcool_switch.click
					wkzx_OnProgress?()
					sleep 3
					expect(@wkzx_quickcool_switch.attribute('checked')).to eq('true')
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('true')
					@wkzx_lcs_switch.click
					exists{button('确定')}? button('确定').click : nil
					wkzx_OnProgress?()
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('false')
					expect(@wkzx_quickcool_switch.attribute('checked')).to eq('false')
				end
			end #lcs_OFF_mode check

			context 'bws_OFF_mode check' do
				before :each do
					wkzx_uncheck_all_mode()
				end

				it 'bws_OFF_mode should OFF when smart_mode ON' do
					@wkzx_smart_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_smart_switch.attribute('checked')).to eq('true')
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('true')
					expect(@wkzx_bws_switch.attribute('checked')).to eq('true')
					@wkzx_bws_switch.click
					exists{button('确定')}? button('确定').click : nil
					wkzx_OnProgress?()
					expect(@wkzx_bws_switch.attribute('checked')).to eq('false')
					expect(@wkzx_smart_switch.attribute('checked')).to eq('false')
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('true')
				end
			end #bws_OFF_mode check

			context 'smart_mode check' do
				before :each do
					wkzx_uncheck_all_mode()
					@wkzx_smart_switch.click #Turn smart_mode ON
					wkzx_OnProgress?()
				end

				it 'smart_mode should OFF when lcs_mode OFF' do
					@wkzx_lcs_switch.click
					button('确定').click
					wkzx_OnProgress?()
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('false')
					expect(@wkzx_smart_switch.attribute('checked')).to eq('false')
				end
				it 'smart_mode should OFF when bws_mode OFF' do
					@wkzx_bws_switch.click
					button('确定').click
					wkzx_OnProgress?()
					expect(@wkzx_bws_switch.attribute('checked')).to eq('false')
					expect(@wkzx_smart_switch.attribute('checked')).to eq('false')
				end
				it 'smart_mode should OFF when quickcold_mode ON' do
					@wkzx_quickcold_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_quickcold_switch.attribute('checked')).to eq('true')
					expect(@wkzx_smart_switch.attribute('checked')).to eq('false')
				end
				it 'smart_mode should OFF when holiday_mode OFF' do
					@wkzx_holiday_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_holiday_switch.attribute('checked')).to eq('true')
					expect(@wkzx_smart_switch.attribute('checked')).to eq('false')
				end
				it 'smart_mode should OFF when quickcool_mode ON' do
					@wkzx_quickcool_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_quickcool_switch.attribute('checked')).to eq('true')
					expect(@wkzx_smart_switch.attribute('checked')).to eq('false')
				end
			end #smart_mode_check

			context 'holiday_mode_check' do
				before :each do
					wkzx_uncheck_all_mode()
					@wkzx_holiday_switch.click #Turn holiday_mode ON
					wkzx_OnProgress?()
				end

				it 'holiday_mode should OFF when lcs_mode OFF' do
					@wkzx_lcs_switch.click
					button('确定').click
					wkzx_OnProgress?()
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('false')
					expect(@wkzx_holiday_switch.attribute('checked')).to eq('false')
				end
				it 'holiday_mode can be ON when bws_mode OFF' do
					@wkzx_bws_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_bws_switch.attribute('checked')).to eq('true')
					@wkzx_bws_switch.click
					button('确定').click
					wkzx_OnProgress?()
					expect(@wkzx_holiday_switch.attribute('checked')).to eq('true')
					expect(@wkzx_bws_switch.attribute('checked')).to eq('false')
				end
				it 'holiday_mode can be ON when quickcold_mode ON' do
					@wkzx_quickcold_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_quickcold_switch.attribute('checked')).to eq('true')
					@wkzx_quickcold_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_quickcold_switch.attribute('checked')).to eq('false')
					expect(@wkzx_holiday_switch.attribute('checked')).to eq('true')
				end
				it 'holiday_mode should OFF when smart_mode ON' do
					@wkzx_smart_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_smart_switch.attribute('checked')).to eq('true')
					expect(@wkzx_holiday_switch.attribute('checked')).to eq('false')
				end
				it 'holiday_mode should OFF when quickcool_mode ON' do
					@wkzx_quickcool_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_quickcool_switch.attribute('checked')).to eq('true')
					expect(@wkzx_holiday_switch.attribute('checked')).to eq('false')
				end
			end #holiday_mode_check

			context 'quickcool_mode check' do
				before :each do
					wkzx_uncheck_all_mode()
					@wkzx_quickcool_switch.click #turn quickcool_mode ON
					wkzx_OnProgress?()
				end

				it 'quickcool_mode should OFF when lcs_mode OFF' do
					@wkzx_lcs_switch.click
					button('确定').click
					wkzx_OnProgress?()
					expect(@wkzx_lcs_switch.attribute('checked')).to eq('false')
					expect(@wkzx_quickcool_switch.attribute('checked')).to eq('false')
				end
				it 'quickcool_mode can be ON when bws_mode OFF' do
					@wkzx_bws_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_bws_switch.attribute('checked')).to eq('true')
					@wkzx_bws_switch.click
					exists{button('确定')}? button('确定').click : nil
					wkzx_OnProgress?()
					expect(@wkzx_bws_switch.attribute('checked')).to eq('false')
					expect(@wkzx_quickcool_switch.attribute('checked')).to eq('true')
				end
				it 'quickcool_mode can be ON when quickcold_mode ON' do
					@wkzx_quickcold_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_quickcold_switch.attribute('checked')).to eq('true')
					@wkzx_quickcold_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_quickcool_switch.attribute('checked')).to eq('true')
					expect(@wkzx_quickcold_switch.attribute('checked')).to eq('false')
				end
				it 'quickcool_mode should OFF when smart_mode ON' do
					@wkzx_smart_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_smart_switch.attribute('checked')).to eq('true')
					expect(@wkzx_quickcool_switch.attribute('checked')).to eq('false')
				end
				it 'quickcool_mode should OFF when holiday_mode ON' do
					@wkzx_holiday_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_holiday_switch.attribute('checked')).to eq('true')
					expect(@wkzx_quickcool_switch.attribute('checked')).to eq('false')
				end
			end #quickcool_mode_check

			context 'quickcold_mode check' do
				before :each do
					wkzx_uncheck_all_mode()
				end

				it 'quickcold_mode should OFF when smart_mode ON' do
					@wkzx_quickcold_switch.click
					wkzx_OnProgress?()
					expect(id('com.iceboxcontrol:id/wkzx_lds_temperature').text).to eq('-32.0℃')
					@wkzx_smart_switch.click
					wkzx_OnProgress?()
					expect(@wkzx_quickcold_switch.attribute('checked')).to eq('false')
					expect(@wkzx_smart_switch.attribute('checked')).to eq('true')
				end
			end #quickcold_mode check
		end #WenKongZhongXin_page

		context 'setting_page' do
			before :all do
				enter_setting_page()
				@page_title = texts_exact('设置')[0]
				@userinfo_textview = find_element(:id, 'com.iceboxcontrol:id/info')
				@userinfo_textview_text = find_element(:id, 'com.iceboxcontrol:id/infotext')
				@identify_textview = find_element(:id, 'com.iceboxcontrol:id/identify')
				@identify_textview_text = find_element(:id, 'com.iceboxcontrol:id/identifytext')
				@net_setting_textview = find_element(:id, 'com.iceboxcontrol:id/net_setting')
				@net_setting_textview_text = find_element(:id, 'com.iceboxcontrol:id/net_settingtext')
				@dev_connect_textview = find_element(:id, 'com.iceboxcontrol:id/dev_connect')
				@dev_connect_textview_text = find_element(:id, 'com.iceboxcontrol:id/dev_connecttext')
				@soft_update_textview = find_element(:id, 'com.iceboxcontrol:id/soft_update')
				@soft_update_textview_text = find_element(:id, 'com.iceboxcontrol:id/soft_updatetext')
				@telephone_textview = find_element(:id, 'com.iceboxcontrol:id/telephone')
				@unlogin_textview = find_element(:id, 'com.iceboxcontrol:id/unlogin')
				@unlogin_textview_text = find_element(:id, 'com.iceboxcontrol:id/munlogin')
			end
			after :all do
				sleep 5
			end

			it 'check the setting page elements' do
				expect(@page_title.displayed?).to be true
				expect((@page_title.text) == '设置').to be true
				expect((@userinfo_textview_text.text) == '个人信息').to be true
				expect((@identify_textview_text.text) == '冰箱密码').to be true
				expect((@net_setting_textview_text.text) == '网络设置').to be true
				expect((@dev_connect_textview_text.text) == '设备连接').to be true
				expect((@soft_update_textview_text.text) == '软件更新').to be true
				expect((@unlogin_textview_text.text) == '退出登录').to be true
			end

			it 'userinfo page can not enter' do
				enter_userinfo_page() #进入个人信息页面
				expect(exists{@unlogin_textview_text}).to be true
			end

			it 'fridgePwd page can not enter'do
				enter_fridgePwd_page()
				expect(exists{@unlogin_textview_text}).to be true
			end

			it 'device_connect page'do
				enter_device_connect_page()
				expect(exists{@net_setting_textview_text}).to be true
			end

			context 'network_setting page'do
				before :each do
					enter_net_setting_page()
					@netsetting_back = id('com.iceboxcontrol:id/netsetting_back')
					@network_setting_mode = id('com.iceboxcontrol:id/network_setting_mode')
					@fridgeNewPwd = id('com.iceboxcontrol:id/network_setting_vericode_input')
					@network_setting_remote_title = id('com.iceboxcontrol:id/network_setting_remote_title')
				end
				after :all do
					sleep 3
				end
				it 'check the net_setting page elements'do
					begin
						expect(@network_setting_mode.displayed?).to be true
						expect(@fridgeNewPwd.displayed?).to be true
						expect((@network_setting_remote_title).text == '网络设置').to be true
						expect(button('保存').displayed?).to be true
					ensure
						@netsetting_back.click #返回设置页面
					end
				end
				it 'work mode remain in AP' do
					@network_setting_mode.click
					if @mode_textview.text == '远程模式'
						@mode_textview.click
						modes = find_elements(:class_name, 'android.widget.CheckedTextView')
						modes[0].click #点击‘本地模式’
					else
						back_click
					end
					expect(button('保存').displayed?).to be true
					@netsetting_back.click #返回设置页面
				end
				context 'WiFi_setting_page' do
					before :each do
						@network_setting_mode.click
						modes = find_elements(:class_name, 'android.widget.CheckedTextView')
						modes[1].click #点击‘远程模式’
					end
					it 'check WiFi_setting_page elements'do
						@netsetting_wifi_back =id('com.iceboxcontrol:id/netsetting_wifi_back')
						@wifi_setting_button = id('com.iceboxcontrol:id/wifi_setting_button')
						@wifi_psw = id('com.iceboxcontrol:id/network_setting_vericode_remote_pwd_input')

						expect(@netsetting_wifi_back.displayed?).to be true
						expect(@wifi_setting_button.displayed?).to be true
						expect(@wifi_psw.displayed?).to be true
						expect(id('com.iceboxcontrol:id/net_setting_wifi_title').text).to include('远程模式的wifi名和密码')
						expect(exists{button('保存设置')}).to be true
						@netsetting_wifi_back.click
						@netsetting_back.click #返回设置页面
					end
				end
			end

			context 'unlogin page' do
				before :each do
					@unlogin_textview.click
				end
				after :all do
					sleep 3
				end
				it 'check unlogin page elements' do
					begin
						expect(text('确定退出登录吗！').displayed?).to be true
						expect(button('确定').displayed?).to be true
						expect(button('取消').displayed?).to be true
					ensure
						button('取消').click
					end
				end
				it 'click cancel button maintain login status' do
					button('取消').click
					expect(@unlogin_textview_text.text).to eq('退出登录')
				end
				it 'click confirm button to logout' do
					begin
						button('确定').click
						sleep 3
						start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
						expect(@autoLogin_button.attribute('checked')).to eq('false')
						expect(@rememberPassword_button.attribute('checked')).to eq('true')
					ensure
						@login_button.click
						enter_wkzx_page()
					end
				end
			end
		end #setting_page

		context 'foodmanage_page' do
			before :all do
				enter_foodmanage_page()
				@foodmanage_title = id('com.iceboxcontrol:id/foodmanage_title')
				@foodmanage_categary_list = id('com.iceboxcontrol:id/foodmanage_categary_list')
				# @foodmanage_item_icon = id('com.iceboxcontrol:id/foodmanage_item_icon')
				# @foodmanage_item_name = id('com.iceboxcontrol:id/foodmanage_item_name')
				# @foodmanage_item_weight = id('com.iceboxcontrol:id/foodmanage_item_weight')
				# @foodmanage_item_Unit = id('com.iceboxcontrol:id/foodmanage_item_Unit')
				# @foodmanage_item_remaindays = id('com.iceboxcontrol:id/foodmanage_item_remaindays')
			end
			after :all do
				sleep 3
			end
			it 'check foodmanage_page elements' do
				expect(@foodmanage_title.text).to eq('食品管理')
				expect(exists{id('com.iceboxcontrol:id/foodmanage_foodadd')}).to be false
				expect(text('名称').displayed?).to be true
				expect(text('数量/重量').displayed?).to be true
				expect(text('剩余时限').displayed?).to be true
				expect(@foodmanage_categary_list.displayed?).to be true
			end
			it 'delete all foods before add' do
				begin
					10000.times do
						if exists{id('com.iceboxcontrol:id/foodmanage_item_name')} == false
							break
						else
							food = id('com.iceboxcontrol:id/foodmanage_item_name')
							delete_food_from_categary_list = Appium::TouchAction.new.press(element:food).wait(4000).perform#.release(element:food).perform
							button('确定').click
							sleep 3
						end
					end
				ensure
					expect(exists{food}).to be false
				end
			end
		end #foodmanage_page

		context 'cookbook_page' do
			before :all do
				enter_cookbook_page()
			end
			it 'check cookbook_page elements' do
				expect(text('按推荐').displayed?).to be true
				expect(exists{id('com.iceboxcontrol:id/titleimage2')}).to be true #排序_button
				expect(exists{id('com.iceboxcontrol:id/titleimage3')}).to be false #search_button
			end
		end #cookbook_page
	end #after user login as AP mode
end #iceboxcontrol_AP_mode

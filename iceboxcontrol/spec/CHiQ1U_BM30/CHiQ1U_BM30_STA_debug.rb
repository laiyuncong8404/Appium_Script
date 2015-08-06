# encoding: utf-8

require 'rubygems'
require 'rspec'
require 'appium_lib'
require File.join(File.dirname(__FILE__),'..', 'public_method')

APP_PATH = "../../IceBoxControl_CHiQ1U_debug.apk"

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
			noReset:       'false'
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
		# @device_sn = "FRTEST400911700407014921" #QCA4004_WiFI
		@device_sn = "FRTEST400911700407014000" #CHiQ_1U
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

		it 'login with the work mode is STA' do
			if @mode_textview.text == '本地模式'
				@mode_textview.click
				modes = find_elements(:class_name, 'android.widget.CheckedTextView')
				modes[1].click #点击‘远程模式’
			elsif @mode_textview.text == '远程模式'
			end
			expect(@login_button.displayed?).to be true
			expect((@mode_textview.text) == '远程模式').to be true
			login(@username,@old_password)
			sleep 5
			enter_wkzx_page()
		end

		context 'WenKongZhongXin_page' do
			before :all do
				@wkzx_title = id('com.iceboxcontrol:id/wkzx_title')
				@wkzx_lcs_switch = id('com.iceboxcontrol:id/wkzx_lcs_switch')
				@wkzx_bws_switch = id('com.iceboxcontrol:id/wkzx_bws_switch')
				# @wkzx_lds_seekbar = id('com.iceboxcontrol:id/wkzx_lds_seekbar')
				@wkzx_smart_switch = id('com.iceboxcontrol:id/wkzx_smart_switch')
				@wkzx_holiday_switch = id('com.iceboxcontrol:id/wkzx_holiday_switch')
				@wkzx_leco_switch = id('com.iceboxcontrol:id/wkzx_leco_switch')
				@wkzx_foodfirst_switch = id('com.iceboxcontrol:id/wkzx_foodfirst_switch')
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
				# expect(@wkzx_lds_seekbar.displayed?).to be true
				expect(@wkzx_smart_switch.displayed?).to be true
				expect(@wkzx_holiday_switch.displayed?).to be true
				expect(@wkzx_leco_switch.displayed?).to be true
				expect(@wkzx_foodfirst_switch.displayed?).to be true
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
	end #after user login as STA mode
end #iceboxcontrol_STA_mode

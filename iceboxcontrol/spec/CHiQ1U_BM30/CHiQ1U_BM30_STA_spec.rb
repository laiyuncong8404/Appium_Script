# encoding: utf-8
=begin
#运行本脚本前，请开启appium_server；
#手机API18(4.3)及以上，手机连接WiFi路由；#手机连接电脑; 
#WiFi模块工作在STA模式
#脚本中未做异常网络处理，因此网络需要稳定，平台连接稳定
=end

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

describe 'iceboxcontrol_CHiQ1U_BM30_STA_mode' do
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
			# context 'login in' do
			it 'can not login with empty username and empty password' do
				login()
				sleep 5
				expect(@login_button.displayed?).to be true
			end
			it 'can not login with empty username and no-empty password' do
				login(nil,@old_password)
				sleep 5
				expect(@login_button.displayed?).to be true
			end
			it 'can not login with no-empty username and empty password' do
				login(@username,nil)
				sleep 5
				expect(@login_button.displayed?).to be true
			end
			it 'can not login with wrong username and wrong password' do
				login(@wrong_username,@wrong_password)
				sleep 5
				expect(@login_button.displayed?).to be true
			end
			it 'can not login with right username and wrong password' do
				login(@username,@wrong_password)
				sleep 5
				expect(@login_button.displayed?).to be true
			end
			it 'can not login with wrong username and right password' do
				login(@wrong_username,@old_password)
				sleep 5
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
			it 'auto-login worked' do
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
			# end
		end

		context 'setting_page' do
			before :all do
				enter_setting_page()
				sleep 5
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
				@soft_update_textview_noupdate = find_element(:id, 'com.iceboxcontrol:id/soft_update_noupdate')
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
				expect((@soft_update_textview_noupdate.text) == '已是最新版本').to be true
				expect((@unlogin_textview_text.text) == '退出登录').to be true
			end

			context 'userinfo page' do
				before :each do
					# sleep 3
					# @userinfo_textview.click #进入个人信息页面
					# sleep 5
					enter_userinfo_page()
					@userinfo_title_textview = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_title')
					@userinfo_nickname_textfiled = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_nickname_input')
					@userinfo_saveUserinfo_button = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_saveinfo')
					@userinfo_passwordModify_button = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modifypassword')
				end
				after :all do
					sleep 3
				end
				##修改个人信息
				it 'check user nickname' do
					begin
						expect((@userinfo_title_textview.text) == '个人信息').to be true
						expect((@userinfo_nickname_textfiled.text) == @new_nickname).to be true
					ensure
						back_click() #返回设置页面
					end
				end
				it 'change user nickname without confirm' do
					clear_nickname()
					sleep 5
					set_nickname(@new_nickname)
					@driver.navigate.back #取消，返回设置页面
					sleep 5
					expect((@page_title.text) == '设置').to be true
				end
				it 'change user nickname with 21 characters(limit:20)' do
					begin
						clear_nickname()
						sleep 5
						set_nickname(nickname = " abc !@#$%^&*()  def ")
						@userinfo_saveUserinfo_button.click
						sleep 10
						expect(@page_title.text) == '设置'#保存成功，返回设置页面
						@userinfo_textview.click #进入个人信息页面
						expect(@userinfo_nickname_textfiled.text == nickname[0..-2]).to be true #确认信息修改成功
					ensure
						back_click #返回设置页面
						sleep 3
					end
				end
				it 'change user nickname with confirm' do
					begin
						clear_nickname()
						sleep 5
						set_nickname(@new_nickname)
						@userinfo_saveUserinfo_button.click #保存成功，返回设置页面
						sleep 5
						@userinfo_textview.click #进入个人信息页面，确认信息修改成功
						expect((@userinfo_nickname_textfiled.text) == @new_nickname).to be true
					ensure
						back_click #返回设置页面
					end
				end
				context 'change userinfo_password page' do
					before :each do
						sleep 3
						@userinfo_passwordModify_button.click #从个人信息页面进入密码修改页面
						sleep 5
						@userinfo_oldpwd_textfiled = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modify_oldpwd_input')
						@userinfo_newpwd_textfiled = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modify_newpwd_input')
						@userinfo_newpwdRepeat_textfiled = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modify_newpwd_repeat_input')
						@confirm_button = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modify_yes')
						@cancel_button = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modify_no')
					end
					after :all do
						sleep 3
					end

					it 'check the password modify page elements' do
						begin
							expect(@confirm_button.displayed?).to be true
							expect((@confirm_button.text) == '确定').to be true
							expect(@cancel_button.displayed?).to be true
							expect((@cancel_button.text) == '取消').to be true
						ensure
							@cancel_button.click #返回个人信息页面
							back_click #返回设置页面
						end
					end
					it 'click cancel_button before type any text' do
						begin
							@cancel_button.click
							expect((@userinfo_title_textview.text) == '个人信息').to be true #取消修改则返回个人信息页面
						ensure
							back_click #返回设置页面
						end
					end
					it 'click confirm_button before type any text' do
						begin
							@confirm_button.click
							expect(@userinfo_oldpwd_textfiled.displayed?).to be true #未输入数据就确认修改，则停留在修改页面
						ensure
							@cancel_button.click #返回个人信息页面
							back_click #返回设置页面
						end
					end
					it 'change userinfo_password with wrong password' do
						begin
							change_user_password(@wrong_password,@new_password,@new_password)
							@confirm_button.click
							expect((@userinfo_title_textview.text) == '个人信息').to be true #提示旧密码错误后，返回个人信息页面
						ensure
							back_click #返回设置页面
						end
					end
					it 'change userinfo_password with new password short' do
						begin
							change_user_password(@old_password,@short_password,@short_password)
							@confirm_button.click
							expect(@userinfo_oldpwd_textfiled.displayed?).to be true #新密码长度不够，则停留在修改页面
							sleep 3
						ensure
							@cancel_button.click;sleep 1 #返回个人信息页面
							back_click #返回设置页面
							expect((@page_title.text) == '设置').to be true #返回设置页面
						end
					end
					it 'change userinfo_password with new password & repeat password not match' do
						begin
							change_user_password(@old_password,@new_password,@username)
							@confirm_button.click
							expect(@userinfo_oldpwd_textfiled.displayed?).to be true #新密码两次输入不一致，则停留在修改页面
							sleep 3
						ensure
							@cancel_button.click;sleep 1 #返回个人信息页面
							back_click #返回设置页面
							expect((@page_title.text) == '设置').to be true #返回设置页面
						end
					end
					it 'confirm change userinfo_password' do
						change_user_password(@old_password,@new_password,@new_password)
						@confirm_button.click
						expect((@page_title.text) == '设置').to be true #修改成功，返回设置页面
					end
				end
			end

			context 'fridgePwd page'do
				before :each do
					enter_fridgePwd_page()
					sleep 3
					@fridgeNewPwd_page_back = find_element(:id, 'com.iceboxcontrol:id/identify_back')
					@fridgePwd_page_title = find_element(:id, 'com.iceboxcontrol:id/identify_title')
					@fridgeNewPwd_sninput = find_element(:id, 'com.iceboxcontrol:id/resetvericode_sninput')
					@fridgeNewPwd = find_element(:id, 'com.iceboxcontrol:id/resetvericode_vericodeinput')
					@fridgeNewPwdRepeat = find_element(:id, 'com.iceboxcontrol:id/resetvericode_vericoderepeat')
					@fridgeNewPwd_confirm_button = find_element(:id, 'com.iceboxcontrol:id/resetvericode_confirm')
				end
				after :all do
					sleep 5
				end
				it 'check the fridgePwd page elements'do
					begin
						expect(@fridgeNewPwd_page_back.displayed?).to be true
						expect((@fridgePwd_page_title).displayed?).to be true
						expect((@fridgePwd_page_title).text == '冰箱密码').to be true
						expect(@fridgeNewPwd_sninput.displayed?).to be true
						expect(@fridgeNewPwd.displayed?).to be true
						expect(@fridgeNewPwdRepeat.displayed?).to be true
						expect(@fridgeNewPwd_confirm_button.displayed?).to be true
					ensure
						@fridgeNewPwd_page_back.click #返回设置页面
					end
				end
				it 'click confirm_button before type any text' do
					begin
						@fridgeNewPwd_confirm_button.click
						expect(@fridgePwd_page_title.displayed?).to be true
					ensure
						@fridgeNewPwd_page_back.click #返回设置页面
					end
				end
				it 'change fridgePwd with new password & repeat password not match' do
					begin
						change_fridgePwd(@short_fridgeNewPwd,@new_fridgeNewPwd)
						@fridgeNewPwd_confirm_button.click
						expect(@fridgePwd_page_title.displayed?).to be true #新密码两次输入不一致，则停留在当前页面
						sleep 3
					ensure
						@fridgeNewPwd_page_back.click #返回设置页面
					end
				end
				it 'confirm change fridgePwd' do
					begin
						change_fridgePwd(@new_fridgeNewPwd,@new_fridgeNewPwd)
						@fridgeNewPwd_confirm_button.click
						@fridgeNewPwd_page_back.click #返回设置页面
						enter_fridgePwd_page()
						expect((@fridgeNewPwd_sninput).displayed?).to be true
					ensure
						@fridgeNewPwd_page_back.click #返回设置页面
					end
				end
			end

			context 'network_setting page'do
				it 'can not enter net_setting page'do
					enter_net_setting_page()
					expect(exists{@net_setting_textview_text}).to be true
				end
			end

			context 'device_connect page'do
				before :each do
					enter_device_connect_page()
					sleep 3
					@device_setting_back = find_element(:id, 'com.iceboxcontrol:id/device_setting_back')
					@device_connect_title = find_element(:id, 'com.iceboxcontrol:id/device_connect_title')
					@device_connect_devicelist = find_element(:id, 'com.iceboxcontrol:id/device_connect_devicelist')
					@device_connect_add_button = find_element(:id, 'com.iceboxcontrol:id/device_connect_add')
					@device_connect_connect_button = find_element(:id, 'com.iceboxcontrol:id/device_connect_connect')
				end
				after :all do
					sleep 5
				end

				it 'check the device_connect page elements'do
					begin
						expect(@device_setting_back.displayed?).to be true
						expect(@device_connect_title.displayed?).to be true
						expect((@device_connect_title).text == '设备连接').to be true
						expect(@device_connect_devicelist.displayed?).to be true
						expect(@device_connect_add_button.displayed?).to be true
						expect(@device_connect_connect_button.displayed?).to be true
					ensure
						@device_setting_back.click #返回设置页面
					end
				end

				it 'delete all devices before add' do
					begin
						if exists{button('解绑定')}== false
						else
							devices = buttons('解绑定')
							for device in devices
								button('解绑定').click
								button('确定').click
							end
						end
					ensure
						back_click
					end
				end

				context 'device_connect_add page' do
					before :each do
						enter_device_connect_add_page() #从设备连接页面进入添加绑定设备页面
						sleep 3
						@device_connect_add_name = find_element(:id, 'com.iceboxcontrol:id/device_connect_add_nameinput')
						@device_connect_add_sn = find_element(:id, 'com.iceboxcontrol:id/device_connect_add_sninput')
						@device_connect_add_scan = find_element(:id, 'com.iceboxcontrol:id/device_connect_add_scan')
						@device_connect_add_fridgePwd = find_element(:id, 'com.iceboxcontrol:id/device_connect_add_vericodeinput')
						@device_connect_add_confirm_button = find_element(:id, 'com.iceboxcontrol:id/device_connect_add_yes')
						@device_connect_add_cancel_button = find_element(:id, 'com.iceboxcontrol:id/device_connect_add_no')
					end
					after :all do
						sleep 3
					end
					it 'check the device_connect page elements'do
						expect(@device_connect_add_name.displayed?).to be true
						expect((@device_connect_add_sn).displayed?).to be true
						expect(@device_connect_add_fridgePwd.displayed?).to be true
						expect(@device_connect_add_confirm_button.displayed?).to be true
						expect(@device_connect_add_cancel_button.displayed?).to be true
						@device_connect_add_cancel_button.click
						back_click #返回设置页面
					end
					it 'click confirm_button before type any text' do
						begin
							clear_device_connect_add_info()
							device_connect_add()
							@device_connect_add_confirm_button.click
							expect(@device_connect_add_confirm_button.displayed?).to be true #未输入数据就确认修改，则停留在当前页面
						ensure
							@device_connect_add_cancel_button.click #返回个人信息页面
							@device_setting_back.click #返回设置页面
						end
					end
					it 'device_connect_add with no name' do
						begin
							clear_device_connect_add_info()
							device_connect_add(nil,@device_sn,@wrong_fridgePwd)
							@device_connect_add_confirm_button.click
							expect(@device_connect_add_confirm_button.displayed?).to be true #停留在当前页面
						ensure
							@device_connect_add_cancel_button.click #返回个人信息页面
							@device_setting_back.click #返回设置页面
						end
					end
					it 'device_connect_add with no sn' do
						begin
							clear_device_connect_add_info()
							device_connect_add(@device_name,nil,@wrong_fridgePwd)
							@device_connect_add_confirm_button.click
							expect(@device_connect_add_confirm_button.displayed?).to be true #停留在当前页面
						ensure
							@device_connect_add_cancel_button.click #返回个人信息页面
							@device_setting_back.click #返回设置页面
						end
					end
					it 'device_connect_add with no password' do
						begin
							clear_device_connect_add_info()
							device_connect_add(@device_name,@device_sn,nil)
							@device_connect_add_confirm_button.click
							expect(@device_connect_add_confirm_button.displayed?).to be true #停留在当前页面
						ensure
							@device_connect_add_cancel_button.click #返回个人信息页面
							@device_setting_back.click #返回设置页面
						end
					end
					it 'device_connect_add with wrong sn' do
						begin
							clear_device_connect_add_info()
							device_connect_add(@device_name,@device_sn.chop,@wrong_fridgePwd) #移除sn中的最后一个字符
							@device_connect_add_confirm_button.click
							expect(@device_connect_add_confirm_button.displayed?).to be true #提示旧密码错误后，则停留在当前页面
						ensure
							@device_connect_add_cancel_button.click #返回设备连接页面
							back_click #返回设置页面
						end
					end
					it 'device_connect_add with wrong password' do
						begin
							device_connect_add(@device_name,@device_sn,@wrong_fridgePwd)
							@device_connect_add_confirm_button.click
							expect(@device_connect_add_confirm_button.displayed?).to be true #提示旧密码错误后，则停留在当前页面
						ensure
							@device_connect_add_cancel_button.click #返回设备连接页面
							back_click #返回设置页面
						end
					end
					it 'device_connect_add success' do
						begin
							device_connect_add(@device_name,@device_sn,@new_fridgeNewPwd)
							@device_connect_add_confirm_button.click
							sleep 3
							@device_connect_item_name = find_element(:id, 'com.iceboxcontrol:id/device_connect_item_name')
							expect(@device_connect_item_name.text).to eq(@device_name)
							expect(exists{button('解绑定')}).to be true
						ensure
							@device_setting_back.click #返回设置页面
						end
					end
					it 'device_connect_add fail by twice' do
						begin
							device_connect_add(@device_name,@device_sn,@new_fridgeNewPwd)
							@device_connect_add_confirm_button.click
							sleep 3
							expect(@device_connect_add_confirm_button.displayed?).to be true #停留在当前页面
						ensure
							@device_connect_add_cancel_button.click #返回设备连接页面
							back_click #返回设置页面
						end
					end
				end

				context 'device_connect_select page' do
					before :each do
						enter_device_connect_select_page() #从设备连接页面进入设备选择页面
						sleep 3
						@device_connect_control_name = find_element(:id, 'com.iceboxcontrol:id/device_connect_control_item_name')
						@device_connect_item_choosed = find_element(:id, 'com.iceboxcontrol:id/device_connect_item_choosed')
						@device_connect_control_confirm_button = find_element(:id, 'com.iceboxcontrol:id/device_connect_control_yes')
						@device_connect_control_cancel_button = find_element(:id, 'com.iceboxcontrol:id/device_connect_control_no')
					end
					after :all do
						sleep 3
					end

					it 'check the device_connect_select page elements' do
						begin
							expect(@device_connect_control_confirm_button.displayed?).to be true
							expect((@device_connect_control_confirm_button.text) == '确定').to be true
							expect(@device_connect_control_cancel_button.displayed?).to be true
							expect((@device_connect_control_cancel_button.text) == '取消').to be true
						ensure
							@device_connect_control_cancel_button.click #返回设备连接页面
							back_click #返回设置页面
						end
					end
					it 'click  cancel button before select any device' do
						begin
							@device_connect_control_cancel_button.click
							expect(@device_connect_title.text).to eq('设备连接') #返回设备连接页面
							expect(exists{text_exact('已连接')}).to be false
						ensure
							back_click #返回设置页面
						end
					end
					it 'click  confirm button before select any device' do
						begin
							@device_connect_control_confirm_button.click
							expect(@device_connect_control_confirm_button.displayed?).to be true #停留在当前页面
						ensure
							@device_connect_control_cancel_button.click #返回设备连接页面
							back_click #返回设置页面
						end
					end
					it 'click cancel button after select an device' do
						begin
							@device_connect_control_name.click
							@device_connect_control_cancel_button.click
							expect(@device_connect_title.text).to eq('设备连接') #返回设备连接页面
							expect(exists{text_exact('已连接')}).to be false
						ensure
							back_click #返回设置页面
						end
					end
					it 'connect an device' do
						begin
							@device_connect_control_name.click
							@device_connect_control_confirm_button.click
							expect(exists{text_exact('已连接')}).to be true #设备已连接
						ensure
							back_click #返回设置页面
						end
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
					button('确定').click
					sleep 3
					start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
					expect(@autoLogin_button.attribute('checked')).to eq('false')
					expect(@rememberPassword_button.attribute('checked')).to eq('true')
				end
			end
		end

		context 'WenKongZhongXin_page' do
			before :all do
				login(@username,@old_password)
				sleep 5
				enter_wkzx_page()
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

		context 'foodmanage_page' do
			before :all do
				enter_foodmanage_page()
				@foodmanage_title = id('com.iceboxcontrol:id/foodmanage_title')
				@foodmanage_foodadd = id('com.iceboxcontrol:id/foodmanage_foodadd')
				@foodmanage_categary_list = id('com.iceboxcontrol:id/foodmanage_categary_list')
			end
			after :all do
				sleep 3
			end

			it 'check foodmanage_page elements' do
				expect(@foodmanage_title.text).to eq('食品管理')
				expect(@foodmanage_foodadd.displayed?).to be true
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

			context 'food_add page' do
				before :each do
					enter_foodadd_page()
					@foodadd_title = id('com.iceboxcontrol:id/foodadd_title')
					@foodadd_back = id('com.iceboxcontrol:id/foodadd_back')
					@foodadd_voiceinput = id('com.iceboxcontrol:id/foodadd_voiceinput')
					@foodadd_left = id('com.iceboxcontrol:id/foodadd_left')
					@foodadd_right = id('com.iceboxcontrol:id/foodadd_right')
					@foodadd_search_input = id('com.iceboxcontrol:id/foodadd_searchfood')
					@foodadd_search_icon = id('com.iceboxcontrol:id/foodadd_search_icon')
				end
				after :each do
					@foodadd_back.click
				end

				it 'check food add page elements' do
					expect(@foodadd_title.text).to eq('食品添加')
					expect(@foodadd_back.displayed?).to be true
					expect(@foodadd_voiceinput.displayed?).to be true
					expect(@foodadd_left.displayed?).to be true
					expect(@foodadd_right.displayed?).to be true
					expect(@foodadd_search_input.displayed?).to be true
					expect(@foodadd_search_icon.displayed?).to be true
				end
				it 'check each food add categary' do
					text('蔬菜').click
					expect(text('白菜').displayed?).to be true
					text('肉类').click
					expect(text('鹅').displayed?).to be true
					text('豆蛋制品').click
					expect(text('鹌鹑蛋').displayed?).to be true
					text('乳制品').click
					expect(text('冰激凌').displayed?).to be true
				end
				it 'food add categary can swipe' do
					swipe(start_x: 900, start_y: 300, end_x: 50, end_y: 300, duration: 4000)
					expect(text('剩菜剩饭').displayed?).to be true
					text('水果').click
					expect(text('板栗').displayed?).to be true
					text('其他').click
					expect(text('茶饮料').displayed?).to be true
					text('水产品').click
					expect(text('鲍鱼').displayed?).to be true
					text('剩菜剩饭').click
					expect(text_exact('剩菜').displayed?).to be true
				end
				it 'foodadd_left and foodadd_right are work' do
					3.times {@foodadd_right.click; sleep 1}
					text('剩菜剩饭').click
					expect(exists{text_exact('剩菜')}).to be true
					3.times {@foodadd_left.click; sleep 1}
					text('蔬菜').click
					expect(exists{text('白菜')}).to be true
				end
				it 'add each categary\'s first and last food' do
					categary1 = ['蔬菜','肉类','豆蛋制品','乳制品']
					categary1.each do |categary1_name|
						text(categary1_name).click
						id('com.iceboxcontrol:id/foodadd_item_img').click
						add_food()
						text(categary1_name).click
						5.times {swipe_food_to_visibel()}
						last_ele('android.widget.TextView').click
						add_food()
					end
					categary2 = ['水果','其他','水产品','剩菜剩饭']
					categary2.each do |categary2_name|
						swipe_food_categary_to_visible()
						text(categary2_name).click
						id('com.iceboxcontrol:id/foodadd_item_img').click
						add_food()
						swipe_food_categary_to_visible()
						text(categary2_name).click
						4.times {swipe_food_to_visibel()}
						# last_ele('android.widget.TextView').click #有bug，可能被handle挡住
						ele = ids('com.iceboxcontrol:id/foodadd_item_img')
						last_ele = ele[-1].click
						add_food()
					end
				end
			end

			context 'foodadd search_page' do
				before :each do
					enter_foodadd_page()
				end
				after :each do
					back_from_foodadd_page_to_foodmanage_page()
				end

				it 'search do not work with full blank' do
					foodadd_search(foodname = "  ")
					expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
				end
				it 'search do not work with "*"' do
					foodadd_search(foodname = "豆腐*")
					expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
				end
				it 'search do not work with blank before food name' do
					foodadd_search(foodname = " 豆腐") #直接输入空格或转义字符无效，此处应为官方Bug，实际输入了Unicode
					expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
				end
				it 'search do not work with blank between food name' do
					foodadd_search(foodname = "豆 腐")
					expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
				end
				it 'search do not work with blank after food name' do
					foodadd_search(foodname = "豆腐 ")
					expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
				end
				it 'search food in menu' do
					foodadd_search(foodname = "豆腐")
					expect(text('麻婆豆腐').displayed?).to be true
					expect(texts('豆腐').size).to eq 7
				end
				it 'search food not in menu' do
					foodadd_search(foodname = "果冻")
					expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
				end
			end

			context 'foodadd detail_page' do
				before :each do
					enter_foodadd_detail_page()
					@foodadd_detail_title = id('com.iceboxcontrol:id/foodadd_detail_title')
					@foodadd_detail_back = id('com.iceboxcontrol:id/foodadd_detail_back')
					@foodadd_confirm = id('com.iceboxcontrol:id/foodadd_confirm')
					@foodadd_detail_foodname = id('com.iceboxcontrol:id/foodadd_detail_foodname')
					@foodadd_detail_foodnum = id('com.iceboxcontrol:id/foodadd_detail_foodnum')
					@foodadd_detail_foodlife = id('com.iceboxcontrol:id/foodadd_detail_foodlife')
					@foodadd_detail_fooddate = id('com.iceboxcontrol:id/foodadd_detail_fooddate')
					@foodadd_detail_foodmode = id('com.iceboxcontrol:id/foodadd_detail_foodmode')
					@foodadd_detail_spinner = ids('com.iceboxcontrol:id/food_spinner') #下拉框图标
				end
				after :each do
					back_from_foodadd_detail_page_to_foodmanage_page()
				end

				it 'check foodadd_detail page elements'do
					expect(@foodadd_detail_title.text).to eq('食品录入')
					expect(@foodadd_confirm.displayed?).to be true
					expect(@foodadd_detail_back.displayed?).to be true
					expect(@foodadd_detail_foodname.displayed?).to be true
					expect(@foodadd_detail_foodnum.displayed?).to be true
					expect(@foodadd_detail_foodlife.displayed?).to be true
					expect(@foodadd_detail_fooddate.displayed?).to be true
					expect(@foodadd_detail_foodmode.displayed?).to be true
				end
				it 'foodadd_detail confirm add before set number'do
					@foodadd_confirm.click
					expect(@foodadd_confirm.displayed?).to be true
				end
				it 'foodadd_detail number is set to zero'do
					@foodadd_detail_foodnum.clear
					@foodadd_detail_foodnum.type 0
					@foodadd_confirm.click
					expect(@foodadd_confirm.displayed?).to be true
				end
				it 'foodadd_detail unit have four values'do
					@foodadd_detail_spinner[0].click
					expect(text_exact('个').displayed?).to be true
					expect(text_exact('克').displayed?).to be true
					expect(text_exact('千克').displayed?).to be true
					expect(text_exact('毫升').displayed?).to be true
				end
				it 'foodadd_detail unit should unfold automatic'do
					expect(exists{text('克')}).to be false
				end
				it 'foodadd_detail mode have two values for #560 series'do
					@foodadd_detail_spinner[1].click #app的bug，前一次没有修改，则需要点击2次
					expect(text_exact('冷藏室').displayed?).to be true
					expect(text_exact('冷冻室').displayed?).to be true
				end
				it 'foodadd_detail mode should unfold automatic'do
					expect(exists{text('冷冻室')}).to be false
				end
			end

			context 'foodadd page->voiceInput page' do
				before :each do
					enter_foodadd_voiceinput_page()
				end
				after :each do
					back_from_foodadd_page_to_foodmanage_page()
				end

				it 'check the voiceInput page elements' do
					expect(id('android:id/alertTitle').text).to include('语音添加提示')
					expect(id('android:id/message').text).to include ('例如')
					expect(button('确定').displayed?).to be true
					expect(button('取消').displayed?).to be true
					button('取消').click
					expect(text('食品添加').displayed?).to be true
				end
				context 'voiceInput->speak page' do
					before :each do
						button('确定').click
					end
					it 'check voiceInput->speak page elements' do
						expect(text('讯飞语音使用帮助').displayed?).to be true
						expect(text('安静环境').displayed?).to be true
						expect(text('科大讯飞').displayed?).to be true
						expect(button('知道了').displayed?).to be true
						expect(button('详细').displayed?).to be true
						button('知道了').click
						expect(text('请说出内容').displayed?).to be true
						expect(button('说完了').displayed?).to be true
						expect(button('取消').displayed?).to be true
						button('取消').click
						expect(text('食品添加').displayed?).to be true
					end
					it 'click button before speak any word' do
						button('说完了').click
						expect(button('重新说话').displayed?).to be true
						button('取消').click
					end
					it 'cancel re-speak'do
						button('说完了').click
						button('取消').click
						expect(text('食品添加').displayed?).to be true
					end
					it 'respeak does work'do
						button('说完了').click
						button('重新说话').click
						expect(button('说完了').displayed?).to be true
						button('取消').click
					end
				end
			end

			context 'food_list page' do
				it 'check foodlist for each categary have been successful added'do
					expect(id('com.iceboxcontrol:id/foodmanage_categary_list').displayed?).to be true
					expect(text_exact('剩菜').displayed?).to be true
					expect(text_exact('植物黄油').displayed?).to be true
					expect(text_exact('章鱼').displayed?).to be true
				end
				it 'foodlist can swipe'do
					2.times {swipe(start_x:200, start_y:1750, end_x:200, end_y:360, duration:3000)}
					expect(text_exact('板栗').displayed?).to be true
					expect(text_exact('紫花菜').displayed?).to be true
					expect(text_exact('鹌鹑蛋').displayed?).to be true
					expect(text('真空包装').displayed?).to be true #字符显示不全，长度限制：5
					expect(text_exact('冰激凌').displayed?).to be true
					2.times {swipe(start_x:200, start_y:360, end_x:200, end_y:1750, duration:3000)}
				end
			end

			context 'food_edit page' do
				before :each do
					text('章鱼').click
					@foodedit_detail_back = id('com.iceboxcontrol:id/foodmanage_back')
					@foodedit_detail_foodmode = id('com.iceboxcontrol:id/foodmanage_detail_foodmode')
					@foodmanage_delete_button = id('com.iceboxcontrol:id/foodmanage_delete')
				end
				after :each do
					back_from_foodedit_detail_page_to_foodmanage_page()
					sleep 2
				end

				it 'edit button and delete button should be displayed'do
					expect(button('编辑').displayed?).to be true
					expect(@foodmanage_delete_button.displayed?).to be true
				end
				it 'foodmode is un-checkable before click edit button' do
					@foodedit_detail_foodmode.click
					sleep 2
					expect(@foodedit_detail_foodmode.attribute('checked')).to eq('false')
				end
				it 'check elements after click edit button' do
					button('编辑').click
					expect(button('完成').displayed?).to be true
					expect(ids('com.iceboxcontrol:id/food_spinner')[1].displayed?).to be true
					button('完成').click
				end
				it 'change alert should not appear expect changes taken'do
					button('编辑').click
					button('完成').click
					expect(@foodmanage_title.displayed?).to be true
				end
				it 'foodmode is checkable after click edit button' do
					button('编辑').click
					@foodedit_detail_foodmode.click
					sleep 2
					button('完成').click
					button('确定').click
					expect(id('com.iceboxcontrol:id/foodmanage_item_mode').displayed?).to be true
					text('章鱼').click
					expect(@foodedit_detail_foodmode.attribute('checked')).to eq('true')
				end
				it 'changes take no effect if canceled' do
					button('编辑').click
					ids('com.iceboxcontrol:id/food_spinner')[0].click
					text('毫升').click
					button('完成').click
					button('取消').click
					expect(ids('com.iceboxcontrol:id/foodmanage_item_Unit')[4].text).to eq('个')
				end
				it 'food unit can be edit' do
					button('编辑').click
					ids('com.iceboxcontrol:id/food_spinner')[0].click
					text('千克').click
					button('完成').click
					button('确定').click
					expect(ids('com.iceboxcontrol:id/foodmanage_item_Unit')[4].text).to eq('千克')
				end
				it 'food number can be edit' do
					button('编辑').click
					id('com.iceboxcontrol:id/foodmanage_detail_foodnum_input').clear
					id('com.iceboxcontrol:id/foodmanage_detail_foodnum_input').type rand(1..100)
					button('完成').click
					button('确定').click
				end
				it 'food mode can be edit' do
					button('编辑').click
					ids('com.iceboxcontrol:id/food_spinner')[1].click
					text('冷冻室').click
					button('完成').click
					button('确定').click
					text('章鱼').click
					expect(text('冷冻室').displayed?).to be true
				end
			end
		end

		context 'cookbook_page' do
			before :all do
				enter_cookbook_page()
				@title_slect = id('com.iceboxcontrol:id/titleimage2')
				@horizontal_button = tags('android.widget.RadioButton')
				@search_button = id('com.iceboxcontrol:id/titleimage3')
			end
			it 'check cookbook_page elements' do
				expect(text('按推荐').displayed?).to be true
				expect(@title_slect.displayed?).to be true
				expect(@search_button.displayed?).to be true
				expect(text('葱油鸡').displayed?).to be true
			end
		end
	end
end

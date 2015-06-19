# encoding: utf-8
=begin
#运行本脚本前，请开启appium_server；
#手机连接WiFi路由；#手机连接电脑; 
#WiFi模块工作在STA模式
#脚本中未做异常网络处理，因此网络需要稳定，平台连接稳定
=end

require 'rubygems'
require 'rspec'
require 'appium_lib'
require 'net/http'
require File.join(File.dirname(__FILE__), 'public_method')

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

describe 'iceboxcontrol_STA_mode' do
   before(:all) do
      @driver = Appium::Driver.new(desired_caps).start_driver
      Appium.promote_appium_methods RSpec::Core::ExampleGroup
      @username = "13540774227"
      @old_password = @new_password = "123456"
      @wrong_username = "13340774227"
      @wrong_password = @short_password = "12345"
      @new_nickname = "Lucy"
   end
   after(:all) do
      @drive_quit
   end

   context 'login_page' do
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
      context 'login in' do
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
            if exists{button('确定')}==true
               # swipe(start_x: 550, start_y: 1120, end_x: 550, end_y: 800, duration: 1000)
               # touch_action = Appium::TouchAction.new
               # element = text('成都21')
               # touch_action.press(element: element, x: 230, y: 1115).perform
               # touch_action.release().perform
               ele_index('android.widget.TextView', 2).click #第一个设备名称
               button('确定').click
               sleep 3
               @handle = find_element(:id, 'com.iceboxcontrol:id/handle')
               expect(@handle.displayed?).to be true
               sleep 5
               back_click
               expect(button('确定').displayed?).to be true
               alert_click('确定')
            else
               @handle = find_element(:id, 'com.iceboxcontrol:id/handle')
               expect(@handle.displayed?).to be true
               sleep 5
               back_click
               expect(button('确定').displayed?).to be true
               alert_click('确定')
            end
         end
         it 'rememberPassword worked' do
            start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
            sleep 3
            @username_textfiled.clear
            @username_textfiled.type @username
            @password_textfiled.clear
            @password_textfiled.type @old_password
            @rememberPassword_button.click
            @login_button.click
            sleep 5
            @handle = find_element(:id, 'com.iceboxcontrol:id/handle')
            expect(@handle.displayed?).to be true
            sleep 5
            back_click
            expect(button('确定').displayed?).to be true
            alert_click('确定')
            start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
            sleep 3
            @login_button.click
            @handle = find_element(:id, 'com.iceboxcontrol:id/handle')
            expect(@handle.displayed?).to be true
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
            back_click
            expect(button('确定').displayed?).to be true
            alert_click('确定')
            start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
            sleep 5
            @handle = find_element(:id, 'com.iceboxcontrol:id/handle')
            expect(@handle.displayed?).to be true
         end
      end
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
            sleep 3
            @userinfo_textview.click #进入个人信息页面
            sleep 5
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
   end
end

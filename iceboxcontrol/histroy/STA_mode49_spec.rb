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
require File.join(File.dirname(__FILE__), 'public_method')

APP_PATH = 'E:\SSC_长虹软服中心\项目文档\智能冰箱技术研究与应用\低成本WiFi模块开发（QCA4004方案）\IceBoxControl_20150615.apk'

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
      @drive_quit
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
               begin
                  button('确定').click
                  sleep 3
                  start_activity app_package: 'com.iceboxcontrol', app_activity: 'com.iceboxcontrol.activitys.LoginActivity'
                  expect(@autoLogin_button.attribute('checked')).to eq('false')
                  expect(@rememberPassword_button.attribute('checked')).to eq('true')
               ensure
                  @login_button.click
                  enter_wkzx_page()
                  sleep 3
               end
            end
         end
      end

      context 'foodmanage_page' do
         before :all do
            enter_foodmanage_page()
            @foodmanage_title = id('com.iceboxcontrol:id/foodmanage_title')
            @foodmanage_foodadd = id('com.iceboxcontrol:id/foodmanage_foodadd')
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
      end
   end
end

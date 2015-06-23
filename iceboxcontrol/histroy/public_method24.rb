# encoding: utf-8

#手机back键
def back_click()
   press_keycode(4)
end
# login_page
# @username_textfiled = find_element(:id, 'com.iceboxcontrol:id/login_username')
# @password_textfiled = find_element(:id, 'com.iceboxcontrol:id/login_password')
# @login_button = find_element(:id, 'com.iceboxcontrol:id/login_btn')
# @autoLogin_button = find_element(:id, 'com.iceboxcontrol:id/auto_login')
# @rememberPassword_button = find_element(:id, 'com.iceboxcontrol:id/remember_psw')
# @forgotPassword_textview = find_element(:id, 'com.iceboxcontrol:id/forgot_psw')
# @registerId_textview = find_element(:id, 'com.iceboxcontrol:id/register_id')
# @mode_textview = find_element(:id, 'android:id/text1')
def login(username = nil,password = nil)
   @username_textfiled.clear
   @username_textfiled.type username
   @password_textfiled.clear
   @password_textfiled.type password
   # @autoLogin_button.click
   # @rememberPassword_button.click
   @login_button.click
end

#setting_page
# @page_title = texts_exact('设置')[0]
# @userinfo_textview = find_element(:id, 'com.iceboxcontrol:id/info')
# @userinfo_textview_text = find_element(:id, 'com.iceboxcontrol:id/infotext')
# @identify_textview = find_element(:id, 'com.iceboxcontrol:id/identify')
# @identify_textview_text = find_element(:id, 'com.iceboxcontrol:id/identifytext')
# @net_setting_textview = find_element(:id, 'com.iceboxcontrol:id/net_setting')
# @net_setting_textview_text = find_element(:id, 'com.iceboxcontrol:id/net_settingtext')
# @dev_connect_textview = find_element(:id, 'com.iceboxcontrol:id/dev_connect')
# @dev_connect_textview_text = find_element(:id, 'com.iceboxcontrol:id/dev_connecttext')
# @soft_update_textview = find_element(:id, 'com.iceboxcontrol:id/soft_update')
# @soft_update_textview_text = find_element(:id, 'com.iceboxcontrol:id/soft_updatetext')
# @soft_update_textview_noupdate = find_element(:id, 'com.iceboxcontrol:id/soft_update_noupdate')
# @telephone_textview = find_element(:id, 'com.iceboxcontrol:id/telephone')
# @unlogin_textview = find_element(:id, 'com.iceboxcontrol:id/unlogin')
# @unlogin_textview_text = find_element(:id, 'com.iceboxcontrol:id/munlogin')

def enter_setting_page()
   @handle = find_element(:id, 'com.iceboxcontrol:id/handle')
   @handle.click
   @setting = find_element(:uiautomator, 'new UiSelector().text("设置")')
   @setting.click
end
# @wkzx = find_element(:uiautomator, 'new UiSelector().text("温控中心")')
# @spdq = find_element(:uiautomator, 'new UiSelector().text("食谱大全")')
# @spgl = find_element(:uiautomator, 'new UiSelector().text("食品管理")')
# @reminder = find_element(:uiautomator, 'new UiSelector().text("提醒")')

#userinfo_page
# @userinfo_title_textview = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_title')
# @userinfo_nickname_textfiled = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_nickname_input')
# @userinfo_saveUserinfo_button = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_saveinfo')
# @userinfo_passwordModify_button = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modifypassword')
def clear_nickname()
   @userinfo_nickname_textfiled.click
   length = (@userinfo_nickname_textfiled.text).length
   length.times do
      press_keycode(22) #Directional Pad Right key. May also be synthesized from trackball motions
   end
   length.times do
      press_keycode(67)#Backspace key. Deletes characters before the insertion point
   end
end

def set_nickname(nickname = nil)
   @userinfo_nickname_textfiled.type nickname
   hide_keyboard
end

#userinfo_password page
# @userinfo_oldpwd_textfiled = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modify_oldpwd_input')
# @userinfo_newpwd_textfiled = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modify_newpwd_input')
# @userinfo_newpwdRepeat_textfiled = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modify_newpwd_repeat_input')
# @confirm_button = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modify_yes')
# @cancel_button = find_element(:id, 'com.iceboxcontrol:id/setting_userinfo_modify_no')
def change_user_password(oldpwd=nil,newpwd=nil,newpwdRepeat=nil)
   @userinfo_oldpwd_textfiled.type oldpwd
   @userinfo_newpwd_textfiled.type newpwd
   @userinfo_newpwdRepeat_textfiled.type newpwdRepeat
   hide_keyboard #隐藏键盘
end

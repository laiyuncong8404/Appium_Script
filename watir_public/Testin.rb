# encoding: utf-8
require 'rubygems'
require 'watir-webdriver'
# 本程序用于向Testin网站提交app进行标准兼容测试

@base_url = 'http://www.testin.cn/portal.action?op=Portal.index' #登录Testin网站
@login_url = "http://sso.testin.cn/user.action?op=Login.check&domain=real.testin.cn&ru=http%3A%2F%2Frealauto.testin.cn%2Fnativeapp.action%3Fop%3DApp.list"
#网站用户名
email = "laiyuncong8404@163.com"
#网站密码
pwd = "19840415" #请将*更换为实际密码
#App登录用户名
loginName = '13540774227'
#App登录密码
loginPass = "123456"


dr = Watir::Browser.new :chrome
Watir.default_timeout = 300 #设置等待时间300s
dr.window.maximize()
# dr.goto @base_url
# sleep 5
# dr.link(:text, "用户登录").click
dr.goto @login_url
sleep 5
dr.text_field(:name, 'email').set email
dr.text_field(:name, 'pwd').set pwd
dr.button(:tag_name, 'button').click #登录按钮

dr.link(:text, '创建测试').click
# dr.element(:css, '#app_compatible_test').click #标准兼容测试
js="var q=document.documentElement.scrollTop=10000"  #移动滚动条到底部
dr.execute_script(js) 
sleep 5
dr.link(:id, 'next_step').click
sleep 5
dr.link(:id, 'button_continue').click
sleep 5
dr.select_list(:id, 'sel_detail_type').select('其他应用')
sleep 2
dr.element(:css, '#commit_package').click #上传App按钮
sleep 5

system (File.join(File.dirname(__FILE__), 'uploadApp.exe')) #不支持直接设置，需要调用autoit
dr.element(:css, "#app_progress_success").wait_until_present #等待app上传完成
dr.element(:css,'#monkeyselect').checkbox(:name, 'monkeyflag').set
sleep 5
dr.element(:css,'#select_txt_file_name_checkbox').click
dr.element(:css,'#upload_app_tr_opt > td > dl:nth-child(1) > dt > label > input[type="radio"]').click
sleep 5
dr.text_field(:name, 'loginName').set loginName
dr.text_field(:name, 'loginPass').set loginPass
dr.element(:css,'#upload_commit.green_button').click
sleep 5

android_os = dr.element(:css, '#selected_area > table:nth-child(1) > tbody').checkboxes(:css, 'input[type=checkbox]')
puts "#{android_os.size}" #安卓系统类型总数
for os in android_os
	os.set
end

dr.checkbox(:value, 'zhenhai.lai@changhong.com').set
dr.element(:css,'#finish.green_button').click #提交测试按钮
dr.quit

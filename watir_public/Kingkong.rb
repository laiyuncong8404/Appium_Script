# encoding: utf-8
require 'rubygems'
require 'watir-webdriver'
# 本程序用于向腾讯金刚网站提交app进行安全漏洞扫描测试

@base_url = "http://service.security.tencent.com/kingkong" #登录网站
uploadApp_path = File.join(File.dirname(__FILE__), 'uploadApp.exe') #上传App的AutoIt路径
md5_text_path = File.join(File.dirname(__FILE__), 'md5.txt')
md5_png_name = Time.now.to_s[0,10] #MD5图片名称，取当前年月日
md5_png_path = Dir.getwd + "/#{md5_png_name}.png"
email = "zhenhai.lai@changhong.com"

dr = Watir::Browser.new :chrome
Watir.default_timeout = 300 #设置等待时间300s
dr.window.maximize()
dr.goto @base_url
sleep 3
dr.element(:name, 'uploadAPK').click #上传按钮
sleep 3

system ("#{uploadApp_path}") #不支持直接设置，需要调用autoit
dr.text_field(:css, '#txtEmail').wait_until_present #等待app上传完成
md5 =  dr.element(:css, "#apk_modal > div.modal-body > div > div:nth-child(2)").text
md5 = md5[(md5.length-39)..-8] #去掉多余字符
puts md5
#把MD5值存储到本地文件中
puts "Opening the file..."
md5_text = File.open("#{md5_text_path}", "a+")
puts "I'm going to write MD5 to the file."
md5_text.puts ("#{Time.now}")
md5_text.puts ("#{md5}")
md5_text.close()
sleep 5
dr.text_field(:css, '#txtEmail').set email
dr.checkbox(:id, 'chkEmail').set
dr.screenshot.save("#{md5_png_path}")
dr.button(:css, "#apk_modal > div.modal-footer > button").click #确认按钮
dr.quit
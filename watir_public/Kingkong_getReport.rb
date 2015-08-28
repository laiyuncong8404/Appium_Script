# encoding: utf-8
require 'rubygems'
require 'watir-webdriver'
# 本程序用于通过MD5向腾讯金刚网站获取安全漏洞扫描测试报告

@base_url = "http://service.security.tencent.com/kingkong" #登录网站
md5_text_path = File.join(File.dirname(__FILE__), 'md5.txt')


dr = Watir::Browser.new :chrome
Watir.default_timeout = 300 #设置等待时间300s
dr.window.maximize()
dr.goto @base_url
sleep 3
#从本地文件中读取MD5值
md5_text = IO.readlines("#{md5_text_path}")
md5 = md5_text[-1] #取最后一行
sleep 5
dr.text_field(:tag_name, 'input-medium pull-left jg-query-text').set md5
dr.link(:text, '查询').click #查询报告

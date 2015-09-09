# Script for ChangHong
【watir_public】公用文件夹中的ruby脚本用于自动提交app到云测网站进行兼容测试和安全测试。


项目文件夹中的【spec】文件夹为appium自动化脚本，用于App的回归测试。

Please enter the folder for each project and get the test_cases.

These cases are wrote by Ruby with *ruby_lib*.

Run the test_cases with [Rspec](http://rspec.info/).

**eg1:**

	cd ..\project_folder\
	rspec -f d STA_mode_foodmanage_page_spec.rb

**eg2:**

	cd ..\project_folder\
	rspec -f h STA_mode_foodmanage_page_spec.rb > STA.html

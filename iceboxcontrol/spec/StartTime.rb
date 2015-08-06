#encoding: utf-8
require 'rubygems'

#捕获启动Activity
# adb logcat -c && adb logcat -s ActivityManager | findstr "Displayed"

#停止App后启动Activity
# adb -d shell am start -S -n com.iceboxcontrol/com.iceboxcontrol.activitys.LoginActivity

def start_cat()
	system("C:\\Appium_Script\\iceboxcontrol\\spec\\CatActivity.bat")
end

def start_Activity(a=1)
	a.times do |start|
		start = IO.popen("adb -d shell am start -S -n com.iceboxcontrol/com.iceboxcontrol.activitys.LoginActivity", mode="r")
		sleep 2
	end
end
# start_cat()
start_Activity(a=11)
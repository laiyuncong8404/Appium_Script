#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         LaiZhenhai

 Script Function:
	upload app to website.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;ControlFocus("title","text",controlID) Edit1=Edit instance 1
 ControlFocus("打开", "","Edit1")

; Wait 10 seconds for the Upload window to appear
  WinWait("[CLASS:#32770]","",10)

; Set the APK file path in the Edit field
  ControlSetText("打开", "", "Edit1", "E:\SSC_长虹软服中心\项目文档\超级APP\SuerApp8_31.apk")
  Sleep(2000)

; Click on the Open button
  ControlClick("打开", "","Button1");
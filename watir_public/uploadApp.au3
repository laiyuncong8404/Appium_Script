#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         LaiZhenhai

 Script Function:
	upload app to website.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;ControlFocus("title","text",controlID) Edit1=Edit instance 1
 ControlFocus("��", "","Edit1")

; Wait 10 seconds for the Upload window to appear
  WinWait("[CLASS:#32770]","",10)

; Set the APK file path in the Edit field
  ControlSetText("��", "", "Edit1", "E:\SSC_�����������\��Ŀ�ĵ�\���ܱ��似���о���Ӧ��\BCD-238ZIP3CK�ڳ���Ŀ\V1.1\IceBoxControl_20150724.apk")
  Sleep(2000)

; Click on the Open button
  ControlClick("��", "","Button1");
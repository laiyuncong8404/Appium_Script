# encoding: utf-8

require 'rubygems'
require 'rspec'
require 'appium_lib'
require 'net/http'
require File.join(File.dirname(__FILE__), 'public_method')

APP_PATH = "../IceBoxControl_20150615.apk"

def desired_caps
   {
      caps: {
         app:               APP_PATH,
         appActivity:      'com.iceboxcontrol.activitys.LoginActivity',
         appPackage:       'com.iceboxcontrol',
         platformName:     'android',
         platformVersion:  '4.4.4',#API:19
         deviceName:       '274b3f06',#MI 3真机
         unicodeKeyboard:  'true',
         resetKeyboard:    'true',
         noReset:       'false'
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
      @device_sn = "FRTEST400911700407014919"
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
         it 'auto-login worked' do
            @username_textfiled.clear
            @username_textfiled.type @username
            @password_textfiled.clear
            @password_textfiled.type @old_password
            @autoLogin_button.click
            sleep 3
            @login_button.click
            sleep 5
            enter_wkzx_page()
            sleep 3
            @handle = find_element(:id, 'com.iceboxcontrol:id/handle')
            expect(@handle.displayed?).to be true
         end
      end

      context 'foodmanage_page' do
         before :all do
            enter_foodmanage_page()
            @foodmanage_title = id('com.iceboxcontrol:id/foodmanage_title')
            @foodmanage_foodadd = id('com.iceboxcontrol:id/foodmanage_foodadd')
            @foodmanage_categary_list = id('com.iceboxcontrol:id/foodmanage_categary_list')
         end
         after :all do
            sleep 3
         end
         # it 'delete all foods before add' do
         #    begin
         #       10000.times do
         #          if exists{id('com.iceboxcontrol:id/foodmanage_item_name')} == false
         #             break
         #          else
         #             food = id('com.iceboxcontrol:id/foodmanage_item_name')
         #             delete_food_from_categary_list = Appium::TouchAction.new.press(element:food).wait(4000).perform
         #             button('确定').click
         #             sleep 3
         #          end
         #       end
         #    ensure
         #       expect(exists{food}).to be false
         #    end
         # end
         # context 'food add page' do
         #    before :each do
         #       enter_foodadd_page()
         #       @foodadd_title = id('com.iceboxcontrol:id/foodadd_title')
         #       @foodadd_back = id('com.iceboxcontrol:id/foodadd_back')
         #       @foodadd_voiceinput = id('com.iceboxcontrol:id/foodadd_voiceinput')
         #       @foodadd_left = id('com.iceboxcontrol:id/foodadd_left')
         #       @foodadd_right = id('com.iceboxcontrol:id/foodadd_right')
         #       @foodadd_search_input = id('com.iceboxcontrol:id/foodadd_searchfood')
         #       @foodadd_search_icon = id('com.iceboxcontrol:id/foodadd_search_icon')
         #    end
         #    after :each do
         #       @foodadd_back.click
         #    end
         #    it 'add each categary\'s first and last food' do
         #       categary1 = ['蔬菜','肉类','豆蛋制品','乳制品']
         #       categary1.each do |categary1_name|
         #          text(categary1_name).click
         #          id('com.iceboxcontrol:id/foodadd_item_img').click
         #          add_food()
         #          text(categary1_name).click
         #          4.times {swipe_food_to_visibel()}
         #          last_ele('android.widget.TextView').click
         #          add_food()
         #       end
         #       categary2 = ['水果','其他','水产品','剩菜剩饭']
         #       categary2.each do |categary2_name|
         #          swipe_food_categary_to_visible()
         #          text(categary2_name).click
         #          id('com.iceboxcontrol:id/foodadd_item_img').click
         #          add_food()
         #          swipe_food_categary_to_visible()
         #          text(categary2_name).click
         #          4.times {swipe_food_to_visibel()}
         #          # last_ele('android.widget.TextView').click
         #          ele = ids('com.iceboxcontrol:id/foodadd_item_img')
         #          last_ele = ele[-1].click
         #          add_food()
         #       end
         #    end
         # end

         # context 'foodmanage_foodlist page'do
         #    it 'check foodlist for each categary have been successful added'do
         #       expect(id('com.iceboxcontrol:id/foodmanage_categary_list').displayed?).to be true
         #       expect(text_exact('剩菜').displayed?).to be true
         #       expect(text_exact('鹅').displayed?).to be true
         #       expect(text_exact('植物黄油').displayed?).to be true
         #       expect(text_exact('章鱼').displayed?).to be true
         #       expect(text_exact('枣').displayed?).to be true
         #    end
         #    it 'foodlist can swipe'do
         #       2.times {swipe(start_x:200, start_y:1750, end_x:200, end_y:360, duration:3000)}
         #       expect(text_exact('板栗').displayed?).to be true
         #       expect(text_exact('紫花菜').displayed?).to be true
         #       expect(text_exact('鹌鹑蛋').displayed?).to be true
         #       expect(text('真空包装').displayed?).to be true #字符显示不全，长度限制：5
         #       expect(text_exact('茶饮料').displayed?).to be true
         #       expect(text_exact('冰激凌').displayed?).to be true
         #       2.times {swipe(start_x:200, start_y:360, end_x:200, end_y:1750, duration:3000)}
         #    end
         # end
         context 'foodadd_edit page'do
            before :each do
               text('鹅').click
               @foodedit_detail_back = id('com.iceboxcontrol:id/foodmanage_back')
               @foodedit_detail_foodmode = id('com.iceboxcontrol:id/foodmanage_detail_foodmode')
               @foodmanage_delete_button = id('com.iceboxcontrol:id/foodmanage_delete')
            end
            after :each do
               sleep 2
            end
            it 'edit button and delete button should be displayed'do
               begin
                  expect(button('编辑').displayed?).to be true
                  expect(@foodmanage_delete_button.displayed?).to be true
               ensure
                  @foodedit_detail_back.click
               end
            end
            it 'foodmode is un-checkable before click edit button' do
               begin
                  @foodedit_detail_foodmode.click
                  sleep 2
                  expect(@foodedit_detail_foodmode.attribute('checked')).to eq('false')
               ensure
                  @foodedit_detail_back.click
               end
            end
            it 'check elements after click edit button' do
               button('编辑').click
               expect(button('完成').displayed?).to be true
               expect(ids('com.iceboxcontrol:id/food_spinner')[1].displayed?).to be true
               button('完成').click
            end
            it 'change alert should not appear expect changes taken'do
               button('编辑').click
               button('完成').click
               expect(@foodmanage_title.displayed?).to be true
            end
            it 'changes take no effect if canceled' do
               button('编辑').click
               ids('com.iceboxcontrol:id/food_spinner')[0].click
               text('毫升').click
               button('完成').click
               button('取消').click
               expect(ids('com.iceboxcontrol:id/foodmanage_item_Unit')[2].text).to eq('个')
            end
            it 'food number can be edit' do
               button('编辑').click
               id('com.iceboxcontrol:id/foodmanage_detail_foodnum_input').clear
               id('com.iceboxcontrol:id/foodmanage_detail_foodnum_input').type rand(1..100)
               button('完成').click
               button('确定').click
            end
            it 'food unit can be edit' do
               button('编辑').click
               ids('com.iceboxcontrol:id/food_spinner')[0].click
               text('千克').click
               button('完成').click
               button('确定').click
               expect(ids('com.iceboxcontrol:id/foodmanage_item_Unit')[2].text).to eq('千克')
            end
            it 'food mode can be edit' do
               button('编辑').click
               ids('com.iceboxcontrol:id/food_spinner')[1].click
               text('冷冻室').click
               button('完成').click
               button('确定').click
            end
            it 'foodmode is checkable after click edit button' do
               button('编辑').click
               ids('com.iceboxcontrol:id/food_spinner')[1].click
               text('冷藏室').click
               @foodedit_detail_foodmode.click
               sleep 2
               button('完成').click
               button('确定').click
               expect(id('com.iceboxcontrol:id/foodmanage_item_mode').displayed?).to be true
               text('鹅').click
               expect(@foodedit_detail_foodmode.attribute('checked')).to eq('true')
               @foodedit_detail_back.click
            end

         end
      end
   end
end

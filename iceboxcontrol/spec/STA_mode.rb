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
      end

      context 'foodmanage_page' do
         before :all do
            login(@username,@old_password)
            sleep 5
            enter_wkzx_page()
            enter_foodmanage_page()
            @foodmanage_title = id('com.iceboxcontrol:id/foodmanage_title')
            @foodmanage_foodadd = id('com.iceboxcontrol:id/foodmanage_foodadd')
            @foodmanage_categary_list = id('com.iceboxcontrol:id/foodmanage_categary_list')
         end
         after :all do
            sleep 3
         end

         # it 'check foodmanage_page elements' do
         #    expect(@foodmanage_title.text).to eq('食品管理')
         #    expect(@foodmanage_foodadd.displayed?).to be true
         #    expect(text('名称').displayed?).to be true
         #    expect(text('数量/重量').displayed?).to be true
         #    expect(text('剩余时限').displayed?).to be true
         #    expect(@foodmanage_categary_list.displayed?).to be true
         # end
         # it 'delete all foods before add' do
         #    begin
         #       10000.times do
         #          if exists{id('com.iceboxcontrol:id/foodmanage_item_name')} == false
         #             break
         #          else
         #             food = id('com.iceboxcontrol:id/foodmanage_item_name')
         #             delete_food_from_categary_list = Appium::TouchAction.new.press(element:food).wait(4000).perform#.release(element:food).perform
         #             button('确定').click
         #             sleep 3
         #          end
         #       end
         #    ensure
         #       expect(exists{food}).to be false
         #    end
         # end

         # context 'food_add page' do
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

         #    it 'check food add page elements' do
         #       expect(@foodadd_title.text).to eq('食品添加')
         #       expect(@foodadd_back.displayed?).to be true
         #       expect(@foodadd_voiceinput.displayed?).to be true
         #       expect(@foodadd_left.displayed?).to be true
         #       expect(@foodadd_right.displayed?).to be true
         #       expect(@foodadd_search_input.displayed?).to be true
         #       expect(@foodadd_search_icon.displayed?).to be true
         #    end
         #    it 'check each food add categary' do
         #       text('蔬菜').click
         #       expect(text('白菜').displayed?).to be true
         #       text('肉类').click
         #       expect(text('鹅').displayed?).to be true
         #       text('豆蛋制品').click
         #       expect(text('鹌鹑蛋').displayed?).to be true
         #       text('乳制品').click
         #       expect(text('冰激凌').displayed?).to be true
         #    end
         #    it 'food add categary can swipe' do
         #       swipe(start_x: 900, start_y: 300, end_x: 50, end_y: 300, duration: 4000)
         #       expect(text('剩菜剩饭').displayed?).to be true
         #       text('水果').click
         #       expect(text('板栗').displayed?).to be true
         #       text('其他').click
         #       expect(text('茶饮料').displayed?).to be true
         #       text('水产品').click
         #       expect(text('鲍鱼').displayed?).to be true
         #       text('剩菜剩饭').click
         #       expect(text_exact('剩菜').displayed?).to be true
         #    end
         #    it 'foodadd_left and foodadd_right are work' do
         #       3.times {@foodadd_right.click; sleep 1}
         #       text('剩菜剩饭').click
         #       expect(exists{text_exact('剩菜')}).to be true
         #       3.times {@foodadd_left.click; sleep 1}
         #       text('蔬菜').click
         #       expect(exists{text('白菜')}).to be true
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
         #          # last_ele('android.widget.TextView').click #有bug，可能被handle挡住
         #          ele = ids('com.iceboxcontrol:id/foodadd_item_img')
         #          last_ele = ele[-1].click
         #          add_food()
         #       end
         #    end
         # end

         # context 'foodadd search_page' do
         #    before :each do
         #       enter_foodadd_page()
         #    end
         #    after :each do
         #       back_from_foodadd_page_to_foodmanage_page()
         #    end

         #    it 'search do not work with full blank' do
         #       foodadd_search(foodname = "  ")
         #       expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
         #    end
         #    it 'search do not work with "*"' do
         #       foodadd_search(foodname = "豆腐*")
         #       expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
         #    end
         #    it 'search do not work with blank before food name' do
         #       foodadd_search(foodname = " 豆腐") #直接输入空格或转义字符无效，此处应为官方Bug，实际输入了Unicode
         #       expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
         #    end
         #    it 'search do not work with blank between food name' do
         #       foodadd_search(foodname = "豆 腐")
         #       expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
         #    end
         #    it 'search do not work with blank after food name' do
         #       foodadd_search(foodname = "豆腐 ")
         #       expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
         #    end
         #    it 'search food in menu' do
         #       foodadd_search(foodname = "豆腐")
         #       expect(text('麻婆豆腐').displayed?).to be true
         #       expect(texts('豆腐').size).to eq 7
         #    end
         #    it 'search food not in menu' do
         #       foodadd_search(foodname = "果冻")
         #       expect(exists{id('com.iceboxcontrol:id/foodadd_item_text')}).to be false
         #    end
         # end

         # context 'foodadd detail_page' do
         #    before :each do
         #       enter_foodadd_detail_page()
         #       @foodadd_detail_title = id('com.iceboxcontrol:id/foodadd_detail_title')
         #       @foodadd_detail_back = id('com.iceboxcontrol:id/foodadd_detail_back')
         #       @foodadd_confirm = id('com.iceboxcontrol:id/foodadd_confirm')
         #       @foodadd_detail_foodname = id('com.iceboxcontrol:id/foodadd_detail_foodname')
         #       @foodadd_detail_foodnum = id('com.iceboxcontrol:id/foodadd_detail_foodnum')
         #       @foodadd_detail_foodlife = id('com.iceboxcontrol:id/foodadd_detail_foodlife')
         #       @foodadd_detail_fooddate = id('com.iceboxcontrol:id/foodadd_detail_fooddate')
         #       @foodadd_detail_foodmode = id('com.iceboxcontrol:id/foodadd_detail_foodmode')
         #       @foodadd_detail_spinner = ids('com.iceboxcontrol:id/food_spinner') #下拉框图标
         #    end
         #    after :each do
         #       back_from_foodadd_detail_page_to_foodmanage_page()
         #    end

         #    it 'check foodadd_detail page elements'do
         #       expect(@foodadd_detail_title.text).to eq('食品录入')
         #       expect(@foodadd_confirm.displayed?).to be true
         #       expect(@foodadd_detail_back.displayed?).to be true
         #       expect(@foodadd_detail_foodname.displayed?).to be true
         #       expect(@foodadd_detail_foodnum.displayed?).to be true
         #       expect(@foodadd_detail_foodlife.displayed?).to be true
         #       expect(@foodadd_detail_fooddate.displayed?).to be true
         #       expect(@foodadd_detail_foodmode.displayed?).to be true
         #    end
         #    it 'foodadd_detail confirm add before set number'do
         #       @foodadd_confirm.click
         #       expect(@foodadd_confirm.displayed?).to be true
         #    end
         #    it 'foodadd_detail number is set to zero'do
         #       @foodadd_detail_foodnum.clear
         #       @foodadd_detail_foodnum.type 0
         #       @foodadd_confirm.click
         #       expect(@foodadd_confirm.displayed?).to be true
         #    end
         #    it 'foodadd_detail unit have four values'do
         #       @foodadd_detail_spinner[0].click
         #       expect(text_exact('个').displayed?).to be true
         #       expect(text_exact('克').displayed?).to be true
         #       expect(text_exact('千克').displayed?).to be true
         #       expect(text_exact('毫升').displayed?).to be true
         #    end
         #    it 'foodadd_detail unit should unfold automatic'do
         #       expect(exists{text('克')}).to be false
         #    end
         #    it 'foodadd_detail mode have two values for #560 series'do
         #       2.times {@foodadd_detail_spinner[1].click} #app的bug，前一次没有修改，则需要点击2次
         #       expect(text_exact('冷藏室').displayed?).to be true
         #       expect(text_exact('冷冻室').displayed?).to be true
         #    end
         #    it 'foodadd_detail mode should unfold automatic'do
         #       expect(exists{text('冷冻室')}).to be false
         #    end
         # end

         # context 'foodadd page->voiceInput page' do
         #    before :each do
         #       enter_foodadd_voiceinput_page()
         #    end
         #    after :each do
         #       back_from_foodadd_page_to_foodmanage_page()
         #    end

         #    it 'check the voiceInput page elements' do
         #       expect(id('android:id/alertTitle').text).to include('语音添加提示')
         #       expect(id('android:id/message').text).to include ('例如')
         #       expect(button('确定').displayed?).to be true
         #       expect(button('取消').displayed?).to be true
         #       button('取消').click
         #       expect(text('食品添加').displayed?).to be true
         #    end
         #    context 'voiceInput->speak page' do
         #       before :each do
         #          button('确定').click
         #       end
         #       it 'check voiceInput->speak page elements' do
         #          expect(text('讯飞语音使用帮助').displayed?).to be true
         #          expect(text('安静环境').displayed?).to be true
         #          expect(text('科大讯飞').displayed?).to be true
         #          expect(button('知道了').displayed?).to be true
         #          expect(button('详细').displayed?).to be true
         #          button('知道了').click
         #          expect(text('请说出内容').displayed?).to be true
         #          expect(button('说完了').displayed?).to be true
         #          expect(button('取消').displayed?).to be true
         #          button('取消').click
         #          expect(text('食品添加').displayed?).to be true
         #       end
         #       it 'click button before speak any word' do
         #          button('说完了').click
         #          expect(button('重新说话').displayed?).to be true
         #          button('取消').click
         #       end
         #       it 'cancel re-speak'do
         #          button('说完了').click
         #          button('取消').click
         #          expect(text('食品添加').displayed?).to be true
         #       end
         #       it 'respeak does work'do
         #          button('说完了').click
         #          button('重新说话').click
         #          expect(button('说完了').displayed?).to be true
         #          button('取消').click
         #       end
         #    end
         # end

         # context 'food_list page' do
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

         context 'food_edit page' do
            before :each do
               text('鹅').click
               @foodedit_detail_back = id('com.iceboxcontrol:id/foodmanage_back')
               @foodedit_detail_foodmode = id('com.iceboxcontrol:id/foodmanage_detail_foodmode')
               @foodmanage_delete_button = id('com.iceboxcontrol:id/foodmanage_delete')
            end
            after :each do
               back_from_foodedit_detail_page_to_foodmanage_page()
               sleep 2
            end

            it 'edit button and delete button should be displayed'do
               expect(button('编辑').displayed?).to be true
               expect(@foodmanage_delete_button.displayed?).to be true
            end
            it 'foodmode is un-checkable before click edit button' do
               @foodedit_detail_foodmode.click
               sleep 2
               expect(@foodedit_detail_foodmode.attribute('checked')).to eq('false')
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
            it 'foodmode is checkable after click edit button' do
               button('编辑').click
               @foodedit_detail_foodmode.click
               sleep 2
               button('完成').click
               button('确定').click
               expect(id('com.iceboxcontrol:id/foodmanage_item_mode').displayed?).to be true
               text('鹅').click
               expect(@foodedit_detail_foodmode.attribute('checked')).to eq('true')
            end
            it 'changes take no effect if canceled' do
               button('编辑').click
               # 2.times {ids('com.iceboxcontrol:id/food_spinner')[0].click} #此处为app的Bug，需要点击2次
               ids('com.iceboxcontrol:id/food_spinner')[0].click
               text('毫升').click
               button('完成').click
               button('取消').click
               expect(ids('com.iceboxcontrol:id/foodmanage_item_Unit')[2].text).to eq('个')
            end
            it 'food unit can be edit' do
               button('编辑').click
               ids('com.iceboxcontrol:id/food_spinner')[0].click
               text('千克').click
               button('完成').click
               button('确定').click
               expect(ids('com.iceboxcontrol:id/foodmanage_item_Unit')[2].text).to eq('千克')
            end
            it 'food number can be edit' do
               button('编辑').click
               id('com.iceboxcontrol:id/foodmanage_detail_foodnum_input').clear
               id('com.iceboxcontrol:id/foodmanage_detail_foodnum_input').type rand(1..100)
               button('完成').click
               button('确定').click
            end
            it 'food mode can be edit' do
               button('编辑').click
               ids('com.iceboxcontrol:id/food_spinner')[1].click
               text('冷冻室').click
               button('完成').click
               button('确定').click
            end
         end
      end
   end
end

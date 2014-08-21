package com.editor.moudule_drama.view.left.attributeEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIHSlider;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIRadioButton;
	import com.editor.component.controls.UIRadioButtonGroup;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITextInputWidthLabel;
		
	public class DramaAttributeEditor_LayoutView extends UICanvas
	{
		public function DramaAttributeEditor_LayoutView()
		{
			super();
			create_init();
		}
		
		/**容器**/
		public var vbox:UIVBox;
		
		/**名称**/
		public var input1:UITextInputWidthLabel;
		/**X**/
		public var input3:UITextInputWidthLabel;
		/**Y**/
		public var input4:UITextInputWidthLabel;
		
		/**左右缩放**/
		public var hbox1:UIHBox;
		/**上下缩放**/
		public var hbox2:UIHBox;
		/**角度调整**/
		public var hbox3:UIHBox;
		
		/**左右缩放**/
		public var slider1:UIHSlider;
		/**上下缩放**/
		public var slider2:UIHSlider;
		/**角度调整**/
		public var slider3:UIHSlider;
		/**透明调整**/
		public var slider4:UIHSlider;
		/**左右缩放**/
		public var slider1Input:UITextInput;
		/**上下缩放**/
		public var slider2Input:UITextInput;
		/**角度调整**/
		public var slider3Input:UITextInput;
		/**透明调整**/
		public var slider4Input:UITextInput;
		
		/**是否过渡**/
		public var checkBox1:UICheckBox;
		/**是否过渡**/
		public var input5:UITextInput;
		/**鼠标参数**/
		public var input6:UITextInputWidthLabel;
		
		/**深度按钮**/
		public var toUpButton:UIButton;
		/**深度按钮**/
		public var toDownButton:UIButton;
		
		/**锁定按钮**/
		public var lockButton:UIButton;
		/**删除按钮**/
		public var deleButton:UIButton;
		/**复制按钮**/
		public var cloneButton:UIButton;
		
		/**角色人物	容器**/
		public var role_container:UIVBox;
		/**角色人物	选择武器**/
		public var role_selectBtn2:UIButton;
		/**角色人物	选择武器**/
		public var role_selectInput2:UITextInput;
		/**角色人物	选择动作**/
		public var role_combox1:UICombobox;
		/**角色人物	选择混合动作**/
		public var role_combox2:UICombobox;
		/**角色人物	选择技能 input**/
		public var role_combox3Input:UITextInput;
		/**角色人物	选择技能 button**/
		public var role_combox3Button:UIButton;
		
		/**角色人物	动作种类**/
		public var role_radioButtonGroup1:UIRadioButtonGroup;
		/**角色人物	动作各类0**/
		public var role_radioButton0:UIRadioButton;
		/**角色人物	动作各类1**/
		public var role_radioButton1:UIRadioButton;
		/**角色人物	动作各类2**/
		public var role_radioButton2:UIRadioButton;
		
		/**角色人物	方向**/
		public var role_radioButtonGroup2:UIRadioButtonGroup;
		
		private function create_init():void
		{
			vbox = new UIVBox();
			vbox.x = 10; vbox.y = 10;
			vbox.verticalGap = 10;
			addChild(vbox);
			
			input1 = new UITextInputWidthLabel();
			input1.width = 160; input1.height = 20;
			//input1.editable = false;
			input1.label = "    名称：";
			vbox.addChild(input1);
			
			input3 = new UITextInputWidthLabel();
			input3.width = 160; input3.height = 20;
			input3.restrict = "0-9\\-";
			input3.label = "          X：";
			vbox.addChild(input3);
			
			input4 = new UITextInputWidthLabel();
			input4.width = 160; input4.height = 20;
			input4.restrict = "0-9\\-";
			input4.label = "          Y：";
			vbox.addChild(input4);
			
			/**左右缩放**/
			hbox1 = new UIHBox();
			hbox1.horizontalGap = 10;
			hbox1.verticalAlign = "middle";
			vbox.addChild(hbox1);
			var lable1:UILabel = new UILabel();
			lable1.height = 18;
			lable1.text = "左右缩放：";
			hbox1.addChild(lable1);
			
			slider1 = new UIHSlider();
			slider1.width = 60; slider1.height = 6;
			hbox1.addChild(slider1);
			
			slider1Input = new UITextInput();
			slider1Input.width = 36;
			slider1Input.height = 20;
			slider1Input.restrict = "0-9\\.\\-";
			hbox1.addChild(slider1Input);
			
			/**上下缩放**/
			hbox2 = new UIHBox();
			hbox2.horizontalGap = 10;
			hbox2.verticalAlign = "middle";
			vbox.addChild(hbox2);
			var lable2:UILabel = new UILabel();
			lable2.height = 18;
			lable2.text = "上下缩放：";
			hbox2.addChild(lable2);
			
			slider2 = new UIHSlider();
			slider2.width = 60; slider2.height = 6;
			hbox2.addChild(slider2);
			
			slider2Input = new UITextInput();
			slider2Input.width = 36;
			slider2Input.height = 20;
			slider2Input.restrict = "0-9\\.\\-";
			hbox2.addChild(slider2Input);
			
			/**角度调整**/
			hbox3 = new UIHBox();
			hbox3.horizontalGap = 10;
			hbox3.verticalAlign = "middle";
			vbox.addChild(hbox3);
			var lable3:UILabel = new UILabel();
			lable3.height = 18;
			lable3.text = "角度调整：";
			hbox3.addChild(lable3);
			
			slider3 = new UIHSlider();
			slider3.width = 60; slider3.height = 6;
			hbox3.addChild(slider3);
			
			slider3Input = new UITextInput();
			slider3Input.width = 36;
			slider3Input.height = 20;
			slider3Input.restrict = "0-9";
			slider3Input.editable = false;
			hbox3.addChild(slider3Input);
			
			
			/**透明调整**/
			var hbox9:UIHBox = new UIHBox();
			hbox9.horizontalGap = 10;
			hbox9.verticalAlign = "middle";
			vbox.addChild(hbox9);
			var lable6:UILabel = new UILabel();
			lable6.height = 18;
			lable6.text = "透明调整：";
			hbox9.addChild(lable6);
			
			slider4 = new UIHSlider();
			slider4.width = 60; slider4.height = 6;
			hbox9.addChild(slider4);
			
			slider4Input = new UITextInput();
			slider4Input.width = 36;
			slider4Input.height = 20;
			slider4Input.restrict = "0-9\\.";
			slider4Input.editable = true;
			hbox9.addChild(slider4Input);
			
			
			
			/**是否过渡**/
			var hbox8:UIHBox = new UIHBox();
			vbox.addChild(hbox8);
			var txt3:UILabel = new UILabel();
			txt3.text = "是否过渡：";
			hbox8.addChild(txt3);
			checkBox1 = new UICheckBox();
			checkBox1.width = 20; checkBox1.height = 20;
			hbox8.addChild(checkBox1);
			var spacer1:UICanvas = new UICanvas();
			spacer1.width = 5;
			hbox8.addChild(spacer1);
			input5 = new UITextInput();
			input5.width = 75; input5.height = 20;
			input5.editable = false;
			hbox8.addChild(input5);
			
			/**鼠标参数**/
			input6 = new UITextInputWidthLabel();
			input6.width = 160; input6.height = 20;
			input6.label = "鼠标参数：";
			vbox.addChild(input6);
			
			
			/**深度调整**/
			var hbox4:UIHBox = new UIHBox();
			hbox4.horizontalGap = 10;
			vbox.addChild(hbox4);
			var lable5:UILabel = new UILabel();
			lable5.height = 18;
			lable5.text = "深度调整：";
			hbox4.addChild(lable5);
			toUpButton = new UIButton();
			toUpButton.label = "上移";
			hbox4.addChild(toUpButton);
			toDownButton = new UIButton();
			toDownButton.label = "下移";
			hbox4.addChild(toDownButton);
			
			
			
			
			
			//继续播放
			
			
			var hbox5:UIHBox = new UIHBox();
			hbox5.horizontalGap = 10;
			vbox.addChild(hbox5);			
			
			/**删除**/
			deleButton = new UIButton();
			deleButton.label = "删除";
			hbox5.addChild(deleButton);			
			
			/**复制**/
			cloneButton = new UIButton();
			cloneButton.label = "复制";
			hbox5.addChild(cloneButton);
			
			/**锁定**/
			lockButton = new UIButton();
			lockButton.label = "解锁";
			hbox5.addChild(lockButton);	
						
			
			
			/**角色人物属性	容器**/
			role_container = new UIVBox();
			role_container.width = 180;
			role_container.padding = 10;
			role_container.verticalGap = 6;
			role_container.backgroundColor = 0xC7C3BB;
			vbox.addChild(role_container);			
			
			var hbox6:UIHBox = new UIHBox();
			hbox6.horizontalGap = 20;
			role_container.addChild(hbox6);
					
			/** << 选择武器**/
			var cvs2:UICanvas = new UICanvas();
//			role_container.addChild(cvs2);
			
			var lb6:UILabel = new UILabel();
			lb6.y = 5;
			lb6.text = "选择武器：";
			cvs2.addChild(lb6);
			
			role_selectInput2 = new UITextInput();
			role_selectInput2.x = 63; role_selectInput2.y = 5;
			role_selectInput2.width = 60; role_selectInput2.height = 20;
			role_selectInput2.editable = false;
			cvs2.addChild(role_selectInput2);
			
			role_selectBtn2 = new UIButton();
			role_selectBtn2.x = 125; role_selectBtn2.y = 5;
			role_selectBtn2.label = "选择";
			role_selectBtn2.enabled = false;
			cvs2.addChild(role_selectBtn2);
			
			/** << 选择方向**/
			role_radioButtonGroup2 = new UIRadioButtonGroup();
			
			var cvs1:UICanvas = new UICanvas();
			role_container.addChild(cvs1);
			
			var lab5:UILabel = new UILabel();
			lab5.text = "选择方向：";
			cvs1.addChild(lab5);
						
			var radio1:UIRadioButton = new UIRadioButton();
			radio1.x = 70;
			radio1.label = "右";
			radio1.height = 22;
			radio1.value = 0;
			radio1.group = role_radioButtonGroup2;
			cvs1.addChild(radio1);
			
			var radio2:UIRadioButton = new UIRadioButton();
			radio2.x = 115;
			radio2.label = "左";
			radio2.height = 22;
			radio2.value = 1;
			radio2.group = role_radioButtonGroup2;
			cvs1.addChild(radio2);
			
			/** <<选择动作**/
			role_radioButtonGroup1 = new UIRadioButtonGroup();
			/** 选择普通动作**/
			role_radioButton0 = new UIRadioButton();
			role_radioButton0.label = "选择普通动作:";
			role_radioButton0.height = 22
			role_radioButton0.value = 0;
			role_radioButton0.group = role_radioButtonGroup1;
			role_container.addChild(role_radioButton0);
			
			role_combox1 = new UICombobox();
			role_combox1.name = "role_combox1"
			role_combox1.width = 130; role_combox1.height = 20;
			role_container.addChild(role_combox1);
			
			/** 选择混合动作**/
			role_radioButton1 = new UIRadioButton();
			role_radioButton1.label = "选择混合动作:";
			role_radioButton1.height = 22
			role_radioButton1.value = 1;
			role_radioButton1.group = role_radioButtonGroup1;
			role_container.addChild(role_radioButton1);
			
			role_combox2 = new UICombobox();
			role_combox2.width = 130; role_combox2.height = 20;
			role_container.addChild(role_combox2);
			
			/** 选择技能**/
			role_radioButton2 = new UIRadioButton();
			role_radioButton2.label = "选择技能:";
			role_radioButton2.height = 22;
			role_radioButton2.value = 2;
			role_radioButton2.group = role_radioButtonGroup1;
			role_container.addChild(role_radioButton2);
			
			var hbox7:UIHBox = new UIHBox();
			hbox7.horizontalGap = 3;
			role_container.addChild(hbox7);
			
			role_combox3Input = new UITextInput();
			role_combox3Input.width = 88; role_combox3Input.height = 22;
			role_combox3Input.editable = false;
			hbox7.addChild(role_combox3Input);
			
			role_combox3Button = new UIButton();
			role_combox3Button.label = "选择";
			hbox7.addChild(role_combox3Button);
			
		}
		
	}
}
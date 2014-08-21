package com.editor.module_map.view.left.attributeEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIHSlider;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITextInputWidthLabel;

	public class MapEditorAttributeEditor_res extends UICanvas
	{
		public function MapEditorAttributeEditor_res()
		{
			super();
			create_init();
		}
		
		public var vbox:UIVBox;
		
		public var input1:UITextInputWidthLabel;
		public var input2:UICombobox;
		public var input3:UITextInputWidthLabel;
		public var input4:UITextInputWidthLabel;
		public var input6:UITextInputWidthLabel;
		
		public var hbox1:UIHBox;
		public var hbox2:UIHBox;
		public var hbox3:UIHBox;
		
		public var slider1:UIHSlider;
		public var slider2:UIHSlider;
		public var slider3:UIHSlider;
		public var slider1Input:UITextInput;
		public var slider2Input:UITextInput;
		public var slider3Input:UITextInput;
		
		public var toUpButton:UIButton;
		public var toDownButton:UIButton;
		
		public var lockButton:UIButton;
		public var deleButton:UIButton;
		public var cloneButton:UIButton;
		
		private function create_init():void
		{
			vbox = new UIVBox();
			vbox.x = 10; vbox.y = 10;
			vbox.verticalGap = 10;
			addChild(vbox);
			
			input1 = new UITextInputWidthLabel();
			input1.width = 160; input1.height = 20;
			input1.editable = false;
			input1.label = "        名称：";
			vbox.addChild(input1);
						
			var canvas1:UICanvas = new UICanvas();
			canvas1.height = 20;
			vbox.addChild(canvas1);
			var lable4:UILabel = new UILabel();
			lable4.text = "场景ID：";
			canvas1.addChild(lable4);
			input2 = new UICombobox();
			input2.x = 48; input2.y = 2;
			input2.width = 130; input2.height = 20;
			canvas1.addChild(input2);
						
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
			hbox1.height = 20;
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
			hbox2.height = 20;
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
			hbox3.height = 20;
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
			
			/**起始帧**/
			input6 = new UITextInputWidthLabel();
			input6.width = 130; input6.height = 20;
			input6.restrict = "0-9\\-";
			input6.label = "    起始帧：";
			vbox.addChild(input6);
			
			/**深度调整**/
			var hbox4:UIHBox = new UIHBox();
			hbox4.height = 20;
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
			
		}
		
		
		
		
	}
}
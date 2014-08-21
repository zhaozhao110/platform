package com.editor.module_map.view.left.attributeEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITextInputWidthLabel;
	
	import flash.events.MouseEvent;

	public class MapEditorAttributeEditor_scene extends UICanvas
	{
		public function MapEditorAttributeEditor_scene()
		{
			super();
			create_init();
		}
		
		public var vbox:UIVBox;
		
		public var input1:UITextInputWidthLabel;
		/**X**/
		public var input2:UITextInputWidthLabel;
		/**Y**/
		public var input3:UITextInputWidthLabel;
		public var input4:UITextInputWidthLabel;
		public var input5:UITextInput;
		public var input6:UITextArea;
		/**宽**/
		public var input7:UITextInputWidthLabel;
		/**高**/
		public var input8:UITextInputWidthLabel;
		/**旋转序列**/
		public var input9:UITextArea;
		/**出生点X**/
		public var input10:UITextInputWidthLabel;
		/**出生点y**/
		public var input11:UITextInputWidthLabel;
		
		public var checkBox1:UICheckBox;
		public var checkBox2:UICheckBox;
		
		private function create_init():void
		{
			vbox = new UIVBox();
			vbox.x = 10; vbox.y = 10;
			vbox.verticalGap = 10;
			addChild(vbox);
			
			input1 = new UITextInputWidthLabel();
			input1.width = 160; input1.height = 20;
			input1.editable = false;
			input1.label = "        ID：";
			vbox.addChild(input1);
			
			input2 = new UITextInputWidthLabel();
			input2.width = 160; input2.height = 20;
			input2.restrict = "0-9\\-";
			input2.label = "          X：";
			vbox.addChild(input2);
			
			input3 = new UITextInputWidthLabel();
			input3.width = 160; input3.height = 20;
			input3.restrict = "0-9\\-";
			input3.label = "          Y：";
			vbox.addChild(input3);
			
			input7 = new UITextInputWidthLabel();
			input7.width = 160; input7.height = 20;
			input7.restrict = "0-9\\-";
			input7.label = "         宽：";
			vbox.addChild(input7);
			
			input8 = new UITextInputWidthLabel();
			input8.width = 160; input8.height = 20;
			input8.restrict = "0-9\\-";
			input8.label = "         高：";
			vbox.addChild(input8);
			
			var hbox1:UIHBox = new UIHBox();
			vbox.addChild(hbox1);
			var txt1:UILabel = new UILabel();
			txt1.text = "设为角色层：";
			hbox1.addChild(txt1);
			checkBox1 = new UICheckBox();
			checkBox1.width = 20; checkBox1.height = 20;
			checkBox1.styleName = "uicanvas";
			hbox1.addChild(checkBox1);
			checkBox1.selected = false;
			
			input4 = new UITextInputWidthLabel();
			input4.width = 160; input4.height = 20;
			input4.label = "移动范围：";
			vbox.addChild(input4);
			
			input10 = new UITextInputWidthLabel();
			input10.width = 160; input10.height = 20;
			input10.restrict = "0-9";
			input10.label = " 产出点X：";
			vbox.addChild(input10);
			
			input11 = new UITextInputWidthLabel();
			input11.width = 160; input11.height = 20;
			input11.restrict = "0-9";
			input11.label = " 产出点Y：";
			vbox.addChild(input11);
			
			var hbox3:UIHBox = new UIHBox();
			vbox.addChild(hbox3);
			var txt3:UILabel = new UILabel();
			txt3.text = "左右速度：";
			hbox3.addChild(txt3);
			checkBox2 = new UICheckBox();
			checkBox2.width = 20; checkBox2.height = 20;
			checkBox2.styleName = "uicanvas";
			hbox3.addChild(checkBox2);
			var spacer1:UICanvas = new UICanvas();
			spacer1.width = 5;
			hbox3.addChild(spacer1);
			input5 = new UITextInput();
			input5.width = 75; input5.height = 20;
			input5.restrict = "0-9\\-\\.";
			hbox3.addChild(input5);
			
			var hbox2:UIHBox = new UIHBox();
			vbox.addChild(hbox2);
			var txt2:UILabel = new UILabel();
			txt2.text = "上下序列：";
			hbox2.addChild(txt2);
			input6 = new UITextArea();
			input6.width = 120; input6.height = 100;
			input6.toolTip = "开始X,开始Y,结束X,结束Y,速度*<br>--速度：像素 / 帧--";
			hbox2.addChild(input6);
			
			var hbox4:UIHBox = new UIHBox();
			vbox.addChild(hbox4);
			var txt4:UILabel = new UILabel();
			txt4.text = "旋转序列：";
			hbox4.addChild(txt4);
			input9 = new UITextArea();
			input9.width = 120; input9.height = 100;
			input9.toolTip = "开始角度,结束角度,中心点X,中心点Y,速度*<br>--速度：角度 / 帧--";
			hbox4.addChild(input9);
			
		}
		
			
	}
}
package com.editor.moudule_drama.view.left.attributeEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIRadioButton;
	import com.editor.component.controls.UIRadioButtonGroup;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInputWidthLabel;

	public class DramaAttributeEditor_FrameDialog extends UICanvas
	{
		public function DramaAttributeEditor_FrameDialog()
		{
			super();
			create_init();
		}
		
		public var vbox:UIVBox;
		
		/**层类型**/
		public var input1:UITextInputWidthLabel;
		/**帧类型**/
		public var input2:UICombobox;		
		/**选择左右**/
		public var radios:UIRadioButtonGroup;
		/**选择对话**/
		public var input3:UITextInputWidthLabel;
		/**选择对话按钮**/
		public var plotButton:UIButton;
		/**对话类型**/
		public var input6:UITextInputWidthLabel;
		/**对话内容**/
		public var input5:UITextArea;
		/**保存按钮**/
		public var saveButton:UIButton;
		/**删除按钮**/
		public var deleButton:UIButton;
		private function create_init():void
		{
			vbox = new UIVBox();
			vbox.x = 10; vbox.y = 10;
			vbox.verticalGap = 10;
			addChild(vbox);
			
			input1 = new UITextInputWidthLabel();
			input1.width = 174; input1.height = 20;
			input1.editable = false;
			input1.label = "    层类型：";
			input1.text = "对话层";
			vbox.addChild(input1);
			
			/**帧类型CANVAS**/
			var canvas1:UICanvas = new UICanvas();
			vbox.addChild(canvas1);
			var lable1:UILabel = new UILabel();
			lable1.text = "帧类型：";
			lable1.x = 12;
			canvas1.addChild(lable1);
			input2 = new UICombobox();
			input2.x = 60; input2.y = 2;
			input2.width = 114; input2.height = 20;
			canvas1.addChild(input2);
			
			/**按钮HBOX**/
			var hbox1:UIHBox = new UIHBox();
			hbox1.paddingLeft = 60;
			hbox1.horizontalGap = 10;
			vbox.addChild(hbox1);
			/**删除按钮**/
			deleButton = new UIButton();
			deleButton.label = "删除帧";
			hbox1.addChild(deleButton);
			/**保存按钮**/
			saveButton = new UIButton();
			saveButton.label = "插入帧";
			hbox1.addChild(saveButton);
			
			/**间隔**/
			var spacer:UICanvas = new UICanvas();
			spacer.width = 100; spacer.height = 15;
			vbox.addChild(spacer);
			
			/**选择左右**/
			radios = new UIRadioButtonGroup;
			var canvas2:UICanvas = new UICanvas();
			vbox.addChild(canvas2);
			var lable2:UILabel = new UILabel();
			lable2.text = "选择左右：        左               右";
			lable2.x = 0; lable2.y = 0;
			canvas2.addChild(lable2);
			var radio1:UIRadioButton = new UIRadioButton();
			radio1.x = 63; radio1.y = 4;
			radio1.group = radios;
			radio1.value = 0;
			canvas2.addChild(radio1);
			var radio2:UIRadioButton = new UIRadioButton();
			radio2.x = 120; radio2.y = 4;
			radio2.group = radios;
			radio2.value = 1;
			canvas2.addChild(radio2);
			
			/**选择对话**/
			var canvas3:UICanvas = new UICanvas();
			vbox.addChild(canvas3);
			input3 = new UITextInputWidthLabel();
			input3.width = 130; input3.height = 20;
			input3.editable = false;
			input3.label = "选择对话：";
			canvas3.addChild(input3);
			plotButton = new UIButton();
			plotButton.label = "选择";
			plotButton.x = 133;
			canvas3.addChild(plotButton);
			
			/**对话类型 **/
			input6 = new UITextInputWidthLabel();
			input6.width = 130; input6.height = 20;
			input6.editable = false;
			input6.label = "对话类型：";
			vbox.addChild(input6);
			
			/**对话内容**/
			var hbox2:UIHBox = new UIHBox();
			vbox.addChild(hbox2);
			var txt4:UILabel = new UILabel();
			txt4.text = "对话内容：";
			hbox2.addChild(txt4);
			input5 = new UITextArea();
			input5.width = 115; input5.height = 75;
			input5.editable = false;
			hbox2.addChild(input5);
			
			
			
		}
		
		
		
		
	}
}
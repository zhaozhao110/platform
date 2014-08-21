package com.editor.moudule_drama.view.left.attributeEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIRadioButton;
	import com.editor.component.controls.UITextInputWidthLabel;

	public class DramaAttributeEditor_FrameScene extends UICanvas
	{
		public function DramaAttributeEditor_FrameScene()
		{
			super();
			create_init();
		}
		
		public var vbox:UIVBox;
		/**层类型**/
		public var input1:UITextInputWidthLabel;
		/**帧类型**/
		public var input2:UICombobox;
		/**场景**/
		public var input3:UITextInputWidthLabel;
		/**选择场景按钮**/
		public var sceneButton:UIButton;
		/**场景位置**/
		public var input4:UITextInputWidthLabel;
		/**是否振动**/
		public var checkBox1:UICheckBox;
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
			input1.text = "场景层";
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
			
			/**选择场景**/
			var canvas2:UICanvas = new UICanvas();
			vbox.addChild(canvas2);
			input3 = new UITextInputWidthLabel();
			input3.width = 130; input3.height = 20;
			input3.editable = false;
			input3.label = "选择场景：";
			canvas2.addChild(input3);
			sceneButton = new UIButton();
			sceneButton.label = "选择";
			sceneButton.x = 133;
			canvas2.addChild(sceneButton);
			
			/**场景位置**/
			input4 = new UITextInputWidthLabel();
			input4.width = 174; input4.height = 20;
			input4.label = "场景位置：";
			vbox.addChild(input4);
			
			/**是否振动**/
			var canvas3:UICanvas = new UICanvas();
			vbox.addChild(canvas3);
			var lable2:UILabel = new UILabel();
			lable2.text = "是否振动：";
			lable2.x = 0; lable2.y = 0;
			canvas3.addChild(lable2);
			checkBox1 = new UICheckBox();
			checkBox1.x = 63; checkBox1.y = 4;
			canvas3.addChild(checkBox1);
		}
		
		
		
		
	}
}
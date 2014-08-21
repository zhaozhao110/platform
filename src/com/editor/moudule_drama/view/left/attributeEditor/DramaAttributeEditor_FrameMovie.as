package com.editor.moudule_drama.view.left.attributeEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInputWidthLabel;

	public class DramaAttributeEditor_FrameMovie extends UICanvas
	{
		public function DramaAttributeEditor_FrameMovie()
		{
			super();
			create_init();
		}
		
		public var vbox:UIVBox;
		
		/**层类型**/
		public var input1:UITextInputWidthLabel;
		/**帧类型**/
		public var input2:UICombobox;
		/**选择影片**/
		public var input3:UITextInputWidthLabel;
		/**选择影片按钮**/
		public var addRoleButton:UIButton;
		/**影片X**/
		public var input4:UITextInputWidthLabel;
		/**影片Y**/
		public var input5:UITextInputWidthLabel;
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
			/**层类型**/
			input1 = new UITextInputWidthLabel();
			input1.width = 174; input1.height = 20;
			input1.editable = false;
			input1.label = "    层类型：";
			input1.text = "影片层";
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
			
			/**选择影片**/
			var canvas2:UICanvas = new UICanvas();
			vbox.addChild(canvas2);
			input3 = new UITextInputWidthLabel();
			input3.y = 0;
			input3.width = 130; input3.height = 20;
			input3.editable = false;
			input3.label = "选择影片：";
			canvas2.addChild(input3);
			addRoleButton = new UIButton();
			addRoleButton.label = "选择";
			addRoleButton.x = 133; addRoleButton.y = 0;
			canvas2.addChild(addRoleButton);
			
			/**影片X**/
			input4 = new UITextInputWidthLabel();
			input4.width = 130; input4.height = 20;
			input4.label = "      影片X：";
			input4.restrict = "0-9\\-";
			vbox.addChild(input4);
			
			/**影片Y**/
			input5 = new UITextInputWidthLabel();
			input5.width = 130; input5.height = 20;
			input5.label = "      影片Y：";
			input5.restrict = "0-9\\-";
			vbox.addChild(input5);
			
			
			
		}
		
		
		
		
	}
}
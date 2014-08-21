package com.editor.moudule_drama.view.left.attributeEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.moudule_drama.view.render.FrameResRecordListRenderer;

	public class DramaAttributeEditor_FrameResRecord extends UICanvas
	{
		public function DramaAttributeEditor_FrameResRecord()
		{
			super();
			create_init();
		}
		
		public var vbox:UIVBox;
		/**层类型**/
		public var input1:UITextInputWidthLabel;
		/**帧类型**/
		public var input2:UICombobox;
		
		/**脚本**/
		public var input3:UITextInputWidthLabel;
		
		/**选择资源按钮**/
		public var seleResButton:UIButton;
		/**资源列表**/
		public var resListVbox:UIVBox;
		/**保存按钮**/
		public var saveButton:UIButton;
		/**删除按钮**/
		public var deleButton:UIButton;		
		/**上移按钮**/
		public var upButton:UIButton;
		/**下移按钮**/
		public var downButton:UIButton;
		
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
			input1.text = "资源层";
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
			
			/**执行**/
			input3 = new UITextInputWidthLabel();
			input3.width = 174; input3.height = 20;
			input3.label = "执行脚本：";
			vbox.addChild(input3);
			
			/**选择资源 CANVAS**/
			var canvas2:UICanvas = new UICanvas();
			vbox.addChild(canvas2);
			var lable2:UILabel = new UILabel();
			lable2.x = 0; lable2.y = 0;
			lable2.text = "资源属性列表：";
			canvas2.addChild(lable2);
			/**选择资源按钮**/
			seleResButton = new UIButton();
			seleResButton.x = 115; seleResButton.y = 0;
			seleResButton.label = "添加资源";
			canvas2.addChild(seleResButton);
			/**资源列表**/
			resListVbox = new UIVBox();
			resListVbox.x = 0; resListVbox.y = 25;
			resListVbox.width = 180; resListVbox.height = 300;
			resListVbox.padding = 2;
			resListVbox.verticalGap = 3;
			resListVbox.backgroundColor = 0xE5E5E5;
			resListVbox.verticalScrollPolicy = "auto";
			resListVbox.itemRenderer = FrameResRecordListRenderer;
			resListVbox.enabeldSelect = true;
			canvas2.addChild(resListVbox);
			
			/**上下移按钮容器**/
			var hbox2:UIHBox = new UIHBox;
			hbox2.x = 0; hbox2.y = 350;
			hbox2.horizontalGap = 20;
			canvas2.addChild(hbox2);
			/**上移按钮**/
			upButton = new UIButton();
			upButton.label = "上移";
			hbox2.addChild(upButton);
			/**下移按钮**/
			downButton = new UIButton();
			downButton.label = "下移";
			hbox2.addChild(downButton);
			
			
		}
		
		
	}
}
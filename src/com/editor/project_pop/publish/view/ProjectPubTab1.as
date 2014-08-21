package com.editor.project_pop.publish.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.manager.DataManager;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.controls.SandyTickTree;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;

	public class ProjectPubTab1 extends UICanvas
	{
		public function ProjectPubTab1()
		{
			super();
		}
		
		public var leftTree:SandyTickTree
		public var rightTree:SandyTickTree
		public var saveBtn:UIButton;
		public var textCan:UIVBox;
		public var fileTxt:UITextArea;
		public var fileBtn:UIButton;
		
		override public function delay_init():Boolean
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
						
			var hb2:UIHBox = new UIHBox();
			hb2.enabledPercentSize = true;
			hb2.horizontalGap= 10;
			addChild(hb2);
			
			var vb:UIVBox = new UIVBox();
			vb.width = 480
			vb.percentHeight = 100;
			hb2.addChild(vb);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 28;
			hb.verticalAlignMiddle = true
			hb.percentWidth = 100;
			vb.addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.height = 25;
			lb.text = "bin-debug目录下需要复制的文件"
			lb.width=300
			hb.addChild(lb);
			
			saveBtn = new UIButton();
			saveBtn.label = "保存配置"
			hb.addChild(saveBtn);
			
			fileBtn = new UIButton();
			fileBtn.label = "复制文件"
			hb.addChild(fileBtn);
			
			leftTree = new SandyTickTree();
			leftTree.enabledPercentSize = true;
			vb.addChild(leftTree);
			
			vb = new UIVBox();
			vb.width = 480
			vb.percentHeight = 100;
			hb2.addChild(vb);
			
			lb = new UILabel();
			lb.height = 25;
			lb.text = "bin-release目录下需要复制的文件"
			vb.addChild(lb);
			
			rightTree = new SandyTickTree();
			rightTree.enabledPercentSize = true;
			vb.addChild(rightTree);
			
			
			///////////////////////////////////////////////////
			
			textCan = new UIVBox();
			textCan.padding = 5;
			textCan.backgroundColor = DataManager.def_col
			textCan.styleName = "uicanvas"
			textCan.enabledPercentSize = true;
			textCan.visible = false;
			addChild(textCan);
			
			hb = new UIHBox();
			hb.height = 50;
			hb.percentWidth=100;
			hb.horizontalGap = 10;
			textCan.addChild(hb);
			
			var backBtn:UIButton = new UIButton();
			backBtn.label = "返回"
			backBtn.addEventListener(MouseEvent.CLICK , backBtnClick)
			hb.addChild(backBtn);
			
			var lb3:UIText = new UIText();
			lb3.color = ColorUtils.black;
			lb3.text = "复制的文件列表"
			hb.addChild(lb3);
			
			fileTxt = new UITextArea();
			fileTxt.enabledPercentSize = true
			fileTxt.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			textCan.addChild(fileTxt);
			
			return true;
		}
		
		public function setCopyFilesLog(s:String):void
		{
			fileTxt.htmlText = s;
			textCan.visible = true;
		}
		
		private function backBtnClick(e:MouseEvent):void
		{
			textCan.visible = false;
		}
	}
}
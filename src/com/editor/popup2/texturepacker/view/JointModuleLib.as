package com.editor.popup2.texturepacker.view
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.popup2.texturepacker.component.UIPanel;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class JointModuleLib extends UIPanel
	{
		public var tree:UIVlist;
		public var img:UIImage;
		public var addFoldBtn:UIButton;
		public var foldNameTi:UITextInput;
		public var reflashBtn:UIButton;
		
		public function JointModuleLib()
		{
			super();
			
			this.width = 240;
			this.height = 640
			this.x      = 805;
			this.y      = 50;
						
			var vb:UIVBox = new UIVBox();
			vb.enabledPercentSize = true;
			addChild(vb);
			
			var hb:UIHBox = new UIHBox();
			hb.percentWidth = 100;
			hb.verticalAlignMiddle = true;
			hb.horizontalGap = 3;
			hb.paddingLeft = 3;
			hb.height = 30;
			vb.addChild(hb);
			
			addFoldBtn = new UIButton();
			addFoldBtn.label = "导入目录"
			hb.addChild(addFoldBtn);
			
			foldNameTi = new UITextInput();
			foldNameTi.width = 100;
			hb.addChild(foldNameTi);
			
			reflashBtn = new UIButton();
			reflashBtn.label = "刷新"
			hb.addChild(reflashBtn);
			
			tree = new UIVlist;
			tree.mouseChildren = true;
			tree.rowHeight = 18;
			tree.enabledPercentSize = true;
			tree.verticalScrollPolicy  	= ASComponentConst.scrollPolicy_auto;
			tree.horizontalScrollPolicy	= ASComponentConst.scrollPolicy_off;
		//	tree.itemRenderer 	= UItreeRender;
			vb.addChild(tree);
			
		}
		
	}
}
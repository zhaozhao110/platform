package com.editor.project_pop.publish.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIVlist;
	import com.editor.project_pop.publish.component.ProjectPubTab2ItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class ProjectPubTab2 extends UIHBox
	{
		public function ProjectPubTab2()
		{
			super();
		}
		
		public var leftTree:UIVBox;
		public var selectBtn:UIButton;
		public var allBtn:UIButton;
		public var allBtn2:UIButton;
		
		override public function delay_init():Boolean
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			
			var vb:UIVBox = new UIVBox();
			vb.enabledPercentSize = true;
			addChild(vb);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 28;
			hb.verticalAlignMiddle = true
			hb.percentWidth = 100;
			vb.addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.height = 25;
			lb.text = "assets目录下所有fla,自动检测出哪些fla更新后没有编辑"
			lb.width=300
			hb.addChild(lb);
			
			selectBtn = new UIButton();
			selectBtn.label = "编译选中的"
			hb.addChild(selectBtn);
			
			allBtn = new UIButton();
			allBtn.label = "编译全部"
			hb.addChild(allBtn);
			
			allBtn2 = new UIButton();
			allBtn2.label = "选择所有未编译的"
			hb.addChild(allBtn2);
			
			var hb2:UICanvas = new UICanvas();
			hb2.height = 28;
			hb2.percentWidth = 100;
			vb.addChild(hb2); 
			
			var ti1:UILabel = new UILabel();
			ti1.text = "文件名"
			ti1.x = 50
			hb2.addChild(ti1);
			
			ti1 = new UILabel();
			ti1.text = "assets/swf/"
			ti1.x = 300;
			hb2.addChild(ti1);
			
			ti1 = new UILabel();
			ti1.text = "bin-debug/assets/swf"
			ti1.x = 520
			hb2.addChild(ti1);
			
			ti1 = new UILabel();
			ti1.text = "bin-size"
			ti1.x = 770
			hb2.addChild(ti1);
			
			leftTree = new UIVBox();
			leftTree.styleName = "list"
			leftTree.enabeldSelect = true;
			leftTree.verticalScrollPolicy = ASComponentConst.scrollPolicy_on;
			leftTree.enabledPercentSize = true;
			leftTree.itemRenderer = ProjectPubTab2ItemRenderer;
			vb.addChild(leftTree);
			
			return true;
		}
	}
}
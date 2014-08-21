package com.editor.project_pop.report
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class ProjectReportTab2 extends UIVBox
	{
		public function ProjectReportTab2()
		{
			super();
			create_init();
		}
		
		private var cb:UICombobox
		private var txt:UITextArea;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			
			var hb:UIHBox = new UIHBox();
			hb.height = 50;
			hb.percentWidth  =100;
			hb.verticalAlignMiddle = true;
			addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "检测类型: ";
			hb.addChild(lb);
			
			cb = new UICombobox();
			cb.width = 250;
			cb.height = 25;
			hb.addChild(cb);
			
			txt = new UITextArea();
			txt.enabledPercentSize = true;
			txt.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			txt.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(txt);
			
		}
	}
}
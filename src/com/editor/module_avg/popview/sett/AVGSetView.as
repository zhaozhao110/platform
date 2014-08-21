package com.editor.module_avg.popview.sett
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.module_avg.vo.AVGConfigVO;

	public class AVGSetView extends UIVBox
	{
		public function AVGSetView()
		{
			super();
			create_init();
		}
		
		public var wTi:UITextInputWidthLabel;
		public var hTi:UITextInputWidthLabel;
		
		private function create_init():void
		{
			label = "设置"
			enabledPercentSize = true;
			styleName = "uicanvas"
			paddingLeft = 3;
			verticalGap = 5;
			
			/////////////////////////////////////////////////////////////
			
			var lb:UILabel = new UILabel();
			lb.text = " -- 舞台设置 -- "
			lb.textAlign = "center"
			addChild(lb);
			
			wTi = new UITextInputWidthLabel();
			wTi.width = 270
			wTi.leftWidth = 100;
			wTi.label = "width:"
			wTi.enterKeyDown_proxy = wTiChange
			addChild(wTi);
			wTi.text = AVGConfigVO.instance.width.toString();
			
			hTi = new UITextInputWidthLabel();
			hTi.width = 270
			hTi.leftWidth = 100;
			hTi.label = "height:"
			hTi.enterKeyDown_proxy = wTiChange;
			addChild(hTi);
			hTi.text = AVGConfigVO.instance.height.toString();
				
			/////////////////////////////////////////////////////////////
		}
		
		private function wTiChange():void
		{
			AVGConfigVO.instance.width = int(wTi.text);
			AVGConfigVO.instance.height = int(hTi.text);
		}
		
		
	}
}
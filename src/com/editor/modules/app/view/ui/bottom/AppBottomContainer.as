package com.editor.modules.app.view.ui.bottom
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;

	public class AppBottomContainer extends UICanvas
	{
		public function AppBottomContainer()
		{
			super();
			create_init()
		}
		
		public var logtxt:UILabel;
		public var netIcon:UIImage;
		public var networkLB:UILabel;
		
		private function create_init():void
		{
			logtxt = new UILabel();
			addChild(logtxt);
			
			var hb:UIHBox = new UIHBox();
			hb.width = 200;
			hb.id = "UIHBox123"
		//	hb.background_red =true
			hb.right = 0;
			//hb.height=22
			addChild(hb);
			
			netIcon = new UIImage();
			//netIcon.background_red = true
			netIcon.width = 26;
			netIcon.height = 27;
			hb.addChild(netIcon);
			
			networkLB = new UILabel();
			//networkLB.width = 200
			//networkLB.right = 0;
			hb.addChild(networkLB);
			
		}
	}
}
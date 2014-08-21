package com.editor.module_gdps.app
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.manager.DataManager;
	import com.editor.module_gdps.pop.left.GdpsLeftContainer;
	import com.editor.module_gdps.pop.project.LoginProjectPopwin;
	import com.editor.module_gdps.pop.right.GdpsRightContainer;
	import com.editor.module_gdps.pop.top.GdpsTopToolContainer;

	public class GDPSMainUIContainer extends UICanvas
	{
		public function GDPSMainUIContainer()
		{
			super();
			//create_init();
		}
		
		public var topCell:GdpsTopToolContainer;
		public var leftCell:GdpsLeftContainer;
		public var rightCell:GdpsRightContainer;
		
		public function create_init():void
		{
			if(topCell!=null) return ;
			name = "GDPSMainUIContainer";
			styleName = "uicanvas";
			enabledPercentSize = true;
			backgroundColor = 0x9A9A9A;
			
			var vbox:UIVBox = new UIVBox();
			vbox.verticalGap = 10;
			vbox.enabledPercentSize = true;
			vbox.paddingRight = 12;
			vbox.paddingBottom = 15;
			vbox.paddingLeft = 5;
			addChild(vbox);
			
			topCell = new GdpsTopToolContainer();
			vbox.addChild(topCell);
			
			var hbox:UIHBox = new UIHBox();
			hbox.horizontalGap = 5;
			hbox.enabledPercentSize = true;
			vbox.addChild(hbox);

			leftCell = new GdpsLeftContainer();
			hbox.addChild(leftCell);
			
			rightCell = new GdpsRightContainer();
			hbox.addChild(rightCell);
			
			initComplete();
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			
		}
	}
}
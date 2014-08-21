package com.editor.view.popup
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIButton;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.component.SandyComponentConst;
	import com.sandy.component.controls.SandySpace;
	import com.sandy.component.expand.SandyPopupBottomButtonToolContainer;
	import com.sandy.event.SandyEvent;
	
	import flash.events.MouseEvent;
	
	public class AppyPopupBottomButtonToolContainer extends SandyPopupBottomButtonToolContainer
	{
		public function AppyPopupBottomButtonToolContainer(btnStyleName:String="")
		{
			super(btnStyleName);
		}
		
		private var icon:UIAssetsSymbol;
		private var helpIcon:UIAssetsSymbol;
		
		public var openHelp_f:Function;
		public var openFullHelp_f:Function;
		
		override protected function __init__():void
		{
			super.__init__();
				
			horizontalAlign = "left";
			paddingLeft = 20;
			paddingRight = 20
			
			icon = new UIAssetsSymbol();
			icon.source = "help_a";
			icon.width = 24;
			icon.height = 24;
			icon.toolTip = "帮助";
			addChild(icon);
			icon.addEventListener(MouseEvent.CLICK , onIconClick)
				
			helpIcon = new UIAssetsSymbol();
			helpIcon.source = "help2_a";
			helpIcon.width = 24;
			helpIcon.height = 24;
			helpIcon.toolTip = "打开完整帮助(将关闭窗口)";
			addChild(helpIcon);
			helpIcon.addEventListener(MouseEvent.CLICK , onHelpClick)
			
			var sp:SandySpace = new SandySpace();
			sp.percentWidth = 100;
			addChild(sp);
				
			super.createOkButton();
			super.createNoButton();
		}
		
		override protected function createOkButton():void{};
		override protected function createNoButton():void{};
		
		override public function get noBtnLabel():String
		{
			return "关闭"
		}
		
		private function onIconClick(e:MouseEvent):void
		{
			openHelp_f();
		}
		
		private function onHelpClick(e:MouseEvent):void
		{
			openFullHelp_f();
		}
	}
}
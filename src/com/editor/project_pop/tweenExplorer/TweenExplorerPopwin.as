package com.editor.project_pop.tweenExplorer
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.utils.setTimeout;

	public class TweenExplorerPopwin extends AppPopupWithEmptyWin
	{
		public function TweenExplorerPopwin()
		{
			super()
			create_init();
		}
		
		public var tab1:TweenExplorerPopwinTab1;
		public var tab2:TweenExplorerPopwinTab2;
		public var tab3:TweenExplorerPopwinTab3;
		public var tab4:TweenExplorerPopwinTab4;
		public var tab5:TweenExplorerPopwinTab5;
		
		private function create_init():void
		{
			var form:UITabBarNav = new UITabBarNav();
			form.y = 10;
			form.x = 20;
			form.padding = 5;
			form.width = 980;
			form.height = 680
			this.addChild(form);
			form.creationPolicy = ASComponentConst.creationPolicy_none;
			
			tab5 = new TweenExplorerPopwinTab5();
			tab5.label = "colorTransform"
			form.addChild(tab5);
			
			tab1 = new TweenExplorerPopwinTab1();
			tab1.label = "tween展示"
			form.addChild(tab1);
			
			tab2 = new TweenExplorerPopwinTab2();
			tab2.label = "Matrix"
			form.addChild(tab2);
			
			tab3 = new TweenExplorerPopwinTab3();
			tab3.label = "Draw"
			form.addChild(tab3);
			
			tab4 = new TweenExplorerPopwinTab4();
			tab4.label = "flexComp"
			form.addChild(tab4);
			
			form.selectedIndex = 0;
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 1000;
			opts.minimizable = true
			opts.maximizable = true
			opts.height = 700;
			opts.title = "TweenExplorer"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.TweenExplorerPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new TweenExplorerPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(TweenExplorerPopwinMediator.NAME)
		}
		
	}
}
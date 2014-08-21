package com.editor.popup2.texturepacker.view
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.model.PopupwinSign;
	import com.editor.popup2.texturepacker.mediator.JointModuleMediator;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;

	public class JointModule extends AppPopupWithEmptyWin
	{
		public function JointModule()
		{
			super();
			
			width = 1050;
			height = 700;
			
			toolBar = new JointModuleToolBar();
			addChild(toolBar);
			
			lib = new JointModuleLib();
			addChild(lib);
			
			preview = new JointModulePreview();
			addChild(preview);
			
			initComplete();
		}
		
		public var toolBar:JointModuleToolBar;
		public var preview:JointModulePreview;
		public var lib:JointModuleLib;
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.minimizable = true
			opts.type = NativeWindowType.NORMAL
			opts.width = 1050;
			opts.height = 700;
			opts.title = "texturepacker"	
			return opts;
		}
		
		override protected function __init__() : void
		{
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.JointModule_sign;
			isModel    		= false;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new JointModuleMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(JointModuleMediator.NAME);
		}
		
	}
}
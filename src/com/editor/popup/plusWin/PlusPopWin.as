package com.editor.popup.plusWin
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UILoader;
	import com.editor.data.SandyEditorPlugData;
	import com.editor.interfac.ISandyEditorPlug;
	import com.editor.model.AppMainModel;
	import com.editor.model.PopupwinSign;
	import com.editor.modules.app.view.main.AppMainPopupContainerMediator;
	import com.editor.services.Services;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.editor.vo.plus.PlusItemVO;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.module.SandyLoadModuleContainer;
	import com.sandy.module.SandyloadModule;
	
	import flash.display.NativeWindowType;
	import flash.events.Event;

	public class PlusPopWin extends SandyLoadModuleContainer
	{
		public function PlusPopWin()
		{
			super()
			create_init();
		}
		
		public var plusCont:UICanvas;
		
		public static var api_multitonKey:String;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			popupwinMangerMediatorName = AppMainPopupContainerMediator.NAME;
			
			plusCont = new UICanvas();
			plusCont.mouseChildren = true;
			plusCont.mouseEnabled = true
			plusCont.enabledPercentSize = true;
			addChild(plusCont);
			
			initComplete()
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			return airOpts;
		}
		
		private var airOpts:AIRPopOptions;
		private var plusItem:PlusItemVO;
		private var loader:SandyloadModule;
		
		public function setItem(plu:PlusItemVO):void
		{
			plusItem = plu;
			
			airOpts = new AIRPopOptions();
			airOpts.type 	= NativeWindowType.NORMAL
			airOpts.width 	= plusItem.width+10;
			airOpts.height 	= plusItem.height+20
			airOpts.title 	= plusItem.name;
			airOpts.minimizable = true;
			
			createNativeWindow(airOpts);
			
			loader = new SandyloadModule();
			loader.mouseChildren = true;
			loader.mouseEnabled = false
			loader.complete_fun = loaderComplete;
			loader.load(Services.plus_fold_url+plusItem.url+"?"+plusItem.version,false,true);
			plusCont.addChild(loader);
		}
		
		private function loaderComplete():void
		{
			var d:SandyEditorPlugData = new SandyEditorPlugData();
			d.iManager 		= iManager;
			d.userInfo 		= AppMainModel.getInstance().user;
			d.fabricator 	= SandyEngineGlobal.fabricator;
			d.callBack_f	= plusCallBack
			 
			ISandyEditorPlug(loader.content).startUp(d);
		}
		
		private function plusCallBack(obj:SandyEditorPlugData):void
		{
			if(plusItem.name == "editor_api"){
				api_multitonKey = obj.plus_multitonKey;
			}
		}
		
		override protected function closeHandler(e:Event=null):void
		{
			ISandyEditorPlug(loader.content).moduleDispose();
			loader.unload();
			loader = null;
		}
		
	}
}
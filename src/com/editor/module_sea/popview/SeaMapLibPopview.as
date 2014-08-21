package com.editor.module_sea.popview
{
	import com.editor.component.controls.UIVlist;
	import com.editor.module_mapIso.popview.MapIsoPopViewBase;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.mediator.SeaMapContentMediator;
	import com.editor.module_sea.popview.component.SeaMapLibPopviewItemRenderer;
	import com.editor.module_sea.vo.SeaMapItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class SeaMapLibPopview extends MapIsoPopViewBase
	{
		public function SeaMapLibPopview()
		{
			super();
			if(instance == null){
				instance = this;
			}
		}
		
		override protected function get titles():String
		{
			return "资源库";	
		}
		
		public static var instance:SeaMapLibPopview;
		
		private var vbox:UIVlist;
		
		override protected function create_init():void
		{
			width = 225;
			height = 300;
			super.create_init();
			
			vbox = new UIVlist();
			vbox.enabeldSelect = true;
			vbox.enabledPercentSize = true;
			vbox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			vbox.doubleClickEnabled = true;
			vbox.itemRenderer = SeaMapLibPopviewItemRenderer
			addContent(vbox);
			vbox.addEventListener(ASEvent.CHANGE,onDoubleClick);
		}
		
		public function reflashMapInfo():void
		{
			if(!visible) return ;
			var a:Array = SeaMapModuleManager.mapData.libs_ls;
			vbox.labelField = "name1"
			vbox.dataProvider = a;
		}
		
		private function onDoubleClick(e:ASEvent):void
		{
			if(e.isDoubleClick){
				get_SeaMapContentMediator().selectItem(e.addData as SeaMapItemVO);
			}
		}
		
		private function get_SeaMapContentMediator():SeaMapContentMediator
		{
			return iManager.retrieveMediator(SeaMapContentMediator.NAME) as SeaMapContentMediator;
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			reflashMapInfo()
		}
	}
}
package com.editor.module_sea.popview
{
	import com.editor.component.controls.UIVlist;
	import com.editor.module_mapIso.popview.MapIsoPopViewBase;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.mediator.SeaMapContentMediator;
	import com.editor.module_sea.popview.component.SeaMapResListItemRenderer;
	import com.editor.module_sea.vo.SeaMapItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.geom.Point;

	public class SeaMapResListPopview extends MapIsoPopViewBase
	{
		public function SeaMapResListPopview()
		{
			super();
			if(instance == null){
				instance = this;
			}
		}
		
		override protected function get titles():String
		{
			return "物体列表";	
		}
		
		public static var instance:SeaMapResListPopview;
		
		private var vbox:UIVlist;
		
		override protected function create_init():void
		{
			width = 250;
			height = 300;
			super.create_init();
			
			vbox = new UIVlist();
			vbox.enabeldSelect = true;
			vbox.enabledPercentSize = true;
			vbox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			vbox.doubleClickEnabled = true;
			vbox.itemRenderer = SeaMapResListItemRenderer
			addContent(vbox);
			vbox.addEventListener(ASEvent.CHANGE,onDoubleClick);
		}
		
		public function reflashMapInfo():void
		{
			if(!visible) return ;
			var a:Array = SeaMapModuleManager.mapData.getItemList();
			vbox.labelField = "name2"
			vbox.dataProvider = a;
		}
		
		private function onDoubleClick(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var d:SeaMapItemVO = (e.addData as SeaMapItemVO)
				SeaMapInfoPopview.instance.setMapItem(d.container);
				if(d.container == null) return ;
				var pt:Point = new Point();
				pt.x = -d.container.x+150;
				pt.y = -d.container.y+150;
				get_SeaMapContentMediator().setMapEditCanvasLoc(pt);
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
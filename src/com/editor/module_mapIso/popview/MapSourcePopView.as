package com.editor.module_mapIso.popview
{
	import com.editor.component.controls.UIVlist;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_mapIso.popview.component.MapSourcePopItemRenderer;
	import com.editor.module_mapIso.view.items.Building;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class MapSourcePopView extends MapIsoPopViewBase
	{
		public function MapSourcePopView()
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
		
		public static var instance:MapSourcePopView;
		
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
			//vbox.doubleClickEnabled = true;
			vbox.itemRenderer = MapSourcePopItemRenderer;
			addContent(vbox);
			vbox.addEventListener(ASEvent.CHANGE,onDoubleClick);
		}
		
		public function reflashMapInfo():void
		{
			if(!visible) return ;
			var a:Array = MapEditorIsoManager.buildingLayer.buildingArray.toArray();
			vbox.labelField = "getVBoxId"
			vbox.dataProvider = a;
		}
		
		private function onDoubleClick(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var bld:Building = e.addData as Building;
				MapSourceInfoPopView.instance.showUI(bld);
			}
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			reflashMapInfo()
		}
	}
}
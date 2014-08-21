package com.editor.module_sea.popview
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIVlist;
	import com.editor.module_mapIso.popview.MapIsoPopViewBase;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.mediator.SeaMapContentMediator;
	import com.editor.module_sea.popview.component.SeaMapLevelItemRenderer;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.events.MouseEvent;

	public class SeaMapLevelPopview extends MapIsoPopViewBase
	{
		public function SeaMapLevelPopview()
		{
			super();
			if(instance == null){
				instance = this;
			}
		}
		
		override protected function get titles():String
		{
			return "层次";	
		}
		
		public static var instance:SeaMapLevelPopview;
		
		private var vbox:UIVlist;
		private var addBtn:UIButton;
		
		override protected function create_init():void
		{
			width = 240;
			height = 300;
			super.create_init();
			contentVB.verticalGap = 3;
			
			vbox = new UIVlist();
			vbox.enabeldSelect = true;
			vbox.enabledPercentSize = true;
			vbox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			//vbox.doubleClickEnabled = true;
			vbox.itemRenderer = SeaMapLevelItemRenderer
			addContent(vbox);
			vbox.addEventListener(ASEvent.CHANGE,onDoubleClick);
			
			addBtn = new UIButton();
			addBtn.label = "add"
			addBtn.addEventListener(MouseEvent.CLICK , onAddClick);
			addContent(addBtn);
		}
		
		private function onAddClick(e:MouseEvent):void
		{
			get_SeaMapContentMediator().createLevel(SeaMapModuleManager.mapData.createNewLevel());
			reflashMapInfo()
		}
		
		public function reflashMapInfo():void
		{
			if(!visible) return ;
			
			var a:Array = SeaMapModuleManager.mapData.level_ls;
			vbox.labelField = "name"
			vbox.dataProvider = a.sortOn("container_index",Array.NUMERIC|Array.DESCENDING);
			SeaMapModuleManager.mapData.sortLevel();
		}
		
		private function onDoubleClick(e:ASEvent):void
		{
			/*if(e.isDoubleClick){
			var bld:Building = e.addData as Building;
			
			MapSourceInfoPopView.instance.showUI(bld);
			}*/
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			reflashMapInfo()
		}
		
		private function get_SeaMapContentMediator():SeaMapContentMediator
		{
			return iManager.retrieveMediator(SeaMapContentMediator.NAME) as SeaMapContentMediator;
		}
	}
}
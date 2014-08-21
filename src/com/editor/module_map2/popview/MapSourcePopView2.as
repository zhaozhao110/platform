package com.editor.module_map2.popview
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIVlist;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map2.manager.MapEditor2Manager;
	import com.editor.module_map2.mediator.MapEditor2BottomContainerMediator;
	import com.editor.module_map2.popview.component.MapSourcePopItemRenderer2;
	import com.editor.module_map2.proxy.MapEditorProxy2;
	import com.editor.module_map2.view.items.Building2;
	import com.editor.module_mapIso.popview.MapIsoPopViewBase;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class MapSourcePopView2 extends MapIsoPopViewBase
	{
		public function MapSourcePopView2()
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
		
		public static var instance:MapSourcePopView2;
		
		private var vbox:UIVlist;
		private var addBtn:UIButton;
				
		override protected function create_init():void
		{
			width = 225;
			height = 300;
			super.create_init();
			
			addBtn = new UIButton();
			addBtn.label = "添加资源"
			addBtn.addEventListener(MouseEvent.CLICK , onAddBtnClick);
			addContent(addBtn);
			
			vbox = new UIVlist();
			vbox.enabeldSelect = true;
			vbox.enabledPercentSize = true;
			vbox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			//vbox.doubleClickEnabled = true;
			vbox.itemRenderer = MapSourcePopItemRenderer2;
			addContent(vbox);
			vbox.addEventListener(ASEvent.CHANGE,onDoubleClick);
		}
		
		public function reflashMapInfo():void
		{
			if(!visible) return ;
			var a:Array = MapEditor2Manager.buildingLayer.buildingArray.toArray();
			vbox.labelField = "getVBoxId"
			vbox.dataProvider = a;
		}
		
		private function onDoubleClick(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var bld:Building2 = e.addData as Building2;
				MapSourceInfoPopView2.instance.showUI(bld);
			}
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			reflashMapInfo()
		}
		
		private function onAddBtnClick(e:MouseEvent):void
		{
			var popVo:SelectEditPopWinVO = new SelectEditPopWinVO();
			popVo.data = get_MapEditorIsoProxy().resInfo_ls.group_ls;
			popVo.column2_dataField = "name1"
			popVo.select_dataField = "item_ls"
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
			dat.data = popVo;
			dat.callBackFun = selectedResCallBack
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			iManager.iPopupwin.openPopupwin(dat);
		}
		
		private function selectedResCallBack(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			get_MapEditor2BottomContainerMediator().startAddBuild(item);
		}
		
		private function get_MapEditorIsoProxy():MapEditorProxy2
		{
			return iManager.retrieveProxy(MapEditorProxy2.NAME) as MapEditorProxy2;
		}
		
		private function get_MapEditor2BottomContainerMediator():MapEditor2BottomContainerMediator
		{
			return iManager.retrieveMediator(MapEditor2BottomContainerMediator.NAME) as MapEditor2BottomContainerMediator;
		}
		
	}
}
package com.editor.module_map.mediator
{
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.UIModule2Mediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.MapEditorModule;
	import com.editor.module_map.manager.MapEditorManager;
	import com.editor.module_map.mediator.left.MapEditorLeftContainerMediator;
	import com.editor.module_map.mediator.right.MapEditorRightContainerMediator;
	import com.editor.module_map.mediator.top.MapEditorToolBarMediator;
	import com.editor.module_map.proxy.MapEditorProxy;
	import com.editor.module_map.view.left.MapEditorLeftContainer;
	import com.editor.module_map.view.right.MapEditorRightContainer;
	import com.editor.module_map.view.top.MapEditorToolBar;
	import com.editor.module_map.vo.MapEditorConfigVO;
	import com.editor.module_map.vo.dict.MapDictListVO;
	import com.editor.module_map.vo.map.AppMapDefineListVO;
	import com.editor.module_map.vo.map.MapResConfigListVO;
	import com.editor.module_map.vo.project.MapEditorProjectItemVO;
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.modules.common.layout2.AppLayout2Container;
	import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
	import com.editor.services.Services;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	
	import flash.utils.setTimeout;
	
	import theme.main;
	
	public class MapEditorModuleMediator extends UIModule2Mediator
	{
		public static const NAME:String = "MapEditorModuleMediator"
		public function MapEditorModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():MapEditorModule
		{
			return viewComponent as MapEditorModule;
		}
		public function get topToolBar():MapEditorToolBar
		{
			return mainUI.topToolBar;
		}
		public function get leftContainer():MapEditorLeftContainer
		{
			return mainUI.leftContainer;
		}
		public function get rightContainer():MapEditorRightContainer
		{
			return mainUI.rightContainer;
		}
		override protected function getStackType():int
		{
			return DataManager.stack_map;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerProxy(new MapEditorProxy());
			registerMediator(new MapEditorToolBarMediator(topToolBar));
			registerMediator(new MapEditorLeftContainerMediator(leftContainer));
			registerMediator(new MapEditorRightContainerMediator(rightContainer));
			
			openSelectProject();
		}
		
		public function openSelectProject():void
		{
			var obj:SelectProjectPopwinVO = new SelectProjectPopwinVO;
			obj.data = MapEditorConfigVO.instance.project_ls.list
			obj.labelField = "name";
			obj.callFun = selectProjectCallBackFun
			sendAppNotification(AppEvent.selectProject_event,obj);
		}
		
		private function selectProjectCallBackFun(item:MapEditorProjectItemVO):void
		{
			MapEditorManager.currProject = item;
			(retrieveMediator(MapEditorToolBarMediator.NAME) as MapEditorToolBarMediator).infoTxt.htmlText = "当前选中项目： <font color='#00CC00'><b>" + MapEditorManager.currProject.name + "</b></font>";
			loadXML();
		}
		
		
		
		private function loadXML():void
		{
			var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();
			
			var item:MapEditorProjectItemVO = MapEditorManager.currProject;
			
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			var mapDefine_xml_url:String = item.xml_ls.getItemByKey(Services.mapDefine_xml_url).info;
			var mapRes_xml_url:String = item.xml_ls.getItemByKey(Services.mapRes_xml_url).info;
			
			addLog2("load xml: " + resource_xml_url);
			addLog2("load xml: " + dict_xml_url);
			addLog2("load xml: " + mapDefine_xml_url);
			addLog2("load xml: " + mapRes_xml_url);
			
			mutltLoadData.addXMLData(iResource.getLoadSourceData(resource_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			mutltLoadData.addXMLData(iResource.getLoadSourceData(dict_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			mutltLoadData.addXMLData(iResource.getLoadSourceData(mapDefine_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			mutltLoadData.addXMLData(iResource.getLoadSourceData(mapRes_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			
			var dt:ILoadQueueDataProxy = iResource.getLoadQueueDataProxy();
			dt.multSourceData = mutltLoadData;
			dt.allLoadComplete_f = loadXMLComplete;
			iResource.loadMultResource(dt);
		}
		
		private function loadXMLComplete(e:*=null):void
		{
			var item:MapEditorProjectItemVO = MapEditorManager.currProject;
			
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			var mapDefine_xml_url:String = item.xml_ls.getItemByKey(Services.mapDefine_xml_url).info;
			var mapRes_xml_url:String = item.xml_ls.getItemByKey(Services.mapRes_xml_url).info;
			
			get_MapEditorProxy().dictList = new RoleEditDictListVO(XML(iCacheManager.getCompleteLoadSource(dict_xml_url)));
			get_MapEditorProxy().resInfo_ls = new AppResInfoListVO(XML(iCacheManager.getCompleteLoadSource(resource_xml_url)));
			get_MapEditorProxy().mapDefine = new AppMapDefineListVO(XML(iCacheManager.getCompleteLoadSource(mapDefine_xml_url)));
			get_MapEditorProxy().mapRes = new MapResConfigListVO(XML(iCacheManager.getCompleteLoadSource(mapRes_xml_url)));
		}
		
		private function get_MapEditorProxy():MapEditorProxy
		{
			return retrieveProxy(MapEditorProxy.NAME) as MapEditorProxy;
		}
		
		/**场景加载开始事件**/
		public function respondToMapEditorLoadingStartEvent(noti:Notification):void
		{
			mainUI.leftContainer.mouseChildren = false;
			mainUI.rightContainer.mouseChildren = false;
		}
		/**场景加载成功事件**/
		public function respondToMapEditorLoadingCompleteEvent(noti:Notification):void
		{
			mainUI.leftContainer.mouseChildren = true;
			mainUI.rightContainer.mouseChildren = true;
		}
		
		
	}
}
package com.editor.module_map2.mediator
{
	import com.editor.component.LogContainer;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.UIModule2Mediator;
	import com.editor.module_map.vo.map.AppMapDefineListVO;
	import com.editor.module_map.vo.map.MapResConfigListVO;
	import com.editor.module_map.vo.project.MapEditorProjectItemVO;
	import com.editor.module_map2.MapEditor2Module;
	import com.editor.module_map2.manager.MapEditor2Manager;
	import com.editor.module_map2.proxy.MapEditorProxy2;
	import com.editor.module_map2.view.MapEditor2BottomContainer;
	import com.editor.module_map2.view.MapEditor2TopContainer;
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
	import com.editor.services.Services;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;

	public class MapEditor2ModuleMediator extends AppMediator
	{
		public static const NAME:String = "MapEditor2ModuleMediator";
		public function MapEditor2ModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():MapEditor2Module
		{
			return viewComponent as MapEditor2Module;
		}
		public function get topToolBar():MapEditor2TopContainer
		{
			return mainUI.topToolBar;
		}
		public function get botContainer():MapEditor2BottomContainer
		{
			return mainUI.botContainer;
		}
		public function get logContainer():LogContainer
		{
			return mainUI.logContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			MapEditor2Manager.moduleMediator = this;
			
			registerProxy(new MapEditorProxy2());
			registerMediator(new MapEditor2TopContainerMediator(topToolBar));
			registerMediator(new MapEditor2BottomContainerMediator(botContainer));
						
			openSelectProject();
		}
		
		public function openSelectProject():void
		{
			var obj:SelectProjectPopwinVO = new SelectProjectPopwinVO;
			var m:MapEditor2Manager = MapEditor2Manager.getInstance()
			obj.data = m.project_ls.list
			obj.labelField = "name";
			obj.callFun = selectProjectCallBackFun;
			sendAppNotification(AppEvent.selectProject_event,obj);
		}
		
		private function selectProjectCallBackFun(item:MapEditorProjectItemVO):void
		{
			MapEditor2Manager.currProject = item;
			(retrieveMediator(MapEditor2TopContainerMediator.NAME) as MapEditor2TopContainerMediator).infoTxt.htmlText = "当前选中项目： <font color='#00CC00'><b>" + MapEditor2Manager.currProject.name + "</b></font>";
			loadXML();
		}
		
		public function addLog2(s:String):void
		{
			logContainer.addLog(s);
		}
		
		private function loadXML():void
		{
			var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();
			
			var item:MapEditorProjectItemVO = MapEditor2Manager.currProject;
			
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
			var item:MapEditorProjectItemVO = MapEditor2Manager.currProject;
			
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			var mapDefine_xml_url:String = item.xml_ls.getItemByKey(Services.mapDefine_xml_url).info;
			var mapRes_xml_url:String = item.xml_ls.getItemByKey(Services.mapRes_xml_url).info;
			
			get_MapEditorIsoProxy().dictList = new RoleEditDictListVO(XML(iCacheManager.getCompleteLoadSource(dict_xml_url)));
			get_MapEditorIsoProxy().resInfo_ls = new AppResInfoListVO(XML(iCacheManager.getCompleteLoadSource(resource_xml_url)));
			get_MapEditorIsoProxy().mapDefine = new AppMapDefineListVO(XML(iCacheManager.getCompleteLoadSource(mapDefine_xml_url)));
			get_MapEditorIsoProxy().mapRes = new MapResConfigListVO(XML(iCacheManager.getCompleteLoadSource(mapRes_xml_url)));
		}
		
		private function get_MapEditorIsoProxy():MapEditorProxy2
		{
			return retrieveProxy(MapEditorProxy2.NAME) as MapEditorProxy2;
		}
		
		
		
	}
}
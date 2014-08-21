package com.editor.module_mapIso.mediator
{
	import com.editor.component.LogContainer;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.UIModule2Mediator;
	import com.editor.module_map.vo.map.AppMapDefineListVO;
	import com.editor.module_map.vo.map.MapResConfigListVO;
	import com.editor.module_map.vo.project.MapEditorProjectItemVO;
	import com.editor.module_mapIso.MapEditorIsoModule;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_mapIso.proxy.MapEditorIsoProxy;
	import com.editor.module_mapIso.view.MapEditorIsoTopContainer;
	import com.editor.module_mapIso.view.MapIsoBottomContainer;
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
	import com.editor.services.Services;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;

	public class MapEditorIsoModuleMediator extends AppMediator
	{
		public static const NAME:String = "MapEditorIsoModuleMediator";
		public function MapEditorIsoModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():MapEditorIsoModule
		{
			return viewComponent as MapEditorIsoModule;
		}
		public function get topToolBar():MapEditorIsoTopContainer
		{
			return mainUI.topToolBar;
		}
		public function get botContainer():MapIsoBottomContainer
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
			
			MapEditorIsoManager.moduleMediator = this;
			
			registerProxy(new MapEditorIsoProxy());
			registerMediator(new MapEditorIsoTopContainerMediator(topToolBar));
			registerMediator(new MapIsoBottomContainerMediator(botContainer));
						
			openSelectProject();
		}
		
		public function openSelectProject():void
		{
			var obj:SelectProjectPopwinVO = new SelectProjectPopwinVO;
			var m:MapEditorIsoManager = MapEditorIsoManager.getInstance()
			obj.data = m.project_ls.list
			obj.labelField = "name";
			obj.callFun = selectProjectCallBackFun;
			sendAppNotification(AppEvent.selectProject_event,obj);
		}
		
		private function selectProjectCallBackFun(item:MapEditorProjectItemVO):void
		{
			MapEditorIsoManager.currProject = item;
			(retrieveMediator(MapEditorIsoTopContainerMediator.NAME) as MapEditorIsoTopContainerMediator).infoTxt.htmlText = "当前选中项目： <font color='#00CC00'><b>" + MapEditorIsoManager.currProject.name + "</b></font>";
			loadXML();
		}
		
		public function addLog2(s:String):void
		{
			logContainer.addLog(s);
		}
		
		private function loadXML():void
		{
			var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();
			
			var item:MapEditorProjectItemVO = MapEditorIsoManager.currProject;
			
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
			var item:MapEditorProjectItemVO = MapEditorIsoManager.currProject;
			
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			var mapDefine_xml_url:String = item.xml_ls.getItemByKey(Services.mapDefine_xml_url).info;
			var mapRes_xml_url:String = item.xml_ls.getItemByKey(Services.mapRes_xml_url).info;
			
			get_MapEditorIsoProxy().dictList = new RoleEditDictListVO(XML(iCacheManager.getCompleteLoadSource(dict_xml_url)));
			get_MapEditorIsoProxy().resInfo_ls = new AppResInfoListVO(XML(iCacheManager.getCompleteLoadSource(resource_xml_url)));
			get_MapEditorIsoProxy().mapDefine = new AppMapDefineListVO(XML(iCacheManager.getCompleteLoadSource(mapDefine_xml_url)));
			get_MapEditorIsoProxy().mapRes = new MapResConfigListVO(XML(iCacheManager.getCompleteLoadSource(mapRes_xml_url)));
		}
		
		private function get_MapEditorIsoProxy():MapEditorIsoProxy
		{
			return retrieveProxy(MapEditorIsoProxy.NAME) as MapEditorIsoProxy;
		}
		
		
		
	}
}
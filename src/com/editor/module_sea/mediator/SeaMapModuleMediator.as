package com.editor.module_sea.mediator
{
	import com.editor.component.controls.UILoader;
	import com.editor.event.AppEvent;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	import com.editor.module_roleEdit.vo.RoleEditConfigVO;
	import com.editor.module_sea.SeaMapModule;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.proxy.SeaMapModuleProxy;
	import com.editor.module_sea.view.SeaMapContent;
	import com.editor.module_sea.view.SeaMapModuleTopContainer;
	import com.editor.module_sea.view.SeaMapWave;
	import com.editor.module_sea.vo.SeaMapConfigVO;
	import com.editor.module_sea.vo.dict.SeaMapDictListVO;
	import com.editor.module_sea.vo.project.SeaMapProjectItemVO;
	import com.editor.module_sea.vo.res.SeaMapResInfoListVO;
	import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
	import com.editor.services.Services;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.LoadQueueEvent;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	
	import flash.display.Bitmap;

	public class SeaMapModuleMediator extends AppMediator
	{
		public static const NAME:String = "SeaMapModuleMediator";
		public function SeaMapModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():SeaMapModule
		{
			return viewComponent as SeaMapModule;
		}
		public function get topContainer():SeaMapModuleTopContainer
		{
			return mainUI.topContainer;
		}
		public function get cont():SeaMapContent
		{
			return mainUI.cont;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			mainUI.rightClickEnabled = true
			
			registerProxy(new SeaMapModuleProxy());
			
			registerMediator(new SeaMapContentMediator(cont))
			registerMediator(new SeaMapModuleTopContainerMediator(topContainer))
					
			openSelectProject();
			loadWave()
		}
				
		private function loadWave():void
		{
			var ld:UILoader = new UILoader();
			ld.complete_fun = loadWaveComplete;
			ld.load("http://192.168.0.4:11111/haishui.png");
		}
		
		private function loadWaveComplete(b:Bitmap):void
		{
			SeaMapWave.waveBitmap = b;	
			
		}
		
		private function openSelectProject():void
		{
			var obj:SelectProjectPopwinVO = new SelectProjectPopwinVO;
			obj.data = SeaMapConfigVO.instance.project_ls.list
			obj.labelField = "name";
			obj.callFun = selectProjectCallBackFun
			sendAppNotification(AppEvent.selectProject_event,obj);
		}
		
		private function selectProjectCallBackFun(item:SeaMapProjectItemVO):void
		{
			SeaMapModuleManager.currProject = item;
			
			get_SeaMapModuleTopContainerMediator().infoTxt.text = "选中项目： " + item.name;
			loadXML();
		}
		
		private function get_SeaMapModuleTopContainerMediator():SeaMapModuleTopContainerMediator
		{
			return retrieveMediator(SeaMapModuleTopContainerMediator.NAME) as SeaMapModuleTopContainerMediator;
		}
		
		override public function show():void
		{
			loadXML();
		}
		
		public function loadXML():void
		{
			var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();
			
			var item:SeaMapProjectItemVO = SeaMapModuleManager.currProject as SeaMapProjectItemVO;
			if(item == null) return ;
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			
			if(get_SeaMapModuleProxy().resInfo_ls == null){
				SeaMapModuleManager.logCont.addLog("load xml: " + resource_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(resource_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(get_SeaMapModuleProxy().dict_ls == null){
				SeaMapModuleManager.logCont.addLog("load xml: " + dict_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(dict_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			
			var dt:ILoadQueueDataProxy = iResource.getLoadQueueDataProxy();
			dt.multSourceData = mutltLoadData;
			dt.allLoadComplete_f = loadAllComplete;
			iResource.loadMultResource(dt);
		}
		
		private function loadAllComplete(e:LoadQueueEvent):void
		{
			var item:SeaMapProjectItemVO = SeaMapModuleManager.currProject as SeaMapProjectItemVO;
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			
			if(get_SeaMapModuleProxy().dict_ls == null){
				get_SeaMapModuleProxy().dict_ls = new SeaMapDictListVO(XML(iCacheManager.getCompleteLoadSource(dict_xml_url)));
			}
			if(get_SeaMapModuleProxy().resInfo_ls == null){
				get_SeaMapModuleProxy().resInfo_ls = new SeaMapResInfoListVO(XML(iCacheManager.getCompleteLoadSource(resource_xml_url)));
			}
			
		}
		
		private function get_SeaMapModuleProxy():SeaMapModuleProxy
		{
			return retrieveProxy(SeaMapModuleProxy.NAME) as SeaMapModuleProxy;
		}
		
		private function get_SeaMapContentMediator():SeaMapContentMediator
		{
			return retrieveMediator(SeaMapContentMediator.NAME) as SeaMapContentMediator;
		}
		
	}
}
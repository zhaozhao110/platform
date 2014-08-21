package com.editor.module_roleEdit.mediator
{
    import com.editor.component.controls.UILoader;
    import com.editor.event.AppEvent;
    import com.editor.manager.XMLCacheManager;
    import com.editor.mediator.AppMediator;
    import com.editor.model.AppMainModel;
    import com.editor.model.OpenPopwinData;
    import com.editor.model.PopupwinSign;
    import com.editor.module_roleEdit.PeopleImageModule;
    import com.editor.module_roleEdit.event.RoleEditEvent;
    import com.editor.module_roleEdit.facade.PeopleImageBindingData;
    import com.editor.module_roleEdit.manager.RoleEditManager;
    import com.editor.module_roleEdit.proxy.PeopleImageProxy;
    import com.editor.module_roleEdit.view.PeopleImageContent;
    import com.editor.module_roleEdit.vo.RoleEditConfigVO;
    import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
    import com.editor.module_roleEdit.vo.motion.AppMotionListVO;
    import com.editor.module_roleEdit.vo.project.RoleEditProjectItemVO;
    import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
    import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
    import com.editor.services.Services;
    import com.sandy.popupwin.data.OpenPopByAirOptions;
    import com.sandy.resource.LoadQueueConst;
    import com.sandy.resource.LoadQueueEvent;
    import com.sandy.resource.interfac.ILoadMultSourceData;
    import com.sandy.resource.interfac.ILoadQueueDataProxy;
    import com.sandy.utils.LoadContextUtils;
    
    import flash.events.KeyboardEvent;
    import flash.net.URLRequest;
    import flash.ui.Keyboard;
    import flash.utils.setTimeout;

    public class PeopleImageModuleMediator extends AppMediator
    {        
		public static const NAME:String = "PeopleImageModuleMediator"
        public function PeopleImageModuleMediator(viewComponent:Object = null)
        {
            super(NAME, viewComponent);
        }
        public function get peopleImageModule():PeopleImageModule
        {
            return viewComponent as PeopleImageModule;
		}
        public function get popContent():PeopleImageContent
        {
            return peopleImageModule.popContent;
        }
		
		
        [InjectProxy(name = "PeopleImageProxy")]
        public var imageProxy:PeopleImageProxy;
		
		private var motion_ld:UILoader = new UILoader();

        override public function onRegister():void
        {
            super.onRegister();
			
			RoleEditManager.init();
						
			registerProxy(new PeopleImageProxy());

            registerMediator(new PeopleImageContentMediator(popContent))

            openSelectProject();
			
			XMLCacheManager.add(Services.motion_xml_url,PeopleImageModule.MODULENAME);
        }
		
		private function openSelectProject():void
		{
			var obj:SelectProjectPopwinVO = new SelectProjectPopwinVO;
			obj.data = RoleEditConfigVO.instance.project_ls.list
			obj.labelField = "name";
			obj.callFun = selectProjectCallBackFun
			sendAppNotification(AppEvent.selectProject_event,obj);
		}
		
		private function selectProjectCallBackFun(item:RoleEditProjectItemVO):void
		{
			RoleEditManager.currProject = item;
			PeopleImageBindingData.getInstance().init();
			get_PeopleImageToolBarMediator().infoTxt.text = "选中项目： " + item.name;
			loadXML();
		}
		
		private function get_PeopleImageToolBarMediator():PeopleImageToolBarMediator
		{
			return retrieveMediator(PeopleImageToolBarMediator.NAME) as PeopleImageToolBarMediator;
		}
		
		override public function show():void
		{
			loadXML();
		}
		
        public function loadXML():void
        {
            var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();

			var item:RoleEditProjectItemVO = RoleEditManager.currProject as RoleEditProjectItemVO;
			if(item == null) return ;
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
					
			if(imageProxy.resInfo_ls == null){
				sendAppNotification(RoleEditEvent.roleEdit_addLog_event,"load xml: " + resource_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(resource_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(imageProxy.dictList == null){
				sendAppNotification(RoleEditEvent.roleEdit_addLog_event,"load xml: " + dict_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(dict_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
            
            var dt:ILoadQueueDataProxy = iResource.getLoadQueueDataProxy();
            dt.multSourceData = mutltLoadData;
            dt.allLoadComplete_f = loadAllComplete;
            iResource.loadMultResource(dt);
        }
		
        private function loadAllComplete(e:LoadQueueEvent):void
        {
			var item:RoleEditProjectItemVO = RoleEditManager.currProject as RoleEditProjectItemVO;
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;

			if(imageProxy.dictList == null){
            	imageProxy.dictList = new RoleEditDictListVO(XML(iCacheManager.getCompleteLoadSource(dict_xml_url)));
			}
			if(imageProxy.resInfo_ls == null){
            	imageProxy.resInfo_ls = new AppResInfoListVO(XML(iCacheManager.getCompleteLoadSource(resource_xml_url)));
			}
            			
			if(imageProxy.motion_ls == null || XMLCacheManager.getXML(Services.motion_xml_url).checkChange(PeopleImageModule.MODULENAME)){
				sendAppNotification(RoleEditEvent.roleEdit_addLog_event,"load xml: " + item.xml_ls.getItemByKey(Services.motion_xml_url).info);
				motion_ld.ioError_fun = loadXMLComplete;
				motion_ld.complete_fun = loadXMLComplete;
				motion_ld.load(item.xml_ls.getItemByKey(Services.motion_xml_url).info)
			}
        }
		
		public function reflashMotionXML():void
		{
			var item:RoleEditProjectItemVO = RoleEditManager.currProject as RoleEditProjectItemVO;
			if(item!=null){
				motion_ld.load(item.xml_ls.getItemByKey(Services.motion_xml_url).info+"?"+Math.random())
			}
		}
		
		private function loadXMLComplete(e:*=null):void
		{
			var x:XML = XML(motion_ld.content);
			imageProxy.motion_ls = new AppMotionListVO(x);
			XMLCacheManager.getXML(Services.motion_xml_url).noChange(PeopleImageModule.MODULENAME)
		}
		
    }
}

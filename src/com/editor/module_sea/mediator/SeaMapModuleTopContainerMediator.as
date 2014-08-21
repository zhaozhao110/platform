package com.editor.module_sea.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILoader;
	import com.editor.component.controls.UIMenuBar;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.popview.SeaMapLevelPopview;
	import com.editor.module_sea.popview.SeaMapLibPopview;
	import com.editor.module_sea.popview.SeaMapMouseInfoPopView;
	import com.editor.module_sea.popview.SeaMapResListPopview;
	import com.editor.module_sea.popview.SeaMapSmallImgPopView;
	import com.editor.module_sea.proxy.SeaMapModuleProxy;
	import com.editor.module_sea.view.SeaMapModuleTopContainer;
	import com.editor.module_sea.vo.SeaMapConfigVO;
	import com.editor.module_sea.vo.SeaMapData;
	import com.editor.module_sea.vo.project.SeaMapProjectItemVO;
	import com.editor.module_sea.vo.res.SeaMapResInfoGroupVO;
	import com.editor.module_sea.vo.res.SeaMapResInfoItemVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	public class SeaMapModuleTopContainerMediator extends AppMediator
	{
		public static const NAME:String = "SeaMapModuleTopContainerMediator";
		public function SeaMapModuleTopContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():SeaMapModuleTopContainer
		{
			return viewComponent as SeaMapModuleTopContainer;
		}
		public function get visiLogButton():UIButton
		{
			return mainUI.visiLogButton;
		}
		public function get infoTxt():UILabel
		{
			return mainUI.infoTxt;
		}
		public function get infoTxt2():UILabel
		{
			return mainUI.infoTxt2;
		}
		public function get menuBar():UIMenuBar
		{
			return mainUI.menuBar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			menuBar.addEventListener(ASEvent.CHANGE,menuBarChangeHandle)
			visiLogButton.addEventListener(MouseEvent.CLICK , onLogChange);
		}
		
		private function menuBarChangeHandle(e:ASEvent):void
		{
			var dat:IASMenuButton = e.data as IASMenuButton;
			var xml:XML = dat.getMenuXML();
			var d:String = xml.@data;
			if(d == "1"){
				loadMapXML()
			}else if(d == "2"){
				addSource()
			}else if(d == "saveMapBtn"){
				saveXML();
			}else if(d == "12"){
				SeaMapSmallImgPopView.instance.visible = !SeaMapSmallImgPopView.instance.visible 
			}else if(d == "imageLibBtn"){
				SeaMapLibPopview.instance.visible = !SeaMapLibPopview.instance.visible
			}else if(d == "mouseInfoBtn"){
				SeaMapLevelPopview.instance.visible = !SeaMapLevelPopview.instance.visible
			}else if(d == "mouseInfoBtn2"){
				SeaMapMouseInfoPopView.instance.visible = !SeaMapMouseInfoPopView.instance.visible; 
			}else if(d == "mouseInfoBtn3"){
				SeaMapResListPopview.instance.visible = !SeaMapResListPopview.instance.visible 
			}
		}
		
		private function addSource():void
		{
			var out:Array = [];
			var a:Array = get_SeaMapModuleProxy().resInfo_ls.group_ls;
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(SeaMapResInfoGroupVO(a[i]).type_str)){
					out.push(a[i]);
				}
			}
			
			var vo1:SelectEditPopWinVO = new SelectEditPopWinVO();
			vo1.data = out;
			vo1.column2_dataField = "name"
			vo1.select_dataField = "item_ls"
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
			dat.data = vo1;
			dat.callBackFun = selectedSceneResCallBack2;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		
		private function selectedSceneResCallBack2(item:SeaMapResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			SeaMapModuleManager.mapData.addLibSource(item.clone());
			SeaMapLibPopview.instance.reflashMapInfo()
		}
		
		private function loadMapXML():void
		{
			var item:SeaMapProjectItemVO = SeaMapModuleManager.currProject as SeaMapProjectItemVO;
			var ld:UILoader = new UILoader();
			ld.complete_fun = loadXMLComplete;
			ld.ioError_fun = loadXMLError;
			ld.load(item.mapXML_url);
		}
		
		private function loadXMLComplete(x:String):void
		{
			var d:SeaMapData = new SeaMapData();
			d.parserXML(XML(x));
			get_SeaMapContentMediator().createNewMap(d);
		}
		
		private function loadXMLError(e:IOErrorEvent):void
		{
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SeaMapCreateMapPopwin_sign;
			dat.data = null;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		
		private function onLogChange(e:MouseEvent):void
		{
			get_SeaMapModuleMediator().mainUI.logContainer.visible = !get_SeaMapModuleMediator().mainUI.logContainer.visible; 
		}
		
		
		public var http:AS3HTTPServiceLocator;
		
		public function saveXML():void
		{
			//http://192.168.0.9:82/gdps/sub/fileData.do?m=saveConfig&srt=2&project=Palace4_cn_cn&savePath=res/res&fileName=xxx.xml&data=xxx
			if(http == null){
				http = new AS3HTTPServiceLocator();
				http.sucResult_f = confirmSuc;
			}
			
			var httpObj:URLVariables = new URLVariables();
			httpObj.m = "saveConfig"
			httpObj.srt = 2;
			httpObj.project = SeaMapModuleManager.currProject.data;
			httpObj.savePath = SeaMapModuleManager.currProject.saveFold;
			httpObj.fileName = SeaMapModuleManager.currProject.saveFileName;
			httpObj.data = SeaMapModuleManager.mapData.save();
			
			trace("save, " + httpObj.toString());
			http.args = httpObj;
			http.conn(SeaMapConfigVO.instance.serverDomain, SandyEngineConst.HTTP_POST);
		}
		
		private function confirmSuc(d:*=null):void
		{
			showMessage("保存成功");
		}
		
		private function get_SeaMapModuleMediator():SeaMapModuleMediator
		{
			return retrieveMediator(SeaMapModuleMediator.NAME) as SeaMapModuleMediator;
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
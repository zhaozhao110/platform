package com.editor.module_roleEdit.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.manager.XMLCacheManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_roleEdit.event.RoleEditEvent;
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.module_roleEdit.proxy.PeopleImageProxy;
	import com.editor.module_roleEdit.view.PeopleImageToolBar;
	import com.editor.module_roleEdit.vo.RoleEditConfigVO;
	import com.editor.module_roleEdit.vo.action.ActionData;
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.editor.services.Services;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.fabrication.IModuleFacade;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.net.json.SandyJSON;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.DataEvent;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class PeopleImageToolBarMediator extends AppMediator
	{
		public static const NAME:String = "PeopleImageToolBarMediator"
		public function PeopleImageToolBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get toolBar():PeopleImageToolBar
		{
			return viewComponent as PeopleImageToolBar;
		}
		public function get loadMotionBtn():UIButton
		{
			return toolBar.loadMotionBtn;
		}
		public function get saveBtn():UIButton
		{
			return toolBar.saveBtn;
		}
		public function get reflashBtn():UIButton
		{
			return toolBar.reflashBtn;
		}
		public function get infoTxt():UILabel
		{
			return toolBar.infoTxt;
		}
		public function get previewBtn():UIButton
		{
			return toolBar.previewBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function reactToReflashBtnClick(e:MouseEvent):void
		{
			get_PeopleImageModuleMediator().reflashMotionXML();
		}
		
		private function get_PeopleImageModuleMediator():PeopleImageModuleMediator
		{
			return retrieveMediator(PeopleImageModuleMediator.NAME) as PeopleImageModuleMediator;
		}
		
		private function get_PeopleImageProxy():PeopleImageProxy
		{
			return retrieveProxy(PeopleImageProxy.NAME) as PeopleImageProxy;
		}
		
		public function reactToLoadMotionBtnClick(e:MouseEvent):void
		{
			if(get_PeopleImageProxy().resInfo_ls == null) return ;
			var out:Array = [];
			var a:Array = get_PeopleImageProxy().resInfo_ls.group_ls;
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(AppResInfoGroupVO(a[i]).type_str)){
					out.push(a[i]);
				}
			}
			
			var vo:SelectEditPopWinVO = new SelectEditPopWinVO();
			vo.data = out;
			vo.column2_dataField = "name1"
			vo.select_dataField = "item_ls"
				
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
			dat.data = vo;
			dat.callBackFun = selectedMotion
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
				
		private function selectedMotion(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			get_PeopleImageDataGridMediator().editMotion(item);
		}
		
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			if(get_PeopleImageDataGridMediator().curr_actionData == null){
				showError("请先编辑动画的动作");
				return 
			}
			
			var resItem:AppResInfoItemVO = get_PeopleImageDataGridMediator().resItem;
			var motionItem:AppMotionItemVO = get_PeopleImageDataGridMediator().motionItem;
			
			var action_ls:Array = get_PeopleImageDataGridMediator().grid.dataProvider;
			var type:int = resItem.type;
			
			if(type == 1 || type == 2 || type == 5){// 怪物、NPC、玩家
				//物体的名称显示的坐标
				var dat:OpenPopwinData = new OpenPopwinData();
				dat.data = {"resItem" : resItem, "motionItem" : motionItem, "action_ls" : action_ls} ;
				dat.popupwinSign = PopupwinSign.PeopleImageSaveNameLocPopwin_sign;
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				dat.openByAirData = opt;
				openPopupwin(dat);
				return ;
				
			}else{
				saveToServer();
			}
		}
		
		public function saveToServer(namexy:String=""):void
		{
			var resItem:AppResInfoItemVO = get_PeopleImageDataGridMediator().resItem;
			var motionItem:AppMotionItemVO = get_PeopleImageDataGridMediator().motionItem;
			if(motionItem==null){
				showError("出错了，请重新编辑下");
				return ;
			}
			
			var action_ls:Array = get_PeopleImageDataGridMediator().grid.dataProvider;
			var type:int = resItem.type;
			
			var action_str:Array = [];
			for(var i:int=0;i<action_ls.length;i++)
			{
				var it:ActionData = action_ls[i] as ActionData;
				if(it!=null&& !StringTWLUtil.isWhitespace( it.timeline)){
					
					if(it.actionVO == null){
						it.actionVO = motionItem.getActionByType(it.type)
					}
					
					if(it.actionVO == null){
						showError("没有找到动画信息");
						return ;
					}
					
					it.actionVO.timeline = it.timeline;
					action_str.push(it.actionVO.save(resItem.totalForward));
				}
			}
			
			var httpObj:URLVariables = new URLVariables();
			httpObj.id = resItem.id;
			httpObj.namexy = namexy;
			httpObj.original = motionItem.originalPoint.getString();
			httpObj.size = motionItem.size.width+","+motionItem.size.height;
			httpObj.action = action_str.join("#");
			httpObj.srt = "2";
			httpObj.project = RoleEditManager.currProject.data;
			httpObj.savePath = RoleEditManager.currProject.saveFold;
			httpObj.fileName = RoleEditManager.currProject.saveFileName;
			
		//	get_PeopleImageDataGridMediator().addLog2("保存数据:=====>"+httpObj.action);
			
			var http:AS3HTTPServiceLocator = new AS3HTTPServiceLocator();
			http.args = httpObj;
			http.sucResult_f = confirmSuc;
			http.conn(RoleEditConfigVO.instance.serverDomain, SandyEngineConst.HTTP_POST,SandyEngineConst.resultFor_text_type);
		}
		
		private function confirmSuc(dat:*=null):void
		{
			var obj:Object = SandyJSON.decode(String(dat));
			if(obj.code == "0"){
				showError("保存成功,请等待几秒，将重新加载缓存");	
			}else{
				showError("保存失败，请停下所有工作，马上联系宋欢");
			}
			
			XMLCacheManager.getXML(Services.motion_xml_url).change();
			get_PeopleImageModuleMediator().loadXML();
		}
		
		private function saveMapFile(event:FileListEvent):void
		{
			var resItem:AppResInfoItemVO = get_PeopleImageDataGridMediator().resItem;
			if(resItem == null){
				showError("请先选择要编辑的动画");
				return ;
			}
			
			if(event.files.length > 1){
				showError("只能上传一张图");
				return ;
			}
			
			var file:File = event.files[0] as File;
			/*var url:String = "z:\\"
			
			//保存swf
			if(resItem.type == 1){
				//url += "role\\monster\\swf\\"+resItem.id+"\\"
			}else if(resItem.type == 2){
				url += "role\\npc\\map\\"
			}else if(resItem.type == 3){
				//url += "material\\swf\\"+resItem.id+"\\"
			}else if(resItem.type == 4){
				//url += "effect\\swf\\"+resItem.id+"\\"
			}else if(resItem.type == 5){
				//url += "role\\user\\swf\\"+resItem.id+"\\"
			}else if(resItem.type == 6){
				//url += "motion\\swf\\"+resItem.id+"\\"
			}
			
			url += resItem.id + ".png"
			
			var newFile:File = new File(url);
			file.copyTo(newFile,true);*/
			
			var url:String = "";
						
			//保存swf--后台保存
			if(resItem.type == 1){
				//url += "role\\monster\\swf\\"+resItem.id+"\\"
			}else if(resItem.type == 2){
				url += "role\\npc\\map\\"
			}else if(resItem.type == 3){
				//url += "material\\swf\\"+resItem.id+"\\"
			}else if(resItem.type == 4){
				//url += "effect\\swf\\"+resItem.id+"\\"
			}else if(resItem.type == 5){
				//url += "role\\user\\swf\\"+resItem.id+"\\"
			}else if(resItem.type == 6){
				//url += "motion\\swf\\"+resItem.id+"\\"
			}
			
			url += resItem.id + ".png";
			
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, saveMapFileCallback);
			submitFile(url, file);
		}
		
		private function submitFile(url:String, file:File):void
		{
			//TODO 此处的url可以从后台按钮资源中加载
			/*var _url:String = Services.uploadMapEditorPng_url;
			_url = _url + "&srt=2&projectId=" + CacheDataUtil.getProjectId() + "&menuId=" + confItem.menuId + "&jsessionid=" + CacheDataUtil.getSessionId()
				+ "&tableId=" + confItem.extend.queryTableId + "&filePath=" + url + "&tableType=" +DataManageModuleBindData.fileDataType; 
			var req:URLRequest = new URLRequest(_url);
			req.method = URLRequestMethod.POST;*/
			/*var url_dat:URLVariables = new URLVariables();
			url_dat["srt"] = "2";
			url_dat["projectId"] = CacheDataUtil.getProjectId();
			url_dat["menuId"] = confItem.menuId;
			url_dat["tableId"] = confItem.extend.queryTableId;
			url_dat["filePath"] = url;
			url_dat["tableType"] = DataManageModuleBindData.fileDataType;
			//url_dat["fileName"] = resItem.id + ".png";
			req.data = url_dat;*/
			//file.upload(req);
			
		}
		protected function saveMapFileCallback(event:DataEvent):void
		{
			showError("上传地图编辑器图片成功");
		}
		
		private function saveFile(event:FileListEvent):void
		{
			var resItem:AppResInfoItemVO = get_PeopleImageDataGridMediator().resItem;
			if(resItem == null){
				showError("请先选择要编辑的动画");
				return ;
			}
			
			if(event.files.length == 0 ) return ;
			
			for (var i:uint = 0; i < event.files.length; i++) 
			{
				var file:File = event.files[i] as File;
				var fileName:String = file.name.substring(0,file.name.indexOf("."));
				var exp:String = file.extension;
				
				//var url:String = "z:\\"
				var url:String = "";
				
				if(exp == "swf" || exp == "png")
				{
					
					//保存swf
					if(resItem.type == 1){
						url += "role\\monster\\swf\\"+resItem.id+"\\"
					}else if(resItem.type == 2){
						url += "role\\npc\\swf\\"+resItem.id+"\\"
					}else if(resItem.type == 3){
						url += "material\\swf\\"+resItem.id+"\\"
					}else if(resItem.type == 4){
						url += "effect\\swf\\"+resItem.id+"\\"
					}else if(resItem.type == 5){
						url += "role\\user\\swf\\"+resItem.id+"\\"
					}else if(resItem.type == 6){
						url += "motion\\swf\\"+resItem.id+"\\"
					}else if(resItem.type == 7){
						url += "motion\\swf\\"+resItem.id+"\\"
					}else{
						url += "motion\\swf\\"+resItem.id+"\\"
					}
					
					url += file.name
					
					/*var newFile:File = new File(url);
					file.copyTo(newFile,true);*/
					
				}
				else if(exp == "fla")
				{
					
					//保存fla
					
					if(resItem.type == 1){
						url += "role\\monster\\fla\\"+resItem.id+"\\"
					}else if(resItem.type == 2){
						url += "role\\npc\\fla\\"+resItem.id+"\\"
					}else if(resItem.type == 3){
						url += "material\\fla\\"+resItem.id+"\\"
					}else if(resItem.type == 4){
						url += "effect\\fla\\"+resItem.id+"\\"
					}else if(resItem.type == 5){
						url += "role\\user\\fla\\"+resItem.id+"\\"
					}else if(resItem.type == 6){
						url += "motion\\fla\\"+resItem.id+"\\"
					}else{
						url += "motion\\fla\\"+resItem.id+"\\"
					}
					
					url += fileName + ".fla"
										
					/*var newFile:File = new File(url);
					file.copyTo(newFile,true);*/
				}
				
				file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, saveMapFileCallback);
				submitFile(url, file);			
			}
		}
		
		public function reactToPreviewBtnClick(e:MouseEvent):void
		{
			if(get_PeopleImageProxy().resInfo_ls == null) return ;
			var out:Array = [];
			var a:Array = get_PeopleImageProxy().resInfo_ls.group_ls;
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(AppResInfoGroupVO(a[i]).type_str)){
					out.push(a[i]);
				}
			}
			
			var vo:SelectEditPopWinVO = new SelectEditPopWinVO();
			vo.data = out;
			vo.column2_dataField = "name1"
			vo.select_dataField = "item_ls"
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
			dat.data = vo;
			dat.callBackFun = previewMotion
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		
		private function previewMotion(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.PeopleImagePreviewPopwin2_sign;
			dat.data = item;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		
		private function get_PeopleImageDataGridMediator():PeopleImageDataGridMediator
		{
			return retrieveMediator(PeopleImageDataGridMediator.NAME) as PeopleImageDataGridMediator;
		}
		
	}
}
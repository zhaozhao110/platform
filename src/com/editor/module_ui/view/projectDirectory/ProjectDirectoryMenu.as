package com.editor.module_ui.view.projectDirectory
{
	import com.air.component.SandyNativeMenu;
	import com.air.component.SandyNativeMenuItem;
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.air.utils.AIRUtils;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_html.vo.OpenWebPageData;
	import com.editor.tool.project.create.CreateMediator;
	import com.editor.tool.project.create.CreateCacheTool;
	import com.editor.tool.project.create.CreateProxyTool;
	import com.editor.tool.project.create.CreateServerCodeTool;
	import com.editor.tool.project.create.CreateDataVOTool;
	import com.editor.tool.project.create.CreatePopupwinTool;
	import com.editor.tool.project.create.CreateSocketCommandTool;
	import com.editor.tool.project.create.CreateUserModuleFile;
	import com.editor.module_ui.vo.OpenFileInUIEditorEventVO;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.modules.manager.AppMenuManager;
	import com.editor.modules.pop.createClass.AppCreateClassFilePopwinVO;
	import com.editor.modules.proxy.AppModuleProxy;
	import com.editor.popup.input.InputTextPopwinVO;
	import com.editor.vo.OpenFileData;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.component.expand.data.SandyMenuData;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.URLUtils;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;

	public class ProjectDirectoryMenu extends SandyManagerBase
	{
		private static var instance:ProjectDirectoryMenu ;
		public static function getInstance():ProjectDirectoryMenu{
			if(instance == null){
				instance =  new ProjectDirectoryMenu();
				instance.init_inject();
			}
			return instance;
		}
		
		//打开右键菜单
		public function openRightMenu(file:File):void
		{
			var dat:SandyMenuData = new SandyMenuData();
			dat.xml  		= get_AppModuleProxy().projectDirectory_ls.xml;
			dat.click_f  	= onMenuHandler;
			dat.data 		= file
			iManager.sendAppNotification(SandyExternalEvent.open_system_menu_event ,dat);
		}
		
		private function onMenuHandler(btn:IASMenuButton):void
		{
			var evt:XML = btn.getMenuXML()
			var args:File = btn.getMenuData() as File;
			
			if(evt.@data == "200"){ 
				//导入
				_importSelect()
			}else if(evt.@data == "201"){ 
				//新建项目
				_createNewProject()
			}else if(evt.@data == "202"){ 
				//关闭项目
				_closeProject()
			}else if(evt.@data == "204"){ 
				//全部折叠
				sendAppNotification(AppModulesEvent.allContract_event)
			}else if(evt.@data == "206"){ 
				//刷新
				sendAppNotification(AppModulesEvent.reflashProjectDirect_event)
			}else if(evt.@data == "205"){ 
				//界面编辑
				if(args.isDirectory) return ;
				if(args.name.indexOf("CSS_")!=-1){
					showError("该文件好像是css文件");
					return ;
				}
				if(args.extension == "xml"){
					return ;
				}
				if(args.parent.name != "view" && args.parent.name != "component"){
					showError("UI文件必须放在view或者component目录里");
					return ;
				}
				if(args.extension == "as"){
					var xml_file:File = new File(args.parent.nativePath+File.separator+"xml"+File.separator+args.name.split(".")[0]+".xml")
					var ui_d:OpenFileInUIEditorEventVO = new OpenFileInUIEditorEventVO();
					ui_d.file = xml_file;
					ui_d.type = AppCreateClassFilePopwinVO.file_type3
					sendAppNotification(AppModulesEvent.openFile_inUIEditor_event,ui_d)
				}
				ProjectCache.getInstance().addTempFold(args.parent.nativePath);
			}
			else if(evt.@data == "209"){
				//AS文件
				createFile(args);
			}else if(evt.@data == "210"){
				//CSS文件
				createCSSFile(args)
			}else if(evt.@data == "212"){
				//ui文件
				createUIFile(args)
			}else if(evt.@data == "213"){
				//删除
				get_ProjectDirectDockPopwinMediator().delFile();
			}else if(evt.@data == "211"){
				//包目录
				createPackage(args);
			}else if(evt.@data == "207"){
				//css 编辑
				if(args.isDirectory) return ;
				if(args.extension == "as" && StringTWLUtil.beginsWith(args.name,"CSS_")){
					sendAppNotification(AppModulesEvent.openFile_inCSSEditor_event,args)
					ProjectCache.getInstance().addTempFold(args.parent.nativePath);
				}else{
					showError("该文件好像不是正确的css格式文件");
				}
			}else if(evt.@data == "214"){
				//打开文件
				if(args.isDirectory) return ;
				var dd:OpenFileData = new OpenFileData();
				dd.file = args;
				sendAppNotification(AppModulesEvent.openEditFile_event,dd);
				ProjectCache.getInstance().addTempFold(args.parent.nativePath);
			}else if(evt.@data == "216"){
				//浏览
				if(args.isDirectory){
					FileUtils.openFold(args.nativePath)
				}else{
					FileUtils.openFold(args.parent.nativePath);
				}
			}else if(evt.@data == "217"){
				//加入收藏
				if(args.isDirectory){
					ProjectCache.getInstance().addTempFold(args.nativePath);
				}else{
					ProjectCache.getInstance().addTempFold(args.parent.nativePath);
				}
			}else if(evt.@data == "218"){
				//重命名
				var open:OpenPopwinData = new OpenPopwinData();
				open.data = args;
				open.popupwinSign = PopupwinSign.AppRenameFilePopwin_sign;
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}else if(evt.@data == "220"){
				//生成mediator
				if(args.isDirectory) return ;
				if(args.name.indexOf("CSS_")!=-1){
					showError("该文件好像是css文件,不能生成mediator");
					return ;
				}
				if(args.name.indexOf("mediator")!=-1){
					showError("该文件好像是mediator文件,不能生成mediator");
					return ;
				}
				var m:CreateMediator = new CreateMediator();
				m.create(args);
			}else if(evt.@data == "231"){
				//多视图mediator
				if(args.isDirectory) return ;
				if(args.name.indexOf("CSS_")!=-1){
					showError("该文件好像是css文件,不能生成mediator");
					return ;
				}
				if(args.name.indexOf("mediator")!=-1){
					showError("该文件好像是mediator文件,不能生成mediator");
					return ;
				}
				m = new CreateMediator();
				m.create(args,true);
			}else if(evt.@data == "222"){
				//将在各个模块中生成属于该帐号的目录
				CreateUserModuleFile.create();
			}else if(evt.@data == "221"){
				//窗口
				var input_vo:InputTextPopwinVO = new InputTextPopwinVO();
				input_vo.text = "输入窗口的标示"
				input_vo.okButtonFun = createPopupwin;
				open = new OpenPopwinData();
				open.data = input_vo;
				open.popupwinSign = PopupwinSign.InputTextPopwin_sign;
				opt = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}else if(evt.@data == "223"){
				//数据VO
				input_vo = new InputTextPopwinVO();
				input_vo.text = "输入数据vo的类名"
				input_vo.okButtonFun = createVO;
				input_vo.okButtonArgs = args;
				open = new OpenPopwinData();
				open.data = input_vo;
				open.popupwinSign = PopupwinSign.InputTextPopwin_sign;
				opt = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}else if(evt.@data == "224"){
				//数据proxy
				input_vo = new InputTextPopwinVO();
				input_vo.text = "输入数据Proxy的类名"
				input_vo.okButtonFun = createProxy;
				//input_vo.okButtonArgs = args;
				open = new OpenPopwinData();
				open.data = input_vo;
				open.popupwinSign = PopupwinSign.InputTextPopwin_sign;
				opt = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}else if(evt.@data == "225"){
				//数据cache
				input_vo = new InputTextPopwinVO();
				input_vo.text = "输入数据cache的类名"
				input_vo.okButtonFun = createCache;
				//input_vo.okButtonArgs = args;
				open = new OpenPopwinData();
				open.data = input_vo;
				open.popupwinSign = PopupwinSign.InputTextPopwin_sign;
				opt = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}else if(evt.@data == "226"){
				//数据socketCode
				input_vo = new InputTextPopwinVO();
				input_vo.text = "输入服务器消息socketCode的类名"
				input_vo.okButtonFun = createSocketCode;
				//input_vo.okButtonArgs = args;
				open = new OpenPopwinData();
				open.data = input_vo;
				open.popupwinSign = PopupwinSign.InputTextPopwin_sign;
				opt = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}else if(evt.@data == "227"){
				//ie中打开
				if(args.extension != "xml" && args.extension != "swf"){
					showError("只有xml和swf格式文件在ie中打开");
					return ;
				}
				var ie_path:String = args.nativePath;
				if(args.extension == "xml"){
					if(ProjectCache.getInstance().checkIsCompressXML(args)){
						var read:ReadFile = new ReadFile();
						var cont:String = read.readCompressByteArray(args.nativePath);
						var temp_fl:File = File.createTempFile();
						var write:WriteFile = new WriteFile();
						write.write(temp_fl,cont);
						ie_path = temp_fl.nativePath;
					}	
				}
				
				if(args.extension == "xml" || args.extension == "swf"){
					URLUtils.openLink(ie_path);
				}
			}else if(evt.@data == "228"){
				//socketCommand
				input_vo = new InputTextPopwinVO();
				input_vo.text = "输入服务器消息socketCommand的类名"
				input_vo.okButtonFun = createSocketCommand;
				//input_vo.okButtonArgs = args;
				open = new OpenPopwinData();
				open.data = input_vo;
				open.popupwinSign = PopupwinSign.InputTextPopwin_sign;
				opt = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}else if(evt.@data == "229"){
				//复制
				Clipboard.generalClipboard.setData(ClipboardFormats.FILE_LIST_FORMAT,[args]);
			}else if(evt.@data == "230"){
				//粘贴
				if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
				{
					var a:Array = Clipboard.generalClipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
					for(var i:int=0;i<a.length;i++){
						var fl:File = a[i] as File;
						try{
							fl.copyTo(new File(get_ProjectDirectListMediator().getTextInputFile().nativePath+File.separator+fl.name),true);
						}catch(e:Error){
							showError("操作出错");
							return ;
						}
					}
					SandyEngineGlobal.iManager.sendAppNotification(AppEvent.openFold_event,get_ProjectDirectListMediator().getTextInputFile());
				}
			}
		}
		
		private function get_ProjectDirectListMediator():ProjectDirectListMediator
		{
			return iManager.retrieveMediator(ProjectDirectListMediator.NAME) as ProjectDirectListMediator;
		}
		
		private function createSocketCommand(s:String):void
		{
			var tool:CreateSocketCommandTool = new CreateSocketCommandTool();
			tool.create(s);
		}
		
		private function createSocketCode(s:String):void
		{
			var tool:CreateServerCodeTool = new CreateServerCodeTool();
			tool.create(s);
		}
		
		private function createCache(s:String):void
		{
			var tool:CreateCacheTool = new CreateCacheTool();
			tool.create(s);
		}
		
		private function createProxy(s:String):void
		{
			var tool:CreateProxyTool = new CreateProxyTool();
			tool.create(s);
		}
		
		private function createVO(s:String,obj:Object):void
		{
			var url:String = obj.url;
			if(!StringTWLUtil.isWhitespace(url)){
				var file:File = new File(url);
				if(!file.isDirectory){
					url = file.parent.nativePath;
				}
			}
			
			var tool:CreateDataVOTool = new CreateDataVOTool();
			tool.create(s,url);
		}
		
		private function createPopupwin(s:String):void
		{
			var tool:CreatePopupwinTool = new CreatePopupwinTool();
			tool.create(s);
		}
		
		private function createPackage(obj:Object):void
		{
			var url:String = obj.url;
			if(!StringTWLUtil.isWhitespace(url)){
				var file:File = new File(url);
				if(!file.isDirectory){
					url = file.parent.nativePath;
				}
			}
			var d2:AppCreateClassFilePopwinVO = new AppCreateClassFilePopwinVO();
			d2.type = AppCreateClassFilePopwinVO.file_type4;
			d2.package_file = new File(url);
			AppMenuManager.getInstance().createClassFile(d2);
		}
		
		public function createFile(obj:File):void
		{
			var url:String = obj.nativePath;
			var d2:AppCreateClassFilePopwinVO = new AppCreateClassFilePopwinVO();
			d2.type = AppCreateClassFilePopwinVO.file_type1;
			d2.package_file = new File(url);
			AppMenuManager.getInstance().createClassFile(d2);
		}
				
		public function createCSSFile(obj:File):void
		{
			var url:String = obj.nativePath;
			var d2:AppCreateClassFilePopwinVO = new AppCreateClassFilePopwinVO();
			d2.type = AppCreateClassFilePopwinVO.file_type2;
			d2.package_file = new File(url);
			AppMenuManager.getInstance().createClassFile(d2);
		}
		
		public function createUIFile(obj:File):void
		{
			var url:String = obj.nativePath;
			var d2:AppCreateClassFilePopwinVO = new AppCreateClassFilePopwinVO();
			d2.type = AppCreateClassFilePopwinVO.file_type3;
			d2.package_file = new File(url);
			AppMenuManager.getInstance().createClassFile(d2);
		}
		
		private function _createNewProject():void
		{
			AppMenuManager.getInstance().createNewProject();
		}
		
		private function _importSelect():void
		{
			AppMenuManager.getInstance().importSource();
		}
		
		private function _closeProject():void
		{
			AppMenuManager.getInstance().closeProject();
		}
		
		private function get_AppModuleProxy():AppModuleProxy
		{
			return iManager.retrieveProxy(AppModuleProxy.NAME) as AppModuleProxy 
		}
		
		private function get_ProjectDirectDockPopwinMediator():ProjectDirectViewMediator
		{
			return iManager.retrieveMediator(ProjectDirectViewMediator.NAME) as ProjectDirectViewMediator;
		}
		
	}
}
package com.editor.modules.pop.createClass
{
	import com.asparser.ClsUtils;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UISelectFileButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.expand.UIComboBoxWithLabel;
	import com.editor.event.AppEvent;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_ui.vo.component.ComItemVO;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.modules.pop.pathList.OpenPathListPopWinVO;
	import com.editor.proxy.AppComponentProxy;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class AppCreateClassFilePopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppCreateClassFilePopwinMediator"
		public function AppCreateClassFilePopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():AppCreateClassFilePopwin
		{
			return viewComponent as AppCreateClassFilePopwin
		}
		public function get pathButton():UIButton
		{
			return createWin.pathButton;
		}
		public function get pathForm():UITextInput
		{
			return createWin.pathForm;
		}
		public function get nameForm():UITextInput
		{
			return createWin.nameForm;
		}
		public function get cb():UICombobox
		{
			return createWin.cb;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			item = (getOpenDataProxy() as OpenPopwinData).data as AppCreateClassFilePopwinVO;
						
			if(item.type == AppCreateClassFilePopwinVO.file_type2){
				createWin.title = "新建css文件"
				reflashInCSS();
				if(ProjectCache.getInstance().userCSSFold == null){
					showError("出现系统错误，请联系管理员");
					return ;
				}
				setPathText(ProjectCache.getInstance().userCSSFold.nativePath);
				pathForm.toolTip = ProjectCache.getInstance().userCSSFold.nativePath;
			}else{
				createWin.title = "新建文件"
				cb.visible = false;
				
				if(item.package_file != null){
					if(item.package_file.isDirectory){
						setPathText(item.package_file.nativePath);
						pathForm.toolTip = item.package_file.nativePath;
					}else{
						setPathText(item.package_file.parent.nativePath);
						pathForm.toolTip = item.package_file.parent.nativePath;
					}
				}
			}
			
			nameForm.enterKeyDown_proxy = okButtonClick;
		}
		
		private var selectPath:String;
		private var item:AppCreateClassFilePopwinVO;
					
		public function reactToPathButtonClick(e:MouseEvent):void
		{
			var win:OpenPathListPopWinVO = new OpenPathListPopWinVO();
			win.call_f = getFileURL;
			win.isDirectory = true
			var openData:OpenPopwinData = new OpenPopwinData();
			openData.popupwinSign = PopupwinSign.AppPathListPopwin_sign;
			openData.data = win;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			openData.openByAirData = opt;
			openPopupwin(openData);
		}
		
		private function getFileURL(fl:File):void
		{
			setPathText(fl.nativePath);
		}
		
		private function setPathText(value:String):void
		{
			selectPath = value;
			pathForm.text = ClsUtils.getClassPathString(new File(value));
		}
		
		override protected function okButtonClick():void
		{
			if(StringTWLUtil.isWhitespace(nameForm.text)){
				return ;
			}
			
			var url:String = selectPath + File.separator + nameForm.text + item.getFileSuffix();
			if(item.type == AppCreateClassFilePopwinVO.file_type2){
				addLog("新建css文件: " + url);
				item.selectStyleCom = cb.selectedItem as ComItemVO;
			}
			item.file = new File(url);
			sendAppNotification(AppModulesEvent.createFile_inProjectDirectory_event,item);
			closeWin();
		}
		
		private function reflashInCSS():void
		{
			cb.labelField = "name";
			cb.dataProvider = get_AppComponentProxy().getListHaveStyle();
			cb.selectedIndex = 0;
			cb.visible = true;
			nameForm.text = "CSS_";
		}
		
		private function get_AppComponentProxy():AppComponentProxy
		{
			return retrieveProxy(AppComponentProxy.NAME) as AppComponentProxy;
		}
		
	}
}
package com.editor.module_code
{
	import com.asparser.Field;
	import com.asparser.TokenColor;
	import com.asparser.TokenConst;
	import com.air.thread.ThreadMessageData;
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_code.component.AppEditCodePopView;
	import com.editor.module_code.event.CodeEvent;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.manager.AppMenuManager;
	import com.editor.vo.OpenFileData;
	import com.sandy.asComponent.controls.ASButton;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.manager.data.KeyStringCodeConst;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class CodeEditorModuleMediator extends AppMediator
	{
		public static const NAME:String = 'CodeEditorModuleMediator'
		public function CodeEditorModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get editor():CodeEditorModule
		{
			return viewComponent as CodeEditorModule
		}
		private function get tabbar():UITabBarNav
		{
			return editor.tabbar; 
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			reflashColorStyleFromSharedObject();
			
			tabbar.addEventListener(ASEvent.CHANGE,_tabBarChange)
			tabbar.addEventListener(ASEvent.CHILDADD , _tabBarAddHandle)
			tabbar.addEventListener(ASEvent.CHILDREMOVE , _tabBarRemoveHandle)
			
			initTabBarFromStorage();
			
			iKeybroad.addKeyDownProxyFun(this);
		}
		
		public function respondToCloseProjectEvent(noti:Notification):void
		{
			tabbar.removeAllTab()
		}
		
		override public function keyDown_f(e:KeyboardEvent):void
		{
			if(e.ctrlKey){
				if(e.keyCode == KeyStringCodeConst.H){
					var open:OpenPopwinData = new OpenPopwinData();
					open.popupwinSign = PopupwinSign.ProjectSearchPopwin_sign
					var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
					open.openByAirData = opt;
					openPopupwin(open);
				}
			}
		}
		
		public function removeAllTab():void
		{
			tabbar.removeAllTab();
		}
		
		private function reflashColorStyleFromSharedObject():void
		{
			if(iSharedObject.find("","fontColor")!=null){
				TokenColor.fontColor = iSharedObject.find("","fontColor");
			}
			if(iSharedObject.find("","editBackgroundColor")!=null){
				TokenColor.editBackgroundColor = iSharedObject.find("","editBackgroundColor");
			}
			if(iSharedObject.find("","infoColor")!=null){
				TokenConst.setColor(5,iSharedObject.find("","infoColor"));
			}
			if(iSharedObject.find("","strColor")!=null){
				TokenConst.setColor(4, iSharedObject.find("","strColor"))
			}
			if(iSharedObject.find("","cursor_color")!=null){
				TokenColor.cursor_color = iSharedObject.find("","cursor_color");
			}
			if(iSharedObject.find("","fontSize")!=null){
				TokenColor.fontSize = iSharedObject.find("","fontSize");
			}
			if(iSharedObject.find("","lineNumColor")!=null){
				TokenColor.lineNum_color = iSharedObject.find("","lineNumColor");
			}
			if(iSharedObject.find("","lineColor")!=null){
				TokenColor.lineColor = iSharedObject.find("","lineColor");
			}
			if(iSharedObject.find("","autoSave")!=null){
				TokenConst.autoSave_time = int(iSharedObject.find("","autoSave"));
			}
		}
		
		private var _addTabbarRightMouse:Boolean;
		
		public function getSelectedIndex():int
		{
			return tabbar.getSelectIndex();
		}
		
		public function getSelectedCodeView():AppEditCodePopView
		{
			return tabbar.getSelectedContent() as AppEditCodePopView
		}
		 
		public function getCodeViewByIndex(ind:int):AppEditCodePopView
		{
			return tabbar.getChildAt(ind) as AppEditCodePopView
		}
		
		public function getSelectedFile():File
		{
			return getSelectedCodeView().getFile();
		}
		
		public function getFileByIndex(ind:int):File
		{
			return getCodeViewByIndex(ind).getFile();
		}
		
		public function getSelectedTab():ASButton
		{
			return tabbar.getSelectedTab();
		}
		
		private function _tabBarRightClick(e:MouseEvent):void
		{
			AppMenuManager.getInstance().fileMenuClick(_fileMenuClickHandle)
		}
		
		private function _fileMenuClickHandle(btn:IASMenuButton):void
		{
			var evt:XML = btn.getMenuXML()
			var args:* = btn.getMenuData();
			
			if(evt.@data == "300"){ 
				removeTab(tabbar.selectedIndex);
			}else if(evt.@data == "301"){ 
				if(checkHaveCodeChanged()){
					showMessage("有文件没有保存，请先保存然后再关闭")
					return ;
				}
				tabbar.removeExcludeTab(tabbar.selectedIndex);
			}else if(evt.@data == "302"){
				if(checkHaveCodeChanged()){
					showMessage("有文件没有保存，请先保存然后再关闭")
					return ;
				}
				tabbar.removeAllTab();
			}else if(evt.@data == "303"){
				//刷新
				if(getSelectedCodeView()!=null){
					getSelectedCodeView().reflashFile();
				}
			}else if(evt.@data == "304"){
				if(getSelectedCodeView()!=null){
					getSelectedCodeView().save();
				}
			}else if(evt.@data == "305"){
				saveAll();
			}
		}
		
		private function checkHaveCodeChanged():Boolean
		{
			var n:int = tabbar.getTabLength();
			for(var i:int=0;i<n;i++){
				var v:AppEditCodePopView = getCodeViewByIndex(i);
				if(v!=null&&v.codeIsChanged){
					return true;
				}
			}
			return false;
		}
		
		public function saveAll():void
		{
			var n:int = tabbar.getTabLength();
			for(var i:int=0;i<n;i++){
				var v:AppEditCodePopView = getCodeViewByIndex(i);
				if(v!=null&&v.codeIsChanged){
					v.saveCall();
				}
			}
		}
		
		private function initTabBarFromStorage():void
		{
			var a:Array = AppMainModel.getInstance().applicationStorageFile.curr_editFiles;
			if(a!=null){
				var url:String = AppMainModel.getInstance().applicationStorageFile.editFile;
				var _ind:int;
				for(var i:int=0;i<a.length;i++){
					_addFromFileURL(a[i]);
					if(url == a[i]){
						_ind = i;
					}
				}
				tabbar.setSelectIndex(_ind);
			}
		}
		
		/** 打开文件编辑	 */ 
		public function respondToOpenEditFileEvent(noti:Notification):void
		{
			if(StackManager.currStack != DataManager.stack_code) return ;
			var dd:OpenFileData = noti.getBody() as OpenFileData;
			var file:File = dd.file;
			_addFromFileURL(file.nativePath);
			
			var select_n:int=-1;
			var n:int = tabbar.getTabLength()
			for(var i:int=0;i<n;i++){
				if(getFileByIndex(i)!=null&&getFileByIndex(i).nativePath == file.nativePath){
					select_n = i;
					break
				}
			}
			if(select_n>=0){
				tabbar.selectedIndex = select_n;
			}else{
				tabbar.selectedIndex = tabbar.getTabLength()-1;
			}
			if(dd.rowIndex>0){
				setTimeout(function():void{
					getSelectedCodeView().codeText.jumpByRowIndex(dd.rowIndex);
					getSelectedCodeView().codeText.createSignList(dd.rowSign_ls);
				},500);
			}
		}
		
		private function _addFromFileURL(url:String,_setContent:Boolean=true):void
		{
			var file:File = new File(url);
			if(file.exists){
				var haveOpen:Boolean;
				var _showIndex:int;
				var n:int = tabbar.getTabLength()
				for(var i:int=0;i<n;i++){
					if(getFileByIndex(i)!=null&&getFileByIndex(i).nativePath == url){
						tabbar.selectedIndex = i;
						_showIndex = i
						haveOpen = true;
						break;
					}
				}
				if(!haveOpen){
					var v:AppEditCodePopView = new AppEditCodePopView();
					v.label = file.name;
					v.toolTip = file.nativePath;
					tabbar.addChild(v);
					_showIndex = tabbar.getTabLength()-1;
					if(!_addTabbarRightMouse){
						tabbar.getTabBar().addEventListener(MouseEvent.RIGHT_MOUSE_DOWN , _tabBarRightClick);
						_addTabbarRightMouse=true;
					}
				}
				if(_setContent){
					AppEditCodePopView(tabbar.getChildAt(_showIndex)).setFile(file);
					CodeEditorManager.currEditFile = file
				}
			}
		}
		
		public function respondToDeleteFileInProjectEvent(noti:Notification):void
		{
			var fl:File = noti.getBody() as File;
			closeTabs(fl.nativePath,true);
		}
		
		public function respondToCloseFileInProjectEvent(noti:Notification):void
		{
			closeTabs(noti.getBody(),true);	
		}
		
		private function closeTabs(val:*,_force:Boolean=false):void
		{
			var a:Array = [];
			if(val is Array){
				a = val as Array;
			}else{
				a.push(val);
			}
			for(var i:int=0;i<a.length;i++){
				var url:String = a[i];
				if(!StringTWLUtil.isWhitespace(url)){
					var n:int = tabbar.getTabLength()
					for(var j:int=0;j<n;j++){
						if(getFileByIndex(j)!=null&&getFileByIndex(j).nativePath == url){
							removeTab(j,_force);
							break;
						}
					}
				}
			}
		}
		
		public function closeTabByIndex(ind:int):void
		{
			removeTab(ind);
		}
		
		private function removeTab(ind:int,_force:Boolean=false):void
		{
			if(_force){
				tabbar.removeTab(ind);
			}else{
				var v:AppEditCodePopView = getCodeViewByIndex(ind);
				if(v!=null){
					if(v.codeIsChanged){
						var d:OpenMessageData = new OpenMessageData();
						d.info = "文件"+v.getFile().nativePath+"已改变，是否保存后再关闭？"
						d.okFunction = removeTab_ok;
						d.okFunArgs = ind;
						d.noFunction = removeTab_no;
						d.noFunArgs = ind;
						showConfirm(d);
					}else{
						tabbar.removeTab(ind);
					}
				}
			}
		}
		
		private function removeTab_ok(ind:int):Boolean
		{
			var v:AppEditCodePopView = getCodeViewByIndex(ind);
			if(v!=null){
				v.save();
			}
			removeTab(ind,true);
			return true
		}
		
		private function removeTab_no(ind:int):Boolean
		{
			removeTab(ind,true);
			return true
		}
		
		//显示文件内容
		private function _tabBarChange(e:ASEvent):void
		{
			if(getSelectedCodeView() == null) return ;
			var file:File = getSelectedCodeView().getFile();
			if(file!=null){
				if(!file.exists){
					showError("文件已经不存在");
					removeTab(tabbar.selectedIndex,true);
					return ;
				}
			}
			if(file == null) return 
			if(getSelectedCodeView().codeText.needColor){
				getSelectedCodeView().colorCode();
			}
			//getSelectedCodeView().codeText.onFocusIn();
			setCurrEditFile(file);
		}
		
		private function setCurrEditFile(fl:File):void
		{
			CodeEditorManager.currEditFile = fl;
			if(fl != null){
				AppMainModel.getInstance().applicationStorageFile.putKey_editFile(fl.nativePath);
				sendAppNotification(CodeEvent.codeEditor_change_event,fl);
			}else{
				AppMainModel.getInstance().applicationStorageFile.putKey_editFile("");
				sendAppNotification(CodeEvent.codeEditor_change_event,null);
			}
		}
		
		private function _tabBarAddHandle(e:ASEvent):void
		{
			reflashStorage()
		}
		
		private function _tabBarRemoveHandle(e:ASEvent):void
		{
			reflashStorage();
			if(tabbar.getTabLength() == 0){
				sendAppNotification(CodeEvent.codeEditor_change_event,null);
				setCurrEditFile(null);
			}
		}
		
		private var time_uint:uint;
		
		private function reflashStorage():void
		{
			clearTimeout(time_uint);
			time_uint = setTimeout(_reflashStorage,1000);
		}
		
		private function _reflashStorage():void
		{
			var out:Array = [];
			var n:int = tabbar.getTabLength()
			for(var i:int=0;i<n;i++){
				if(AppEditCodePopView(tabbar.getChildAt(i)).getFile()!=null){
					out.push(AppEditCodePopView(tabbar.getChildAt(i)).getFile().nativePath);
				}
			}
			AppMainModel.getInstance().applicationStorageFile.putKey_editFiles(out);
		}
		
		public function respondToFormatASCompleteEvent(noti:Notification):void
		{
			var file:String = noti.getType();
			var codeView:AppEditCodePopView = getCodeViewByFilePath(file);
			if(codeView!=null){
				codeView.formatComplete(String(noti.getBody()));
			}
		}
		
		public function respondToCodeEditorColorEvent(noti:Notification):void
		{
			var file:String = noti.getType();
			var codeView:AppEditCodePopView = getCodeViewByFilePath(file);
			if(codeView!=null){
				var a:Array = noti.getBody() as Array;
				if(a == null) return ;
				trace("类文件上色: " + a.length)
				
				codeView.codeText.codeColor(a);
			}
		}
		
		public function getCodeViewByFilePath(path:String):AppEditCodePopView
		{
			var n:int = tabbar.getTabLength()
			for(var i:int=0;i<n;i++){
				if(AppEditCodePopView(tabbar.getChildAt(i)).getFile()!=null&&AppEditCodePopView(tabbar.getChildAt(i)).getFile().nativePath == path){
					return AppEditCodePopView(tabbar.getChildAt(i));
				}
			}
			return null;
		}
				
		public function jumpToMember(f:Field):void
		{
			if(getSelectedCodeView() == null) return 
			getSelectedCodeView().jumpToMember(f)
		}
		
		public function respondToSystemSetPopWinCloseEvent(noti:Notification):void
		{
			var n:int = tabbar.getTabLength()
			for(var i:int=0;i<n;i++){
				var v:AppEditCodePopView = AppEditCodePopView(tabbar.getChildAt(i));
				v.codeText.reflashColorStyle();
				v.colorCall();
				v.checkAutoSaveEnabled();
			}
			BackgroundThreadCommand.instance.editorStyleChange();
		}
		
		public function respondToLocalSearchCompleteEvent(noti:Notification):void
		{
			getSelectedCodeView().codeText.searchComplete(noti.getBody() as ThreadMessageData);
		}
		
	}
}
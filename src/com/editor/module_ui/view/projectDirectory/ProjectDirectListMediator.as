package com.editor.module_ui.view.projectDirectory
{
	import com.air.io.DeleteFile;
	import com.air.io.FileUtils;
	import com.air.utils.AIRUtils;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITreeVList;
	import com.editor.component.controls.UIVlist;
	import com.editor.manager.AppTimerManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_code.CodeEditorManager;
	import com.editor.module_ui.css.CreateCSSMainFile;
	import com.editor.tool.project.del.ProjectFileDelTool;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.modules.manager.AppMenuManager;
	import com.editor.vo.OpenFileData;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.asComponent.vo.IASTreeData;
	import com.sandy.common.bind.bind.path;
	import com.sandy.manager.data.KeyStringCodeConst;
	import com.sandy.math.ArrayCollection;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class ProjectDirectListMediator extends AppMediator
	{
		public static const NAME:String = "ProjectDirectListMediator"
		public function ProjectDirectListMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get win():ProjectDirectList
		{
			return viewComponent as ProjectDirectList;
		}
		public function get projectPath_ti():UITextInput
		{
			return win.projectPath_ti;
		}
		public function get selectBtn():UIButton
		{
			return win.selectBtn;
		}
		public function get file_box():UIVlist
		{
			return win.file_box;
		}
		public function get syncedBtn():UIImage
		{
			return win.syncedBtn;
		}
		public function get module_cb():UICombobox
		{
			return win.module_cb;
		}
		public function get tree():UITreeVList
		{
			return win.tree;
		}
		public function get modeBtn():UIAssetsSymbol
		{
			return win.modeBtn;
		}
		public function get helpBtn():UIAssetsSymbol
		{
			return win.helpBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			tree.rightClickEnabled = true
			tree.filter_proxy = filterTreeData;
			tree.addEventListener(ASEvent.CHANGE,fileTreeChangeHandle)
			
			file_box.mouseEnabled = true;
			file_box.addEventListener(ASEvent.CHANGE,fileTreeChangeHandle)
						
			projectPath_ti.enterKeyDown_proxy = inputPath;
			ProjectCache.getInstance().module_cb = module_cb;
			module_cb.addEventListener(ASEvent.CHANGE,onModuleChange);
			
			iKeybroad.addKeyDownListener(KeyStringCodeConst.F5,onKeyDown)
		}
		
		//全部折叠
		public function respondToAllContractEvent(noti:Notification):void
		{
			tree.setAllClose();
		}
		
		private function onKeyDown(evt:KeyboardEvent=null):void
		{
			reflashPath();
		}
		
		private function inputPath():void
		{
			setPath(projectPath_ti.text);
		}
		
		private function filterTreeData(d:IASTreeData):Boolean
		{
			if(FileUtils.isSVNFile(d.name)) return false;
			return true;
		}
		
		public function reactToModeBtnClick(e:MouseEvent):void
		{
			if(tree.visible){
				tree.visible = false;
				file_box.visible = true;
			}else{
				tree.visible = true
				file_box.visible = false
			}
			reflashPath()
		}
		
		private function onModuleChange(e:Event):void
		{
			var url:String = String(module_cb.selectedItem);
			url = ProjectCache.getInstance().getProjectOppositePath(url);
			var fl:File = new File(url);
			if(fl.exists){
				setPath(ProjectCache.getInstance().getProjectOppositePath(url));
			}else{
				showError("文件不存在");
			}
		}
		
		public function reactToSelectBtnClick(e:MouseEvent):void
		{
			AppMenuManager.getInstance().importSource();
		}
		 
		public function reactToSyncedBtnClick(e:MouseEvent):void
		{
			var file:File = StackManager.getInstance().getCurrEditFile();
			if(file!=null&&file.exists){
				if(tree.visible){
					findInTreeList()
					return ;
				}
				setPath(file.parent.nativePath);
			}
		}
		
		private function findInTreeList():void
		{
			var file:File = StackManager.getInstance().getCurrEditFile();
			var a:Array = tree.getAllList();
			for(var i:int=0;i<a.length;i++){
				var dt:IASTreeData = a[i] as IASTreeData;
				var fl:File = new File(Object(dt.obj).url);
				if(fl.nativePath == file.nativePath){
					tree.selectedItem = dt;
					break;
				}
			}
		}
		
		private var selectedItem:*;
		
		public function getSelectedFile():*
		{
			if(file_box.visible){
				return file_box.selectedItem;
			}
			if(tree.visible){
				return new File(Object(IASTreeData(tree.selectedItem).obj).url);
			}
			return null;
		}
		
		public function getTextInputFile():File
		{
			if(StringTWLUtil.isWhitespace(projectPath_ti.text)){
				return new File(ProjectCache.getInstance().getProjectSrcURL());
			}
			return new File(getPath());
		}
		
		private function fileTreeChangeHandle(e:ASEvent):void
		{
			selectedItem = getSelectedFile();
			if(selectedItem == null) return ;
			if(selectedItem != "file_up" && tree.visible){
				if(File(selectedItem).isDirectory){
					setPath2(File(selectedItem).nativePath);
				}else{
					setPath2(File(selectedItem).parent.nativePath);
				}
			}
			if(e.isRightClick){
				later_winRightClick()
				return ;
			}
			if(e.isDoubleClick){
				if(selectedItem == "file_up"){
					setPath( (getTextInputFile().parent as File).nativePath );
					return ;
				}
				var fl:File = selectedItem;
				if(!fl.isDirectory){
					var dd:OpenFileData = new OpenFileData();
					dd.file = fl;
					sendAppNotification(AppModulesEvent.openEditFile_event,dd);
				}else{
					setPath(File(getSelectedFile()).nativePath);
				}
			}
		}

		private function later_winRightClick():void
		{
			if(ProjectCache.getInstance().currEditProjectFile==null) return ;
			selectedItem = getSelectedFile();
			if(selectedItem == null && getTextInputFile() !=null){
				selectedItem = new File(getTextInputFile().nativePath);
			}
			if(selectedItem == "file_up"){
				if(getTextInputFile() !=null && file_box.visible){
					setPath(getTextInputFile().parent.nativePath);
				}
				return ;
			}
			ProjectDirectoryMenu.getInstance().openRightMenu(selectedItem as File);
		}
		
		public function setProject():void
		{
			module_cb.dataProvider = ProjectCache.getInstance().getJumpList();
		}
		
		private var tree_setData:Boolean;
				
		public function setPath(url:String):void
		{
			var file:File = new File(url);
			if(!file.exists){
				file = new File(FileUtils.getParentPath(url));
			}
			if(!file.exists) return 
			
			if(tree.visible){
				tree.setTreeDataProvider(ProjectCache.getInstance().cache);
				//tree.dataProvider = ProjectCache.getInstance().currEditProjectFile;
				tree_setData = true;
			}else if(file_box.visible){
				
				var a:Array = file.getDirectoryListing();
				a = a.sortOn("isDirectory",Array.NUMERIC|Array.DESCENDING);
				
				var b:Array = ["file_up"];
				a = b.concat(a);
				var aa:Array = [];
				for(var i:int=0;i<a.length;i++){
					if(a[i] is File){
						var fl:File = File(a[i]);
						if(fl.name.indexOf(".svn")==-1){
							if(iSharedObject.find("","projectAllShow")==1){
								aa.push(fl);
							}else if(!fl.isHidden){
								aa.push(fl);
							}
						}
					}else{
						aa.push(a[i]);
					}
				}
				file_box.dataProvider = aa;
			}
			setPath2(url);
			projectPath_ti.toolTip 	= url;
			module_cb.toolTip 		= url;
			AppMainModel.getInstance().applicationStorageFile.putKey_projectFold(url);
		}
				
		public function respondToCloseProjectEvent(noti:Notification):void
		{
			tree.dataProvider = null;
			file_box.dataProvider = null;
			projectPath_ti.text = "";
			module_cb.dataProvider = null;
		}
				
		private function getPath():String
		{
			if(projectPath_ti.text.indexOf(":\\")!=-1){
				return projectPath_ti.text;
			}
			return ProjectCache.getInstance().getProjectOppositePath(projectPath_ti.text);
		}
		
		private function setPath2(s:String):void
		{
			projectPath_ti.text = ProjectCache.getInstance().getOppositePath(s);
		}
		
		public function reflashPath():void
		{
			if(getTextInputFile() == null) return 
			setPath(getTextInputFile().nativePath);
		}
		
		//添加文件
		public function insertPath(url:String):void
		{
			var fl:File = new File(url);
			if(fl.exists){
				
				if(tree_setData){
					var d:ASTreeData = new ASTreeData();
					d.name = fl.name;
					var obj:Object = {};
					obj.isDirectory = fl.isDirectory;
					obj.file 		= fl;
					obj.url			= fl.nativePath;
					d.obj = obj;
					
					var par_obj:IASTreeData;
					var a:Array = tree.getAllList();
					for(var i:int=0;i<a.length;i++){
						var dt:IASTreeData = a[i] as IASTreeData;
						var fl1:File = new File(Object(dt.obj).url);
						if(fl1.nativePath == fl.parent.nativePath){
							par_obj = dt;
							break;
						}
					}
					d.branch = par_obj;
					tree.addTreeItem(d);
				}
				
				setPath(fl.parent.nativePath);
			}
		}
		
		public function delFile():void
		{
			if(getSelectedFile() == null) return ;
			var fl:File = getSelectedFile();
			if(fl == null) return ;
			var xml_file:File = new File(fl.parent.nativePath+File.separator+"xml"+File.separator+fl.name.split(".")[0]+".xml");
			var m:OpenMessageData = new OpenMessageData();
			if(fl.isDirectory){
				if(fl.parent.nativePath == (ProjectCache.getInstance().getModulesPath()+File.separator+AppMainModel.getInstance().user.shortName)){
					m.info = "确定要删除该窗口,窗口里的view,mediator,vo等等都将删除?<br>";
				}else{
					m.info = "确定要删除该目录,将删除该目录下的所有文件?<br>";
				}
			}else{
				if(xml_file.exists){
					if(xml_file.name.substring(0,4)=="CSS_"){
						m.info = "确定要删除该CSS文件?<br>";		
					}else{
						m.info = "确定要删除该文件?<br>";
					}
				}else{
					m.info = "确定要删除该文件?<br>";
				}
			}
			m.info += "删除文件:"+ fl.nativePath;
			m.okFunction = confirm_delFile;
			showConfirm(m);
		}
		
		private function confirm_delFile():Boolean
		{
			var fl:File = getSelectedFile();
			if(fl == null) return true;
			
			var del:ProjectFileDelTool = new ProjectFileDelTool();
			del.del(fl);
			
			if(tree_setData){
				var par_obj:IASTreeData;
				var a:Array = tree.getAllList();
				for(var i:int=0;i<a.length;i++){
					var dt:IASTreeData = a[i] as IASTreeData;
					var fl1:File = new File(Object(dt.obj).url);
					if(fl1.nativePath == fl.nativePath){
						par_obj = dt;
						break;
					}
				}
				
				tree.removeTreeItem(par_obj);
			}
			return true;
		}
		
		public function reactToHelpBtnClick(e:MouseEvent):void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.ProjectHelpPopWin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open)
		}
		
	}
}
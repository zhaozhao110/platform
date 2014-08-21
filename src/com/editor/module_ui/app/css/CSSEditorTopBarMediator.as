package com.editor.module_ui.app.css
{
	import com.air.io.ReadFile;
	import com.air.io.ReadImage;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIText;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.css.CSSShowContainer;
	import com.editor.module_ui.css.CSSShowContainerMediator;
	import com.editor.module_ui.css.CreateCSSMainFile;
	import com.editor.module_ui.css.CreateCSSXML;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.view.projectDirectory.ProjectDirectoryMenu;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.proxy.AppComponentProxy;
	import com.editor.vo.OpenFileData;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class CSSEditorTopBarMediator extends AppMediator
	{
		public static const NAME:String = 'CSSEditorTopBarMediator'
		public function CSSEditorTopBarMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get topBar():CSSEditorTopBar
		{
			return viewComponent as CSSEditorTopBar;
		}
		public function get newBtn():UIButton
		{
			return topBar.newBtn;
		}
		public function get debugBtn():UIButton
		{
			return topBar.debugBtn;
		}
		public function get css_cb():UICombobox
		{
			return topBar.css_cb;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			init_cssFileList();
		}
		
		//搜索出所有main css file
		public function init_cssFileList():void
		{
			var url:String = ProjectCache.getInstance().getThemePath();
			var fl:File = new File(url);
			if(!fl.exists) return ;
			var a:Array = fl.getDirectoryListing();
			var fl_a:Array = [];
			for(var i:int=0;i<a.length;i++){
				var _fl:File = a[i] as File;
				if(!_fl.isDirectory){
					fl_a.push(_fl);
				}
			}
			var out:Array = [{label:"还没有创建",data:""}];
			for(i=0;i<fl_a.length;i++){
				_fl = fl_a[i] as File;
				out.push({label:_fl.name,data:_fl.nativePath});
			}
			var _selectedIndex2:int;
			for(i=0;i<out.length;i++){
				var obj:Object = out[i];
				if(String(obj.label).toLowerCase().indexOf(AppMainModel.getInstance().user.shortName)!=-1){
					_selectedIndex2 = i;
					break;
				}
			}
			css_cb.labelField = "label";
			css_cb.dataProvider = out;
			css_cb.selectedIndex = _selectedIndex2;
			
			if(_selectedIndex2 == 0){
				CreateCSSMainFile.createEmptyFile();
				CreateCSSMainFile.createEmptyFold();
				init_cssFileList();
			}
		}
		
		public function getSelectedCSSObj():Object
		{
			return css_cb.selectedItem;
		}
		
		public function respondToOpenFileInCSSEditorEvent(noti:Notification):void
		{
			var fl:File = noti.getBody() as File;
			openFile(fl);
		}
		
		private function openFile(fl:File):void
		{
			if(fl.name.indexOf("CSS_")==-1) {
				showError("不是正确的css格式文件");
				return ;
			}
			var d:CSSComponentData = new CSSComponentData();
			d.parserComplete = parserComplete;
			d.parserFile(fl);	
		}
		
		private function parserComplete(d:CSSComponentData):void
		{
			if(StringTWLUtil.isWhitespace(d.type)){
				showError("没有找到css的模版");
				return ;
			}
			d.item = AppComponentProxy.instance.com_ls.getItemByName(d.type);
			CSSShowContainerMediator.instance.addFile(d);
			sendAppNotification(UIEvent.open_comAttri_inCSS_event,d);
		}
		
		public function respondToOpenEditFileEvent(noti:Notification):void
		{
			if(StackManager.currStack != DataManager.stack_css) return ;
			var dd:OpenFileData = noti.getBody() as OpenFileData;
			var file:File = dd.file;
			openFile(file);
		}
				
		public function reactToNewBtnClick(e:MouseEvent):void
		{
			var fl:File = new File(ProjectCache.getInstance().getGlobalCSS());
			if(fl.extension == "as" && StringTWLUtil.beginsWith(fl.name,"CSS_")){
				sendAppNotification(AppModulesEvent.openFile_inCSSEditor_event,fl)
			}
		}
		
		public function reactToDebugBtnClick(e:MouseEvent):void
		{
			
		}
		
		private function get_CSSEditorMediator():CSSEditorMediator
		{
			return retrieveMediator(CSSEditorMediator.NAME) as CSSEditorMediator;
		}
		
	}
}
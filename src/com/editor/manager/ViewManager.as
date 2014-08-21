package com.editor.manager
{
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.module_code.CodeEditorModule;
	import com.editor.module_code.CodeEditorModuleMediator;
	import com.editor.module_code.view.outline.CodeOutLineView;
	import com.editor.module_code.view.outline.CodeOutLineViewMediator;
	import com.editor.module_code.view.search.CodeSearchView;
	import com.editor.module_code.view.search.CodeSearchViewMediator;
	import com.editor.module_ui.app.css.CSSEditor;
	import com.editor.module_ui.app.css.CSSEditorMediator;
	import com.editor.module_ui.app.ui.UIEditor;
	import com.editor.module_ui.app.ui.UIEditorMediator;
	import com.editor.module_ui.view.comList.UIEditorComponentListView;
	import com.editor.module_ui.view.comList.UIEditorComponentListViewMediator;
	import com.editor.module_ui.view.cssAttri.CSSEditorAttriListView;
	import com.editor.module_ui.view.cssAttri.CSSEditorAttriListViewMediator;
	import com.editor.module_ui.view.inventedGroup.InvertedGroupView;
	import com.editor.module_ui.view.inventedGroup.InvertedGroupViewMediator;
	import com.editor.module_ui.view.outline.UIEditorOutlineView;
	import com.editor.module_ui.view.outline.UIEditorOutlineViewMediator;
	import com.editor.module_ui.view.projectDirectory.ProjectDirectView;
	import com.editor.module_ui.view.projectDirectory.ProjectDirectViewMediator;
	import com.editor.module_ui.view.uiAttri.UIEditorAttriListView;
	import com.editor.module_ui.view.uiAttri.UIEditorAttriListViewMediator;
	import com.editor.modules.app.AppMainPopupwinModule;
	import com.editor.modules.common.app.center.AppMiddleCenterBottomContainerMediator;
	import com.editor.modules.common.app.center.AppMiddleCenterTopContainerMediator;
	import com.editor.modules.common.app.left.AppMiddleLeftContainerMediator;
	import com.editor.modules.view.console.ConsoleDockPopView;
	import com.editor.modules.view.console.ConsoleDockPopwinMediator;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.popupwin.data.OpenMessageData;

	//视图管理
	public class ViewManager extends SandyManagerBase
	{
		private static var instance:ViewManager ;
		public static function getInstance():ViewManager{
			if(instance == null){
				instance =  new ViewManager();
			}
			return instance;
		}
		
		public function openView(type:int):void
		{			
			if(type == DataManager.pop_projectDirectory){
				//项目列表 
				openProjectDirect();
			}else if(type == DataManager.pop_console){
				//控制台
				openConsole();
			}else if(type == DataManager.pop_codeEditor){
				//code editor
				openCodeEditor()
			}else if(type == DataManager.pop_uiEditor){
				//open ui editor
				openUIEditor()
			}else if(type == DataManager.pop_comList){
				//组件 列表
				openComListView()
			}else if(type == DataManager.pop_uiAttriList){
				//组件属性列表
				openComAttriListView()
			}else if(type == DataManager.pop_cssEdit){
				//css
				openCSSEditor();
			}else if(type == DataManager.pop_cssAttriList){
				//css attri
				openCSSAttriListView();
			}else if(type == DataManager.pop_outline){
				openOutline();
			}else if(type == DataManager.pop_invertedGroup){
				openInvertedGroup();
			}else if(type == DataManager.pop_codeOutline){
				openCode_Outline();
			}else if(type == DataManager.pop_search){
				openSearch();
			}
		}
		
		public function closeView(type:int):void
		{
			return;
			if(type == DataManager.pop_projectDirectory){
				//项目列表 
				closeProjectDirect();
			}else if(type == DataManager.pop_console){
				//控制台
				closeConsole();
			}else if(type == DataManager.pop_codeEditor){
				//code editor
				closeCodeEditor()
			}else if(type == DataManager.pop_uiEditor){
				closeUIEditor()
			}else if(type == DataManager.pop_comList){
				closeComListView()
			}
		}
		
		///////////////// search ///////////////
		private var searchView:CodeSearchView;
		private var searchMediator:CodeSearchViewMediator;
		
		private function openSearch():void
		{
			if(searchView!=null) {
				sendAppNotification(AppEvent.open_view_event,searchView,DataManager.pop_search.toString())	
				return ;
			}
			searchView = new CodeSearchView();
			searchView.label = DataManager.tabLabel_codeSearch
			sendAppNotification(AppEvent.open_view_event,searchView,DataManager.pop_search.toString())
			iManager.registerMediator(searchMediator = new CodeSearchViewMediator(searchView));
		}
		
		private function closeSearch():void
		{
			sendAppNotification(AppEvent.close_view_event,searchView,DataManager.pop_search.toString())
		}
		
		
		///////////////// code outline  ///////////////
		private var code_outline:CodeOutLineView;
		private var code_outlineMediator:CodeOutLineViewMediator;
		
		private function openCode_Outline():void
		{
			if(code_outline!=null) {
				sendAppNotification(AppEvent.open_view_event,code_outline,DataManager.pop_codeOutline.toString())	
				return ;
			}
			code_outline = new CodeOutLineView();
			code_outline.label = DataManager.tabLabel_codeOutline
			sendAppNotification(AppEvent.open_view_event,code_outline,DataManager.pop_codeOutline.toString())
			iManager.registerMediator(code_outlineMediator = new CodeOutLineViewMediator(code_outline));
		}
		
		private function closeCodeOutline():void
		{
			sendAppNotification(AppEvent.close_view_event,code_outline,DataManager.pop_codeOutline.toString())
		}
		
		
		///////////////// outline  ///////////////
		private var outline:UIEditorOutlineView;
		private var outlineMediator:UIEditorOutlineViewMediator;
		
		private function openOutline():void
		{
			if(outline!=null) {
				sendAppNotification(AppEvent.open_view_event,outline,DataManager.pop_outline.toString())	
				return ;
			}
			outline = new UIEditorOutlineView();
			outline.label = DataManager.tabLabel_outline
			sendAppNotification(AppEvent.open_view_event,outline,DataManager.pop_outline.toString())
			iManager.registerMediator(outlineMediator = new UIEditorOutlineViewMediator(outline));
		}
		
		private function closeOutline():void
		{
			sendAppNotification(AppEvent.close_view_event,outline,DataManager.pop_outline.toString())
		}
		
		
		/////////////////// openInvertedGroup////////////////
		private var invertedGroup:InvertedGroupView
		private var invertedGroupMediator:InvertedGroupViewMediator;
		
		private function openInvertedGroup():void
		{
			if(invertedGroup!=null){
				sendAppNotification(AppEvent.open_view_event,invertedGroup,DataManager.pop_invertedGroup.toString())	
				return ;
			}
			invertedGroup = new InvertedGroupView();
			invertedGroup.label = DataManager.tabLabel_invertedGroup
			sendAppNotification(AppEvent.open_view_event,invertedGroup,DataManager.pop_invertedGroup.toString())
			iManager.registerMediator(invertedGroupMediator = new InvertedGroupViewMediator(invertedGroup));
		}
		
		private function closeInvertedGroup():void
		{
			sendAppNotification(AppEvent.close_view_event,invertedGroup,DataManager.pop_invertedGroup.toString())
		}
		
		
		///////////////// css attri list  ///////////////
		private var cssAttriList:CSSEditorAttriListView;
		private var cssAttriListMediator:CSSEditorAttriListViewMediator;
		
		private function openCSSAttriListView():void
		{
			if(cssAttriList!=null) {
				sendAppNotification(AppEvent.open_view_event,cssAttriList,DataManager.pop_cssAttriList.toString())	
				return ;
			}
			cssAttriList = new CSSEditorAttriListView();
			cssAttriList.label = DataManager.tabLabel_cssAttriList
			sendAppNotification(AppEvent.open_view_event,cssAttriList,DataManager.pop_cssAttriList.toString())
			iManager.registerMediator(cssAttriListMediator = new CSSEditorAttriListViewMediator(cssAttriList));
		}
		
		private function closeCSSAttriListView():void
		{
			sendAppNotification(AppEvent.close_view_event,cssAttriList,DataManager.pop_cssAttriList.toString())
		}
		
		
		///////////////// component attri list  ///////////////
		private var comAttriList:UIEditorAttriListView;
		private var comAttriListMediator:UIEditorAttriListViewMediator;
		
		private function openComAttriListView():void
		{
			if(comAttriList!=null) {
				sendAppNotification(AppEvent.open_view_event,comAttriList,DataManager.pop_uiAttriList.toString())	
				return ;
			}
			comAttriList = new UIEditorAttriListView();
			comAttriList.label = DataManager.tabLabel_comAttriList;
			sendAppNotification(AppEvent.open_view_event,comAttriList,DataManager.pop_uiAttriList.toString())
			iManager.registerMediator(comAttriListMediator = new UIEditorAttriListViewMediator(comAttriList));
		}
		
		private function closeComAttriListView():void
		{
			sendAppNotification(AppEvent.close_view_event,comAttriList,DataManager.pop_uiAttriList.toString())
		}
		
		
		
		///////////////// component list  ///////////////
		private var comList:UIEditorComponentListView;
		private var comListMediator:UIEditorComponentListViewMediator;
		
		private function openComListView():void
		{
			if(comList!=null) {
				//sendAppNotification(AppEvent.open_view_event,uiEditor,DataManager.pop_uiEditor.toString())	
				return ;
			}
			comList = new UIEditorComponentListView();
			comList.label = DataManager.tabLabel_comList;
			sendAppNotification(AppEvent.open_view_event,comList,DataManager.pop_comList.toString())
			iManager.registerMediator(comListMediator = new UIEditorComponentListViewMediator(comList));
		}
		
		private function closeComListView():void
		{
			sendAppNotification(AppEvent.close_view_event,comList,DataManager.pop_comList.toString())
		}
		
		
		///////////////// css editor ///////////////
		
		private var cssEditor:CSSEditor
		private var cssEditorMediator:CSSEditorMediator;
		
		private function openCSSEditor():void
		{
			closeComAttriListView();
			if(cssEditor!=null) {
				//sendAppNotification(AppEvent.open_view_event,uiEditor,DataManager.pop_uiEditor.toString())	
				return ;
			}
			cssEditor = new CSSEditor();
			cssEditor.label = DataManager.tabLabel_cssEdit
			sendAppNotification(AppEvent.open_view_event,cssEditor,DataManager.pop_cssEdit.toString())
			iManager.registerMediator(cssEditorMediator = new CSSEditorMediator(cssEditor));
		}
		
		private function closeCSSEditor():void
		{
			sendAppNotification(AppEvent.close_view_event,cssEditor,DataManager.pop_cssEdit.toString())
		}
		
		
		///////////////// ui editor ///////////////
		
		private var uiEditor:UIEditor;
		private var uiEditorMediator:UIEditorMediator;
		
		private function openUIEditor():void
		{
			closeCSSAttriListView();
			if(uiEditor!=null) {
				//sendAppNotification(AppEvent.open_view_event,uiEditor,DataManager.pop_uiEditor.toString())	
				return ;
			}
			uiEditor = new UIEditor();
			uiEditor.label = DataManager.tabLabel_uiEdit
			sendAppNotification(AppEvent.open_view_event,uiEditor,DataManager.pop_uiEditor.toString())
			iManager.registerMediator(uiEditorMediator = new UIEditorMediator(uiEditor));
		}
		
		private function closeUIEditor():void
		{
			sendAppNotification(AppEvent.close_view_event,uiEditor,DataManager.pop_uiEditor.toString())
		}
		
		
		
		///////////////// code editor ///////////////
		
		private var codeEditor:CodeEditorModule;
		private var codeEditorMediator:CodeEditorModuleMediator;
		
		private function openCodeEditor():void
		{
			closeComAttriListView();
			closeCSSAttriListView();
			if(codeEditor!=null){
				//sendAppNotification(AppEvent.open_view_event,codeEditor,DataManager.pop_codeEditor.toString())
				return ;
			}
			codeEditor = new CodeEditorModule();
			sendAppNotification(AppEvent.open_view_event,codeEditor,DataManager.pop_codeEditor.toString())
			iManager.registerMediator(codeEditorMediator = new CodeEditorModuleMediator(codeEditor));
		}
		
		private function closeCodeEditor():void
		{
			sendAppNotification(AppEvent.close_view_event,codeEditor,DataManager.pop_codeEditor.toString())
		}
		
		
		
		
		/********************* 控制台 ****************************/
		
		public var console:ConsoleDockPopView;
		public var consoleMediator:ConsoleDockPopwinMediator;
		
		private function openConsole():void
		{
			if(console!=null){
				//sendAppNotification(AppEvent.open_view_event,console,DataManager.pop_console.toString())
				return ;
			}
			console = new ConsoleDockPopView();
			console.label = "控制台"
			sendAppNotification(AppEvent.open_view_event,console,DataManager.pop_console.toString())
			iManager.registerMediator(consoleMediator = new ConsoleDockPopwinMediator(console));
		}
		
		private function closeConsole():void
		{
			sendAppNotification(AppEvent.close_view_event,console,DataManager.pop_console.toString())
		}
		
		
		
		
		/********************* 项目列表 ****************************/
		public var projectDirect:ProjectDirectView;
		public var projectDirectMediator:ProjectDirectViewMediator;
		
		private function openProjectDirect():void
		{
			if(projectDirect!=null) {
				//sendAppNotification(AppEvent.open_view_event,projectDirect,DataManager.pop_projectDirectory.toString())
				return ;
			}
			projectDirect = new ProjectDirectView();
			projectDirect.label = DataManager.tabLabel_projectDirt;
			sendAppNotification(AppEvent.open_view_event,projectDirect,DataManager.pop_projectDirectory.toString())
			iManager.registerMediator(projectDirectMediator = new ProjectDirectViewMediator(projectDirect));
		}
		
		private function closeProjectDirect():void
		{
			sendAppNotification(AppEvent.close_view_event,projectDirect,DataManager.pop_projectDirectory.toString())
		}
		
		
		
		private var mainWin:AppMainPopupwinModule;
		public function beforeCloseApp(v:AppMainPopupwinModule):Boolean
		{
			mainWin = v;
			if(AppMainModel.getInstance().isIn3DScene){
				if(D3ProjectCache.dataChange){
					var d:OpenMessageData = new OpenMessageData();
					d.info = "数据发生改变，关闭之前是否保存？"
					d.okFunction = d3SceneSave;
					d.noFunction = closeMainWin;
					showConfirm(d);
					return false;
				}
				
			}
			
			return true;
		}
		
		private function d3SceneSave():Boolean
		{
			D3ProjectCache.getInstance().createXML();
			mainWin.closeWindow();
			return true;
		}
		
		private function d3SceneSave2():Boolean
		{
			D3ProjectCache.getInstance().saveParticle();
			mainWin.closeWindow();
			return true;
		}
				
		private function closeMainWin():Boolean
		{
			mainWin.closeWindow();
			return true;
		}
		
	}
}
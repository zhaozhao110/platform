package com.editor.module_ui.css
{
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.component.controls.UICodeEditor;
	import com.editor.component.controls.UITabBar;
	import com.editor.mediator.AppMediator;
	import com.editor.module_ui.app.css.CSSEditorTopBarMediator;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.view.cssAttri.CSSEditorAttriListViewMediator;
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.module_ui.vo.CSSFileChangeVO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	import flash.text.TextFormat;

	public class CSSShowContainerMediator extends AppMediator
	{
		public static const NAME:String = 'CSSShowContainerMediator'
		public function CSSShowContainerMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			instance = this;
		}
		public function get css():CSSShowContainer
		{
			return viewComponent as CSSShowContainer;
		}
		public function get textArea():UICodeEditor
		{
			return css.textArea;
		}
		public function get tabbar():UITabBar
		{
			return css.tabbar;
		}
		
		public static var instance:CSSShowContainerMediator;
		
		public static var currEditFile:CSSComponentData;
		
		private var createXML:CreateCSSXML;
		
		override public function onRegister():void
		{
			super.onRegister();
			tabbar.addEventListener(ASEvent.CHANGE,tabBarChange);
		}
		
		private function tabBarChange(e:ASEvent):void
		{
			currEditFile = tabbar.selectedItem as CSSComponentData;
			if(currEditFile!=null){
				setContent(currEditFile.info);
				textArea.visible = true;
			}else{
				setContent("");
				textArea.visible = false
			}
			sendAppNotification(UIEvent.open_comAttri_inCSS_event,currEditFile);
		}
		
		public function addFile(file:CSSComponentData):void
		{
			var ds:ASComponent = tabbar.addTab(file) as ASComponent;
			ds.toolTip = file.file.nativePath;
			setContent(file.info);
			currEditFile = file;
		}
		
		public function respondToCssFileChangeEvent(noti:Notification):void
		{
			var d:CSSFileChangeVO = noti.getBody() as CSSFileChangeVO;
			if(currEditFile.file.nativePath == d.componentData.file.nativePath){
				//刷新文件内容，刷新右边的列表
				setContent(d.fileContent);
				currEditFile.parserFileContent(d.fileContent);
				CSSEditorAttriListViewMediator.currShow_cell.setComp(currEditFile);
				
				//get_CSSEditorTopBarMediator().init_cssFileList();
			}
		}
		
		private function setContent(c:String):void
		{
			if(currEditFile == null) return ;
			textArea.text = c;
			BackgroundThreadCommand.instance.colorAS(currEditFile.file,c);
		}
		
		public function respondToCodeEditorColorEvent(noti:Notification):void
		{
			var file:String = noti.getType();
			if(currEditFile!=null && currEditFile.file.nativePath == file){
				var a:Array = noti.getBody() as Array;
				if(a == null) return ;
				trace("CSS类文件上色: " + a.length)
				
				loop:for(var i:int=0;i<a.length;i++){
					var obj:Object = a[i];
					var format:TextFormat = obj.format;
					var _start:int = obj.start;
					var _end:int = obj.end;
					textArea.setTextFormat(format,_start,_end);
				}
			}
		}
		
		public function reflashRender(a:Array):void
		{
			if(createXML == null){
				createXML = new CreateCSSXML();
			}
			createXML.create(a,currEditFile);
		}
		
		private function get_CSSEditorTopBarMediator():CSSEditorTopBarMediator
		{
			return retrieveMediator(CSSEditorTopBarMediator.NAME) as CSSEditorTopBarMediator;
		}
	}
}
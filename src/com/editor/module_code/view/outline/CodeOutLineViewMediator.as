package com.editor.module_code.view.outline
{
	import com.asparser.Field;
	import com.asparser.TypeDB;
	import com.asparser.TypeDBCache;
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.component.containers.UIVBox;
	import com.editor.mediator.AppMediator;
	import com.editor.module_code.CodeEditorManager;
	import com.editor.module_code.CodeEditorModuleMediator;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.filesystem.File;

	public class CodeOutLineViewMediator extends AppMediator
	{
		public static const NAME:String = "CodeOutLineViewMediator"
		public function CodeOutLineViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get outlineView():CodeOutLineView
		{
			return viewComponent as CodeOutLineView;
		}
		public function get comList():UIVBox
		{
			return outlineView.comList;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			if(CodeEditorManager.currEditFile!=null){
				var db:TypeDB = ProjectCache.getInstance().getTypeDB(CodeEditorManager.currEditFile.nativePath);
				if(db!=null){
					comList.dataProvider = db.getOutline();
				}
			}
			
			comList.addEventListener(ASEvent.CHANGE,onComListChange);
		}
		
		private function onComListChange(e:ASEvent):void
		{
			get_CodeEditorModuleMediator().jumpToMember(e.addData as Field);
		}
		
		private function get_CodeEditorModuleMediator():CodeEditorModuleMediator
		{
			return retrieveMediator(CodeEditorModuleMediator.NAME) as CodeEditorModuleMediator;
		}
		
		public function respondToCodeEditorChangeEvent(noti:Notification):void
		{
			var file:File = noti.getBody() as File;
			if(file == null){
				comList.dataProvider = null;
				return ;
			}
			var db:TypeDB = ProjectCache.getInstance().getTypeDB(file.nativePath);
			if(db!=null){
				comList.dataProvider = db.getOutline();
			}else{
				BackgroundThreadCommand.instance.parserAS(file.nativePath)
			}
		}
		
		public function respondToParserASCompleteEvent(noti:Notification):void
		{
			var filePath:String = String(noti.getBody());
			if(CodeEditorManager.currEditFile!=null){
				if(CodeEditorManager.currEditFile.nativePath == filePath){
					comList.dataProvider = TypeDBCache.getDB(filePath).getOutline();
				}
			}
		}
		
		public function respondToParserProjectCompleteEvent(noti:Notification):void
		{
			if(CodeEditorManager.currEditFile!=null){
				var db:TypeDB = ProjectCache.getInstance().getTypeDB(CodeEditorManager.currEditFile.nativePath);
				if(db!=null){
					comList.dataProvider = db.getOutline();
				}
			}
		}
		
	}
}
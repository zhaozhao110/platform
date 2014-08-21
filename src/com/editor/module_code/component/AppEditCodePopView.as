package com.editor.module_code.component
{
	import com.asparser.ClsFormat;
	import com.asparser.Field;
	import com.asparser.Parser;
	import com.asparser.TokenColor;
	import com.asparser.TokenConst;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UICodeEditor;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.AppMainModel;
	import com.editor.module_code.CodeEditorManager;
	import com.editor.module_code.CodeEditorModuleMediator;
	import com.editor.module_code.event.CodeEvent;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.asComponent.controls.ASTabBarButton;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	public class AppEditCodePopView extends UICanvas
	{
		public function AppEditCodePopView()
		{
			super();
			create()
		}
		
		override protected function _addToolTipEventListener():void{}
		
		public var codeText:UICodeEditor;
		private var readFile:ReadFile = new ReadFile();
		private var tabBtn_preLabel:String;
		
		private var _tabButton:ASTabBarButton;
		public function set tabButton(value:ASTabBarButton):void
		{
			_tabButton = value;
			if(value!=null){
				tabBtn_preLabel = value.label;
			}
		}
		public function get tabButton():ASTabBarButton
		{
			return _tabButton;
		}
		
		public function get codeIsChanged():Boolean
		{
			return codeText.getTF().codeChanged
		}
				
		public function getFile():File
		{
			return codeText.file;
		}
		
		
		private function create():void
		{
			enabledPercentSize = true;
			
			codeText = new UICodeEditor();
			//codeText.visible = false
			codeText.enabledPercentSize = true;
			addChild(codeText);
			
			codeText.search_f 				= search
			codeText.getTF().format_fun		= formatCode;
			codeText.getTF().keyUp_fun 		= codeKeyUp;
			codeText.getTF().keyDown_fun 	= codeKeyDown;
			codeText.getTF().parser_fun		= parserCall
			codeText.getTF().color_fun		= colorCall
			codeText.getTF().save_fun 		= saveCall;
			codeText.getTF().close_fun 		= closeCall
			codeText.getTF().reflash_fun 	= reflashFile;
			codeText.addEventListener(ASEvent.CHANGE,onChange);
		}
		
		private function search(cont:String,c:String):void
		{
			BackgroundThreadCommand.instance.local_search(cont,c,false,"null");
		}
		
		private function closeCall():void
		{	
			get_CodeEditorModuleMediator().closeTabByIndex(get_CodeEditorModuleMediator().getSelectedIndex());
		}
		
		private function codeKeyDown(e:KeyboardEvent):void
		{
			get_CodeEditorModuleMediator().keyDown_f(e);
		}
		
		private function codeKeyUp(e:KeyboardEvent):void
		{
			
		}
		
		override public function reset():void
		{
			if(!StringTWLUtil.isWhitespace(tabBtn_preLabel) && tabButton!=null){
				tabButton.label = tabBtn_preLabel;
			}
		}
		
		public function saveCall():void
		{
			if(!codeIsChanged) return ;
			save();
			parserCall();
			reset()
		}
		
		private function parserCall():void
		{
			if(codeText.file!=null){
				if(codeText.file.extension == "as"){
					if(engineEditor.userThread){
						BackgroundThreadCommand.instance.parserAS(codeText.file.nativePath);
					}else{
						Parser.addFile(codeText.file,parserAS_complete);
					}
				}
			}
		}
		
		private function parserAS_complete():void
		{
			sendAppNotification(CodeEvent.parserAS_complete_event,codeText.file.nativePath);
		}
		
		public function colorCall():void
		{
			if(codeText.file!=null){
				if(codeText.file.extension == "as"){
					if(engineEditor.userThread){
						colorCode();
					}else{
						var col:TokenColor = new TokenColor(codeText.getTF());
						col.colorAllRows();
					}
				}
			}
		}
		
		public function checkAutoSaveEnabled():void
		{
			codeText.getTF().checkAutoSaveEnabled();
		}
		
		public function formatCode():void
		{
			if(codeText.file!=null){
				if(codeText.file.extension == "as"){
					if(engineEditor.userThread){
						BackgroundThreadCommand.instance.formatAS(codeText.file.nativePath,codeText.text);
					}else{
						var fom:ClsFormat = new ClsFormat(codeText.getTF());
						fom.format_complete = formatComplete
						fom.run();
					}
				}
			}
		}
		
		public function formatComplete(t:String):void
		{
			codeText.formatComplete(t);
		}
		
		private function onChange(e:ASEvent):void
		{
			if(tabButton!=null){
				if(tabButton.label.indexOf("*")==-1){
					tabBtn_preLabel = tabButton.label;
					tabButton.label = "*"+tabBtn_preLabel;
				}
			}
		}
						
		public function setFile(file:File):void
		{
			codeText.file = file;
			codeText.db = ProjectCache.getInstance().getTypeDB(file.nativePath);
			
			if(file == null){
				codeText.text = "";
			}else{
				var s:String;
				if(checkIsEditXML(file)){
					s = readFile.readCompressByteArray(file.nativePath);	
				}else{
					s = readFile.read(file.nativePath);
				}
				
				if(file.extension == "xml"){
					codeText.text = XML(s).toXMLString();
				}else{
					codeText.text = TokenConst.replace(s);
					if(!engineEditor.userThread){
						codeText.getTF().parserAll();
					}
				}
				
				AppMainModel.getInstance().applicationStorageFile.putKey_editFile(file.nativePath);
			}
			
			reset();
		}
		
		public function colorCode():void
		{
			if(codeText.file!=null){
				if(codeText.file.extension == "as"){
					BackgroundThreadCommand.instance.colorAS(codeText.file,codeText.getTF().text);
				}
			}
		}
		
		public function jumpToMember(f:Field):void
		{
			codeText.jumpToMember(f);
		}
		
		public function reflashFile():void
		{
			setFile(codeText.file);
		}
		
		private function checkIsEditXML(file:File):Boolean
		{
			if(file.extension == "xml"){
				return ProjectCache.getInstance().checkIsCompressXML(file);
			}
			return false
		}
		
		public function save():void
		{
			var write:WriteFile = new WriteFile();
			if(checkIsEditXML(codeText.file)){
				write.writeCompress(codeText.file,codeText.text);
			}else{
				write.write(codeText.file,codeText.text);
			}
			codeText.getTF().saveSuc();
		}
				
		private function get_CodeEditorModuleMediator():CodeEditorModuleMediator
		{
			return iManager.retrieveMediator(CodeEditorModuleMediator.NAME) as CodeEditorModuleMediator;
		}
		
		
	}
}
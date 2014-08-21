package com.editor.module_api.itemRenderer
{
	import com.air.component.codeEditor.SandyCodeEditor;
	import com.air.io.ReadFile;
	import com.asparser.TokenColor;
	import com.editor.module_api.EditorApiFacade;
	import com.sandy.component.containers.SandyCanvas;
	
	import flash.text.TextFormat;

	public class ApiCodeEditor extends SandyCanvas
	{
		public function ApiCodeEditor()
		{
			super();
			create()
		}
		
		public var codeText:SandyCodeEditor;
		private var readFile:ReadFile = new ReadFile();
		
		private function create():void
		{
			enabledPercentSize = true;
			backgroundColor = 0xd4d0c8;
			
			codeText = new SandyCodeEditor();
			codeText.enabeldCopy = false;
			codeText.enabledPercentSize = true;
			addChild(codeText);
			
			codeText.getTF().color_fun		= colorCall
			
			/*codeText.search_f 				= search
			codeText.getTF().format_fun		= formatCode;
			codeText.getTF().keyUp_fun 		= codeKeyUp;
			codeText.getTF().keyDown_fun 	= codeKeyDown;
			codeText.getTF().parser_fun		= parserCall
			
			codeText.getTF().save_fun 		= saveCall;
			codeText.getTF().close_fun 		= closeCall
			codeText.getTF().reflash_fun 	= reflashFile;
			codeText.addEventListener(ASEvent.CHANGE,onChange);*/
		}
		
		public function setText(s:String):void
		{
			codeText.text = s;
		}
		
		private function colorCall():void
		{
			EditorApiFacade.getInstance().sendAppNotification("parserApiCodeCodeEvent",["apiCode",codeText.getTF().text]);
		}
		
		
	}
}
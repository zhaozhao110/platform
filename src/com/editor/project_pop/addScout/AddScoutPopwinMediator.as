package com.editor.project_pop.addScout
{
	import com.air.io.SelectFile;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class AddScoutPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AddScoutPopwinMediator";
		public function AddScoutPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resWin():AddScoutPopwin
		{
			return viewComponent as AddScoutPopwin
		}
		public function get selectBtn():UIButton
		{
			return resWin.selectBtn;
		}
		public function get fileTi():UILabel
		{
			return resWin.fileTi;
		}
		public function get logTxt():UITextArea
		{
			return resWin.logTxt;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function reactToSelectBtnClick(e:MouseEvent):void
		{
			var f:FileFilter = new FileFilter("swf", "*.swf;");
			SelectFile.select("select swf",[f],resultFun)
		}
		
		private var file:File;
		private var tool:AddScoutTool = new AddScoutTool();
		
		private function resultFun(e:Event):void
		{
			tool.addLog = addLog2;
			file = e.target as File;
			fileTi.text = file.nativePath;
			
			var success:String = tool.processFile(file);
			if (success != "")
			{
				logTxt.appendHtmlText("Success: " + success);
			}
			
		}
		
		public function addLog2(s:String):void
		{
			logTxt.appendHtmlText(s);
		}
	}
}
package com.editor.project_pop.flexToAS3
{
	import com.air.component.SandyFile;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.project_pop.flexToAS3.convert.ConvertFlex;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class AppFlexToAS3WinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppFlexToAS3Mediator"
		public function AppFlexToAS3WinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resWin():AppFlexToAS3Win
		{
			return viewComponent as AppFlexToAS3Win
		}
		public function get fileTI3():UITextInput
		{
			return resWin.fileTI3;
		}
		public function get fileTI1():UITextInput
		{
			return resWin.fileTI1;
		}
		public function get fileTI2():UITextInput
		{
			return resWin.fileTI2;
		}
		public function get txt():UITextArea
		{
			return resWin.txt;
		}
		public function get button9():UIButton
		{
			return resWin.button9;
		}
		public function get button13():UIButton
		{
			return resWin.button13;
		}
		public function get button16():UIButton
		{
			return resWin.button16;
		}
		public function get button18():UIButton
		{
			return resWin.button18;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			button9.addEventListener('click',function(e:*):void{convert();});
			button13.addEventListener('click',function(e:*):void{selectOriginalDirectory();});
			button16.addEventListener('click',function(e:*):void{selectTargetDirectory();});
			button18.addEventListener('click',function(e:*):void{convertDirt();});
		}
				
		private var selectFile:SandyFile;
		private var originalFile:File;
		private var targetFile:File;
		
		private function selectOriginalDirectory():void
		{
			SelectFile.selectDirectory("选择原始目录" ,selectOriginalDirectory_result)
		}
			
		private function selectOriginalDirectory_result(e:Event):void
		{
			originalFile = e.currentTarget as File;
			fileTI1.text = originalFile.nativePath;
		}
		
		private function selectTargetDirectory():void
		{
			SelectFile.selectDirectory("选择目标目录" ,selectTargetDirectory_result)
		}
	
		private function selectTargetDirectory_result(e:Event):void
		{
			targetFile = e.currentTarget as File
			fileTI2.text = targetFile.nativePath;
		}
		
		private function convert():void
		{
			SelectFile.select("导入mxml", [new FileFilter("mxml", "*.mxml")],_selectMxmlHandle)
		}
		
		private function _selectMxmlHandle(e:Event):void
		{
			selectFile = new SandyFile(e.currentTarget as File)
			fileTI3.text = selectFile.nativePath;
						
			var conv:ConvertFlex = new ConvertFlex();
			conv.addLog = addLog2;
			conv.data.originalDirectory = originalFile
			conv.data.targetDirectory = targetFile;
			conv.parser(selectFile)
						
			var classFileURL:String = selectFile.parent.nativePath + File.separator + selectFile.fileName + "2.as"	
			var file:File = new File(classFileURL);		
			var write:WriteFile = new WriteFile();
			write.writeAsync(file,conv.createClassString());
		}	
		
		/**
		 * 遍历原始目录，拷贝原始as文件，转换mxml文件，到目标目录
		 */
		private function convertDirt():void
		{
			var conv:ConvertFlex = new ConvertFlex();
			conv.addLog = addLog2;
			conv.data.originalDirectory = originalFile
			conv.data.targetDirectory = targetFile;
			conv.convertDirectory();
		}
			
		private function addLog2(s:String):void
		{
			txt.htmlText += s + "<br>";
		}
				
	}
}
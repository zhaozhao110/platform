package com.editor.project_pop.sharedobject
{
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.SelectFile;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.math.HashMap;
	import com.sandy.net.sharedObject.SolReader;
	import com.sandy.utils.SystemUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.ObjectEncoding;
	import flash.utils.ByteArray;

	public class SharedObjectReaderPopWinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "SharedObjectReaderPopWinMediator"
		public function SharedObjectReaderPopWinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get win():SharedObjectReaderPopWin
		{
			return viewComponent as SharedObjectReaderPopWin
		}
				
		override public function onRegister():void
		{
			super.onRegister();
			
			if(SystemUtils.os == "xp"){
				win.textInput.text = FileUtils.getUserAppData().nativePath+File.separator+"Macromedia\\Flash Player\\#SharedObjects";
			}
			
			win.clientBtn.addEventListener(MouseEvent.CLICK , clientBtnClick);
			win.selectBtn.addEventListener(MouseEvent.CLICK , selectBtnClick);
		}
		
		private function clientBtnClick(e:MouseEvent):void
		{
			var fs:String = File.applicationStorageDirectory.nativePath + File.separator + "#SharedObjects" + File.separator + "engineEditor.sol"
			var f:File = new File(fs);
			read(f);
		}
		
		private function selectBtnClick(e:MouseEvent):void
		{
			var txtFilter:FileFilter = new FileFilter("sharedObject", "*.sol;");
			SelectFile.select("sharedObject",[txtFilter],selectImage,win.textInput.text);
		}
		
		private function selectImage(e:Event):void
		{
			read(e.target as File);
		}
		
		private function read(f:File):void
		{
			if(f == null) return ;
			if(!f.exists) return ;
			
			var read:ReadFile = new ReadFile();
			var b:ByteArray = read.read(f.nativePath,ReadFile.READTYPE_BYTEARRAY);
			
			if(solReader==null){
				solReader = new SolReader();
				solReader.readEnd_f = solReadEnd;
			}
			solReader.deserialize(b);
		}
		
		private function solReadEnd():void
		{
			var obj:Object = solReader.data;
			obj = obj.cookie;
			var a:Array = [];
			for(var key:String in obj){
				a.push({key:key,content:obj[key]});
			}
			win.vbox.dataProvider = a;
		}
		
		private var solReader:SolReader;
	}
}
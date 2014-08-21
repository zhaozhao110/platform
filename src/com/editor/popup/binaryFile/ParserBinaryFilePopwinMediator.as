package com.editor.popup.binaryFile
{
	import com.air.component.SandySelectFileButton;
	import com.air.io.DownloadFile;
	import com.air.io.ReadFile;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.expand.UITextInputComboBox;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.URLUtils;
	
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	public class ParserBinaryFilePopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ParserBinaryFilePopwinMediator"
		public function ParserBinaryFilePopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
		}
		public function get parserWin():ParserBinaryFilePopwin
		{
			return viewComponent as ParserBinaryFilePopwin
		}
		public function get selectBtn():UIButton
		{
			return parserWin.selectBtn;
		}
		public function get saveBtn1():UIButton
		{
			return parserWin.saveBtn1;
		}
		public function get saveBtn2():UIButton
		{
			return parserWin.saveBtn2;
		}
		public function get selectBtn3():UIButton
		{
			return parserWin.selectBtn3;
		}
		public function get selectBtn4():UIButton
		{
			return parserWin.selectBtn4;
		}
		public function get text():UITextArea
		{
			return parserWin.text;
		}
		
		public function get isCompCB():UICheckBox
		{
			return parserWin.isCompCB;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			//textInput.text = "http://dev.god.bojoy.net/God_cn_cn_CLIENT/config/config3/motion.xml"
			
			download.addEventListener(ASEvent.PROGRESS , onProgress);
			download.addEventListener(ASEvent.OPEN , onOpen);
			download.addEventListener(ASEvent.ERROR , onError);
			
			xmlFile.addEventListener(Event.SELECT, on_xmlSelect);
			xmlFile.addEventListener(Event.COMPLETE, on_xmlComplete);
			
			xmlFile2.addEventListener(Event.SELECT, on_xmlSelect2);
			xmlFile2.addEventListener(Event.COMPLETE, on_xmlComplete2);
		}		
		
		private var download:DownloadFile = new DownloadFile();
		private var xmlFile:FileReference = new FileReference();
		private var xmlFile2:FileReference = new FileReference();
		private var xmlFile3:FileReference = new FileReference();
		private var isDownload:Boolean;
		
		public function reactToSelectBtnClick(e:MouseEvent):void
		{
			xmlFile.browse([new FileFilter("file", "*.*")]);
		}
		
		public function reactToSelectBtn3Click(e:MouseEvent):void
		{
			xmlFile2.browse([new FileFilter("file", "*.*")]);
		}
		
		private function on_xmlSelect2(e:Event):void
		{
			try{
				this.xmlFile2.load();
			}catch(e:Error){};
		}
		
		private function on_xmlComplete2(event:Event):void
		{
			isDownload = false
			var data:* = FileReference(event.target).data;
			text.text = data;
		}
		
		private function on_xmlSelect(e:Event):void
		{
			try{
				this.xmlFile.load();
			}catch(e:Error){};
		}
		
		private function on_xmlComplete(event:Event):void
		{
			isDownload = false
			var data:* = FileReference(event.target).data;
			if (data is ByteArray){
				if(isCompCB.selected){
					try{
						ByteArray(data).uncompress();
					}catch (e:Error){}
				}
				//text.text = ByteArray(data).readUTF()
			}else{			
				//data = (data);
				
			}
			text.text = data;
		}
		
		public function reactToSaveBtn1Click(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(text.text)) return ;
			var be:ByteArray = new ByteArray();
			be.writeUTFBytes(text.text);
			if(isCompCB.selected){
				be.compress();
			}
			xmlFile.save(be, "bin" + getSaveFileName());
		}
		
		public function reactToSaveBtn2Click(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(text.text)) return ;
			xmlFile.save(text.text, "parser_" + getSaveFileName());
		}
		
		private function getSaveFileName():String
		{
			try{
				return xmlFile.name;
			}catch(e:Error){};
			return "";
		}
		
				
		private function onProgress(e:ASEvent):void
		{
			text.text = "download progress: " + int(e.data*100) + " %";
		}
		
		private function onOpen(e:ASEvent):void
		{
			text.text = "start download"
		}
		
		private function onError(e:ASEvent):void
		{
			text.text = "download error"
		}
		
		public function reactToSelectBtn4Click(e:MouseEvent):void
		{
			var f:FileFilter = new FileFilter("text", "*.*");
			SelectFile.selectMultiple("text",[f],selectBtn4Result);
		}
		
		private function selectBtn4Result(e:FileListEvent):void
		{
			var read:ReadFile = new ReadFile();
			var write:WriteFile = new WriteFile();
			
			var a:Array = e.files;
			for(var i:int=0;i<a.length;i++){
				var f:File = a[i] as File;
				var c:String = read.readFromFile(f);
				if(!StringTWLUtil.isWhitespace(c)){
					if(isCompCB.selected){
						write.writeCompress(new File(f.parent.nativePath+File.separator+f.name+"_s"),c);
					}else{
						write.write(new File(f.parent.nativePath+File.separator+f.name+"_s"),c);
					}
				}
			}
		}
		
		
		
	}
}
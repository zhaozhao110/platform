package com.editor.popup.editImage
{
	import com.air.io.FileUtils;
	import com.air.io.SelectFile;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.popup.editImage.component.EditImagePopwinTab3Image;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class EditImagePopwinTab3 extends UIVBox
	{
		public function EditImagePopwinTab3()
		{
			super();
		}
		
		private var fileTI:UITextInput;
		private var foldTi:UITextInput;
		private var logTxt:UITextArea;
		
		override public function delay_init():Boolean
		{
			styleName = "uicanvas"
				
			lb = new UILabel();
			lb.text = "生成的文件会保存在项目的目录下,目录名不要有中文"
			addChild(lb);
			
			var h:UIHBox = new UIHBox();
			h.height = 35;
			h.width = 800;
			h.styleName = "uicanvas"
			h.verticalAlignMiddle = true
			h.horizontalGap = 10;
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "选择png文件"
			h.addChild(lb);
			
			fileTI = new UITextInput();
			fileTI.percentWidth = 100;
			h.addChild(fileTI);
			
			var btn:UIButton = new UIButton();
			btn.label = "选择"
			btn.addEventListener(MouseEvent.CLICK , onFileClick);
			h.addChild(btn);
			
			btn = new UIButton();
			btn.label = "打开"
			btn.addEventListener(MouseEvent.CLICK , onFileClick2);
			h.addChild(btn);
			
			//////////////////////////////////////////////////////
			
			h = new UIHBox();
			h.height = 35;
			h.width = 800;
			h.verticalAlignMiddle = true
			h.horizontalGap = 10;
			addChild(h);
			
			lb = new UILabel();
			lb.text = "选择目录"
			h.addChild(lb);
			
			foldTi = new UITextInput();
			foldTi.percentWidth = 100;
			h.addChild(foldTi);
			
			btn = new UIButton();
			btn.label = "选择"
			btn.addEventListener(MouseEvent.CLICK , onFoldClick);
			h.addChild(btn);
			
			btn = new UIButton();
			btn.label = "打开"
			btn.addEventListener(MouseEvent.CLICK , onFoldClick2);
			h.addChild(btn);
			
			////////////////////////////////////////////////////
			
			h = new UIHBox();
			h.height = 35;
			h.width = 800;
			h.verticalAlignMiddle = true
			h.horizontalGap = 10;
			addChild(h);
			
			mipmapCB = new UICheckBox();
			mipmapCB.label = "mipmap贴图"
			mipmapCB.selected = true;
			h.addChild(mipmapCB);
			
			
			logTxt = new UITextArea();
			logTxt.enabledPercentSize = true;
			logTxt.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(logTxt);
			
			return true;
		}
		
		private var mipmapCB:UICheckBox;
		
		private function onFileClick(e:MouseEvent):void
		{
			var a:Array = [];
			a.push(new FileFilter("png","*.png"))
			//a.push(new FileFilter("jpg","*.jpg"))
			SelectFile.select("png",a,fileResult);
		}
		
		private var fileCmd:EditImagePopwinTab3Image
		
		private function fileResult(e:Event):void
		{
			var f:File = e.target as File;
			fileTI.text = f.parent.nativePath;
			if(fileCmd == null){
				fileCmd = new EditImagePopwinTab3Image();
				fileCmd.appendLog_f = appendLog;
			}
			fileCmd.mipmap = mipmapCB.selected;
			fileCmd.convert(f);
		}
		
		private function onFileClick2(e:MouseEvent):void
		{
			FileUtils.openFold(fileTI.text);
		}
		
		private function onFoldClick(e:MouseEvent):void
		{
			logTxt.htmlText = "";
			SelectFile.selectDirectory("png fold",foldResult);
		}
		
		private var foldCmd:EditImagePopwinTab3Image
		
		private function foldResult(e:Event):void
		{
			var f:File = e.target as File;
			foldTi.text = f.nativePath;
			if(foldCmd == null){
				foldCmd = new EditImagePopwinTab3Image();
				foldCmd.appendLog_f = appendLog;
			}
			foldCmd.mipmap = mipmapCB.selected;
			foldCmd.convertFold(f);
		}
		
		private function appendLog(s:String):void
		{
			logTxt.appendHtmlText(s);
		}
		
		private function onFoldClick2(e:MouseEvent):void
		{
			FileUtils.openFold(fileTI.text);
		}
		
		public function delPopwin():void
		{
			if(fileCmd!=null)fileCmd.dispose();
			if(foldCmd!=null)foldCmd.dispose();
		}
	}
}
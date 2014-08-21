package com.editor.popup.packImage
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.model.AppMainModel;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.editor.vo.global.AppStorageConfFile;
	import com.sandy.asComponent.event.ASEvent;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.air.net.CallCMDProccess;
	import com.air.net.CallJavaProccess;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class PackImagePopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "PackImagePopwinMediator"
		public function PackImagePopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);	
		}
		public function get packWin():PackImagePopwin
		{
			return viewComponent as PackImagePopwin
		}
		public function get text():UITextArea
		{
			return packWin.text;
		}
		public function get textInput():UITextInputWidthLabel
		{
			return packWin.textInput;
		}
		public function get selectBtn():UIButton
		{
			return packWin.selectBtn;
		}
		public function get textInput2():UITextInputWidthLabel
		{
			return packWin.textInput2;
		}
		public function get selectBtn2():UIButton
		{
			return packWin.selectBtn2;
		}
		public function get packBtn():UIButton
		{
			return packWin.packBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			call.addEventListener(ASEvent.CHANGE,outputChange)
				
			cmd.addEventListener(ASEvent.CHANGE,cmdOutputChange)
			cmd.start();
			cmd.write("set");

			text.htmlText += "获取系统变量JAVA_HOME"+"/r";
		}		
		
		private function cmdOutputChange(e:ASEvent):void
		{
			//JAVA_HOME=C:\Program Files\Java\jdk1.6.0_37
			var s:String = e.data;
			if(!StringTWLUtil.isWhitespace(s)){
				var a:Array = s.split(StringTWLUtil.NEWLINE_SIGN);
				for(var i:int=0;i<a.length;i++){
					var ss:String = a[i];
					if(!StringTWLUtil.isWhitespace(ss)){
						var aa:Array = ss.split("=");
						if(aa[0] == "JAVA_HOME"){
							javaHome = aa[1];
							textInput.text = javaHome;
							AppMainModel.getInstance().applicationStorageFile.putKey_javaHome(javaHome);
							text.htmlText += "获取系统变量成功"+"/r";
							break
						}
					}
				}
			}
		}
		
		override public function callDelPopWin():void
		{
			super.callDelPopWin();
			cmd.stop();
		}
		
		private var javaHome:String;
		private var selectDir:File;
		private var createFile:WriteFile = new WriteFile();
		private var call:CallJavaProccess = new CallJavaProccess();
		private var cmd:CallCMDProccess = new CallCMDProccess();
		private var resId:String
		
		public function reactToSelectBtnClick(e:MouseEvent):void
		{
			SelectFile.selectDirectory("jre目录",onSelectHandle);
		}
		
		private function onSelectHandle(e:Event):void
		{
			textInput.text = File(e.target).nativePath;
		}
		
		public function reactToSelectBtn2Click(e:MouseEvent):void
		{
			SelectFile.selectDirectory("图片目录",onSelect2Handle);
		}
		
		private function onSelect2Handle(e:Event):void
		{
			selectDir = File(e.target)
			textInput2.text = selectDir.nativePath;
			parser()
		}
		
		private function parser():void
		{
			createFile.write(new File(AppStorageConfFile.getStorageDirt()+File.separator+"packImageXML.xml"),createXML());
			text.htmlText += "写入配置文件成功"+"/r";
		}
		
		private function createXML():XML
		{
			var x:XML = <lib allowDomain="*" />;
			var a:Array = selectDir.getDirectoryListing();
			for(var i:int=0;i<a.length;i++)
			{
				var fl:File = a[i] as File;
				if(fl.extension == "jpg" || fl.extension == "png"){
					var resName:String = fl.name.split(".")[0];
					resId = resName.split("_")[0];
					var s:String = '<bitmapdata file="'+fl.nativePath+'" class="e'+resName+'" quality="80" compression="true"/>'
					x.appendChild(XML(s));
				}else{
					showError("打包只能处理图片,存在非法文件");
				}
			}
			return x;
		}
		
		public function reactToPackBtnClick(e:MouseEvent):void
		{
			//java -jar Swift.jar xml2lib lib.xml lib.swf
			var arg:Vector.<String> = new Vector.<String>;
			arg.push("-jar");
			arg.push(File.applicationDirectory.resolvePath("jar/Swift.jar").nativePath);
			arg.push("xml2lib");
			arg.push(AppStorageConfFile.getStorageDirt()+File.separator+"packImageXML.xml");
			arg.push(textInput2.text+File.separator+resId+".swf");
			
			call.start(textInput.text,arg);
		}
		
		private function outputChange(e:ASEvent):void
		{
			var out:String = e.data;
			text.htmlText += out+"/r";
			if(out.indexOf("successfully")!=-1){
				showMessage("打包成功");
			}
			else if(out.indexOf("java.io")!=-1){
				showMessage("打包出错");
			}
		}
	}
}
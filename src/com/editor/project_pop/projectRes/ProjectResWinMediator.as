package com.editor.project_pop.projectRes
{
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.air.utils.AIRUtils;
	import com.air.utils.ZipPack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.project_pop.projectRes.vo.ProjectResConfigVO;
	import com.editor.project_pop.projectRes.vo.ProjectResItemVO;
	import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
	import com.editor.services.Services;
	import com.editor.tool.project.jsfl.CompileFla;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.common.zip.ZIP;
	import com.sandy.common.zip.ZIPFileVO;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.net.json.SandyJSON;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	public class ProjectResWinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ProjectResWinMediator"
		public function ProjectResWinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resWin():ProjectResWin
		{
			return viewComponent as ProjectResWin
		}
		public function get selectBtn():UIButton
		{
			return resWin.selectBtn;
		}
		public function get textInput():UITextInputWidthLabel
		{
			return resWin.textInput;
		}
		public function get clientBtn():UIButton
		{
			return resWin.clientBtn;
		}
		public function get config3Btn():UIButton
		{
			return resWin.config3Btn;
		}
		public function get txt():UITextArea
		{
			return resWin.txt;
		}
		public function get openPackBtn():UIButton
		{
			return resWin.openPackBtn;
		}
		public function get reZipBtn():UIButton
		{
			return resWin.reZipBtn;
		}
		public function get createBtn():UIButton
		{
			return resWin.createBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var url:String = AppMainModel.getInstance().applicationStorageFile.curr_project;
			textInput.text = url;
			
			openSelectProject();
			
			txt.appendHtmlText("数据库中配置该项目客户端要打包:")
			var a:Array = projectItem.swf_ls;
			var b:Array = [];
			for(var i:int=0;i<a.length;i++){
				
				var f:File = new File(AppMainModel.getInstance().applicationStorageFile.curr_project + File.separator+a[i]);
				if(f.exists){
					b.push(a[i] + " , size: " + FileUtils.getFileSize(f.nativePath)+"K");
				}
			}
			txt.appendHtmlText(b.join("<br>"));
		}
		
		private var projectItem:ProjectResItemVO; 
		
		private function openSelectProject():void
		{
			var obj:SelectProjectPopwinVO = new SelectProjectPopwinVO;
			obj.data = ProjectResConfigVO.instance.project_ls.list;
			obj.labelField = "name";
			obj.callFun = selectProjectCallBackFun
			sendAppNotification(AppEvent.selectProject_event,obj);
		}
		 
		private function selectProjectCallBackFun(item:ProjectResItemVO):void
		{
			projectItem = item;
		}
		
		public function reactToSelectBtnClick(e:MouseEvent):void
		{
			SelectFile.selectDirectory("选择项目的目录",onSelectHandle);
		}
		
		private function onSelectHandle(e:Event):void
		{
			AppMainModel.getInstance().applicationStorageFile.putKey_project(File(e.target).nativePath);
			textInput.text = File(e.target).nativePath;
		}
		
		public function reactToClientBtnClick(e:MouseEvent):void
		{
			var filesArr:Array = projectItem.swf_ls;
			if (filesArr.length)
			{
				txt.appendHtmlText("请等待，直到打印出打包成功信息");
								
				var fileInfoArr:Array = [];
				for(var i:int=0;i<filesArr.length;i++){
					var file:File = new File(textInput.text + filesArr[i]);
					fileInfoArr.push(file);
				}
				
				var pack:ZipPack = new ZipPack();
				pack.pack(fileInfoArr,new File(textInput.text + projectItem.saveURL));
				
				txt.appendHtmlText("打包成功,打包文件大小:"+FileUtils.getFileSize(textInput.text + projectItem.saveURL)+"K");
			}
			else
			{
				txt.appendHtmlText('请先选择需要进行压缩的文件');
			}
		}
		
		public function reactToOpenPackBtnClick(e:MouseEvent):void
		{
			var f:File = new File(textInput.text + projectItem.saveURL);
			FileUtils.openFold(f.parent.nativePath);
		}
		
		public function reactToConfig3BtnClick(E:MouseEvent):void
		{
			/*var http:AS3HTTPServiceLocator = new AS3HTTPServiceLocator();
			var varia:URLVariables = new URLVariables()
			varia.project = AppMainModel.getInstance().selectProject.data; 
			varia.fileName = "config3.swf"
			http.args = varia;
			http.sucResult_f = httpResult;
			http.conn(projectItem.config3,SandyEngineConst.HTTP_GET,SandyEngineConst.resultFor_obj_type);*/
			
			SelectFile.selectDirectory("选择要打包的目录",onResult2);
		}
		
		private function onResult2(e:Event):void
		{
			var file:File = e.target as File;
			var pack:ZipPack = new ZipPack();
			pack.pack(file.getDirectoryListing(),new File(file.parent.nativePath+File.separator+file.name+".swf"));
		}
		
		private function httpResult(d:*):void
		{
			var obj:Object = SandyJSON.parser(d);
			if(obj.code == 0){
				txt.appendHtmlText("config3打包成功");
			}else{
				txt.appendHtmlText("config3打包失败");
			}
		}
		
		public function reactToReZipBtnClick(e:MouseEvent):void
		{
			var txtFilter:FileFilter = new FileFilter("swf", "*.swf");
			SelectFile.select("压缩文件",[txtFilter],selectReZip)
		}
		
		private function selectReZip(e:Event):void
		{
			var file:File = e.target as File;
			
			var read:ReadFile = new ReadFile();
			var byte:ByteArray = read.read(file.nativePath,ReadFile.READTYPE_BYTEARRAY);
			
			var list:Array = [];
			var zip:ZIP = new ZIP(byte);
			for (var i:int = 0, len:int = zip.entries.length; i < len; i++)
			{
				var fileVO:ZIPFileVO = zip.entries[i] as ZIPFileVO;
				var outStr:* = zip.getInput(fileVO);
				list[fileVO.fileName] = outStr;	
			}
			
			WriteFile.createDirectory(File(file.parent).nativePath+File.separator+file.name.split(".")[0])
			
			for(var fileName:String in list){
				var write:WriteFile = new WriteFile();
				write.write(new File(File(file.parent).nativePath+File.separator+file.name.split(".")[0]+File.separator+fileName),list[fileName]);
				trace(File(file.parent).nativePath+File.separator+file.name.split(".")[0]+File.separator)
			}
		}
		
		public function reactToCreateBtnClick(e:MouseEvent):void
		{
			var a:Array = [];
			var filesArr:Array = projectItem.swf_ls;
			if (filesArr.length){
				for(var i:int=0;i<filesArr.length;i++){
					var swf:File = new File(textInput.text+filesArr[i]);
					var fla:File = new File(textInput.text+projectItem.fla_ls[i]);
					a.push({fla:fla,swf:swf});
				}
			}
			var c:CompileFla = new CompileFla();
			c.compile(a)
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace2(n:int=1):String
		{
			return StringTWLUtil.createSpace(n,"	")
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en(n)
		}
	}
}
package com.editor.command
{
	import com.air.render2D.SandyAirApplication;
	import com.air.thread.ThreadLoader;
	import com.air.thread.ThreadManager;
	import com.air.thread.ThreadMessageData;
	import com.asparser.Field;
	import com.asparser.Parser;
	import com.asparser.TokenColor;
	import com.asparser.TokenConst;
	import com.asparser.TypeDB;
	import com.asparser.TypeDBCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.ViewManager;
	import com.editor.module_code.event.CodeEvent;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.popup.plusWin.PlusPopWin;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.controls.data.ASTreeDataProvider;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class BackgroundThreadCommand extends AppCommandMediator
	{
		public static const NAME:String = "BackgroundThreadCommand"
		public function BackgroundThreadCommand(viewComponent:Object=null)
		{
			super(NAME, viewComponent);	
			instance = this;
		}
		
		public static var instance:BackgroundThreadCommand;
		
		public function respondToBackThreadStartEvent(noti:Notification):void
		{
			sendAppNotification(AppEvent.add_preLoader_msg_event,"开启一个新线程");
		}
		
		///////////////////////////////////////////////////////////////////////////
		
		
		
		//解析项目的结构
		public function cacheProject():void
		{
			if(!ThreadManager.createThreaded) return ;
			ThreadManager.getThread(1).send(["cacheProject",ProjectCache.getInstance().currEditProjectFile.nativePath]);
		}
		
		//解析每个as文件的内容
		public function parserProject():void
		{
			if(!ThreadManager.createThreaded) return ;
			//background
			if(engineEditor.userThread){
				ThreadManager.getThread(2).send(["parserProject",ProjectCache.getInstance().getProjectSrcURL()])
			}else{
				Parser.parserDirectory(new File(ProjectCache.getInstance().getProjectSrcURL()),["as"]);
			}
		}
		
		//解析一些文件
		public function parserFiles(a:Array):void
		{
			if(!ThreadManager.createThreaded) return ;
			ThreadManager.getThread(2).send(["parserFiles",a])
		}
		
		public function parserApi(a:Array):void
		{
			if(!ThreadManager.createThreaded) return ;
			ThreadManager.getThread(1).send(["parserApi",a[0],a[1],a[2]])
		}
		
		///////////////////////////////////////// editor ///////////////////////////////////
		
		//上色
		public function colorAS(file:*,cont:String):void
		{
			if(!ThreadManager.createThreaded) return ;
			if(file is File){
				ThreadManager.getThread(1).send(["colorAS",file.nativePath,cont])
			}else{
				ThreadManager.getThread(1).send(["colorAS",file,cont])
			}
		}
		
		//解析单个文
		public function parserAS(filePath:String):void
		{
			if(!ThreadManager.createThreaded) return ;
			ThreadManager.getThread(2).send(["parserAS",filePath])
		}
		
		public function formatAS(path:String,cont:String):void
		{
			if(!ThreadManager.createThreaded) return ;
			ThreadManager.getThread(3).send(["formatAS",path,cont])
		}
		
		private var _local_search_s:String;
		public function local_search(cont:String,c:String,big:Boolean,isReplace:String='null'):void
		{
			if(!ThreadManager.createThreaded) return ;
			_local_search_s = c+"/"+big+"/"+isReplace;
			isReplace = StringTWLUtil.removeNewlineChar(isReplace);
			ThreadManager.getThread(3).send(["local_search",cont,c,big,isReplace])
		}
		
		////////////////////////////////////////////////////////////////////////////
				
		
		//样式改变
		public function editorStyleChange():void
		{
			if(!ThreadManager.createThreaded) return ;
			var obj:Object = {};
			obj.fontSize = TokenColor.fontSize
			obj.fontColor = TokenColor.fontColor;
			obj.editBackgroundColor = TokenColor.editBackgroundColor
			obj.infoColor = TokenConst.getColor(5).color;
			obj.stringColor = TokenConst.getColor(4).color;
			obj.lineNumColor = TokenColor.lineNum_color;
			obj.lineColor = TokenColor.lineColor;
				
			ThreadManager.getThread(1).send(["editorStyleChange",obj])
			ThreadManager.getThread(2).send(["editorStyleChange",obj])
			ThreadManager.getThread(3).send(["editorStyleChange",obj])
		}
		
		private var _global_search_s:String
		//search
		public function global_search(cont:String,path:String,big:Boolean,isReplace:String='null'):void
		{
			if(!ThreadManager.createThreaded) return ;
			if(StringTWLUtil.isWhitespace(cont) || StringTWLUtil.isWhitespace(path)){
				return ;
			}
			_global_search_s = cont+"/"+path+"/"+big+"/"+isReplace;
			ThreadManager.getThread(3).send(["global_search",cont,path,TypeDBCache.hash,big,isReplace])
		}
		
		private var _global_replace_s:String
		//search
		public function global_replace(cont:String,path:String,big:Boolean,isReplace:String='null'):void
		{
			if(!ThreadManager.createThreaded) return ;
			if(StringTWLUtil.isWhitespace(cont) || StringTWLUtil.isWhitespace(path)){
				return ;
			}
			_global_replace_s = cont+"/"+path+"/"+big+"/"+isReplace;
			ThreadManager.getThread(3).send(["global_replace",cont,path,TypeDBCache.hash,big,isReplace])
		}
		
		public function copyFiles(a:Array):void
		{
			if(!ThreadManager.createThreaded) return ;
			if(a == null) return 
			if(a.length == 0) return 
			ThreadManager.getThread(3).send(["copyFiles",a]);
		}
		
		
		//解析3d项目每个文件的内容
		public function parser3DProject(f:File):void
		{
			if(!ThreadManager.createThreaded) return ;
			//background
			ThreadManager.getThread(2).send(["parser3DProject",f.nativePath])
		}
		
		///////////////////////////////////////////////////////////////////////////
		
		public function respondToMainThreadReceiveEvent(noti:Notification):void
		{
			var d:ThreadMessageData = noti.getBody() as ThreadMessageData;
			if(d.sign == "cacheProject")
			{
				var dp:ASTreeDataProvider = d.data as ASTreeDataProvider;
				var a:Array = dp.all_ls.source;
				var n:int = a.length;
				for(var i:int=0;i<n;i++){
					var tree:ASTreeData = a[i];
					if(dp.all_map_ls[tree.getId2()]!=null){
						tree.list = dp.all_map_ls[tree.getId2()];
					}
				}
				ProjectCache.getInstance().cache = dp;
			}
			else if(d.sign == "parserProject")
			{
				var obj1:Object = d.data;
				var obj_a:Object = d.data2;
				//member
				var obj2:Object = obj_a.members;
				//import
				var obj3:Object = obj_a.imports;
				//locale
				TypeDBCache.locales = obj_a.locales;
				//array
				TypeDBCache.array_ls = d.data3
				//hash
				TypeDBCache.hash_ls = d.data4;
				
				for(var key:String in obj1){
					(obj1[key] as TypeDB).setMember(obj2[key]);
					(obj1[key] as TypeDB).setImport(obj3[key]);
					(obj1[key] as TypeDB).createRows();
				}
				
				ProjectCache.getInstance().cacheTypeDB(obj1);
				sendAppNotification(CodeEvent.parserProject_complete_event);
				trace("解析类结构完成");
			}
			else if(d.sign == "colorAS")
			{
				var form_ls:Array = d.data as Array;
				var file:String = d.data2;
				if(file  == "apiCode"){
					routeNotification("parserApiCodeCodeEvent",form_ls,null,PlusPopWin.api_multitonKey);
				}else{
					sendAppNotification(CodeEvent.codeEditor_color_event,form_ls,file);
				}
			}
			else if(d.sign == "parserAS")
			{
				var _type2:TypeDB = d.data as TypeDB;
				_type2.setMember(d.data2);
				_type2.setImport(d.data3);
				ProjectCache.getInstance().addTypeDB(_type2);
				
				sendAppNotification(CodeEvent.parserAS_complete_event,_type2.filePath);
			}
			else if(d.sign == "parserApi_log")
			{
				sendAppNotification("apiAddLogEvent",d.data);	
			}
			else if(d.sign == "parserApi")
			{
				if(StringTWLUtil.isWhitespace(d.error)){
					showMessage("api解析结束，请查看db");	
				}else{
					showMessage(d.error);
				}
				sendAppNotification("parserApiEndEvent");
			}
			else if(d.sign == "reportError")
			{
				showMessage(d.error);
			}
			else if(d.sign == "formatAS")
			{
				sendAppNotification(CodeEvent.formatAS_complete_event,d.data,d.data2);
			}
			else if(d.sign == "global_search")
			{
				if(_global_search_s != d.data3) return ;
				ViewManager.getInstance().openView(DataManager.pop_search);
				sendAppNotification(CodeEvent.globalSearch_complete_event,d.data);
			}
			else if(d.sign == "local_search")
			{
				if(_local_search_s != d.data4) return ;
				sendAppNotification(CodeEvent.localSearch_complete_event,d);
			}
			else if(d.sign == "global_replace")
			{
				if(_global_replace_s != d.data3) return ;
				ViewManager.getInstance().openView(DataManager.pop_search);
				sendAppNotification(CodeEvent.globalSearch_complete_event,d.data);
			}
			else if(d.sign == "copyFiles")
			{
				showMessage("复制成功");	
			}
			else if(d.sign == "parser3DProject")
			{
				D3ProjectFilesCache.getInstance().reflashProjectCache(d);
			}
		}
		  
		
		
	}
}
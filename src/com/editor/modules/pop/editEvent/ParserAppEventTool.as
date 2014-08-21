package com.editor.modules.pop.editEvent
{
	import com.asparser.ClsAttri;
	import com.asparser.ClsDB;
	import com.asparser.ClsUtils;
	import com.asparser.Parser;
	import com.asparser.TypeDB;
	import com.asparser.TypeDBCache;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.tool.project.create.CreateCommandTool;
	import com.editor.tool.project.create.CreateInterceptorTool;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class ParserAppEventTool
	{
		public function ParserAppEventTool(m:AppEditEventPopWinMediator)
		{
			mediator = m;
		}
		
		private var mediator:AppEditEventPopWinMediator;
		public var db:ClsDB;
		public var path:String;
		private var cont:String;
		private var cont_a:Array = [];
		private var read:ReadFile = new ReadFile();
		private var write:WriteFile = new WriteFile();
		private var file:File;
		
		public function parser(_path:String):void
		{
			path = _path;
			file = new File(path);
			reflashFile()
			
			Parser.addSourceFile(cont,path,_parserComplete);
		}
		
		private function _parserComplete(f:String=null):void
		{
			db = new ClsDB(TypeDBCache.getDB(path));
			
			var attri_ls:Array = db.members;
			var attri_a:Array = [];
			var a:Array = StringTWLUtil.splitNewline(cont);
			cont_a = null;cont_a = [];
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(a[i])){
					cont_a.push(a[i]);
				}
			}
			for each(var attri:ClsAttri in attri_ls){
				if(attri!=null){
					attri.getInfo(cont_a);
					attri_a.push(attri);
				}
			}
			mediator.event_vb.dataProvider = attri_a.sortOn("name");
		}
		
		public function reflashFile():void
		{
			cont = read.read(path);
		}
		
		private function reflash():void
		{
			var attri_ls:Array = db.members;
			var attri_a:Array = [];
			for each(var attri:ClsAttri in attri_ls){
				if(attri!=null){
					attri_a.push(attri);
				}
			}
			mediator.event_vb.dataProvider = attri_a.sortOn("name");
		}
		
		public function add(nm:String,info:String):void
		{
			if(db.haveMember(nm)) return ;
			if(!StringTWLUtil.isWhitespace(info)&&info.indexOf("/*")==-1){
				if(info.indexOf("//")==-1){
					info = "/**"+info+"*/"
				}
			}
			var cls:ClsAttri = new ClsAttri();
			cls.name = nm;
			cls.info = info;
			cls.value = StringTWLUtil.setAllFristUpperChar(cls.name);
			cls.className = "String"
			db.add_member(cls);
			reflash();
		}
		
		public function change(nm:String,info:String):void
		{
			if(info.indexOf("/*")==-1){
				if(info.indexOf("//")==-1){
					info = "/**"+info+"*/"
				}
			}
			var attri:ClsAttri = db.get_member(nm);
			if(attri!=null){
				attri.info= info;
			}
		}
		
		public function del(nm:String):void
		{
			db.remove_member(nm);
			mediator.eventTi.text = "";
			mediator.infoTi.htmlText = "";
			reflash();
		}
		
		public function pub():void
		{
			var c:String = "package " + ClsUtils.getClassPackage(file)+NEWLINE_SIGN;
			c += "{"+NEWLINE_SIGN;
			c += createSpace()+"public class "+file.name.split(".")[0]+NEWLINE_SIGN;
			c += createSpace()+"{"+NEWLINE_SIGN;
			
			var attri_ls:Array = db.members;
			var attri_a:Array = [];
			for each(var attri:ClsAttri in attri_ls){
				if(attri!=null){
					attri_a.push(attri);
				}
			}
			attri_a = attri_a.sortOn("name");
			for(var i:int=0;i<attri_a.length;i++){
				c += ClsAttri(attri_a[i]).getAS3();
			}
			
			c += createSpace()+"}"+NEWLINE_SIGN;
			c += "}"
			write.write(file,c);
		}
		
		public function createCommand(attri:ClsAttri):void
		{
			var open:OpenMessageData = new OpenMessageData();
			open.info = "系统将会在com/rpg/command/action/下生成代码，您确定执行?"
			open.okFunction = _createCommand
			open.okFunArgs = attri;
			SandyManagerBase.getInstance().showConfirm(open);
		}

		private function _createCommand(attri:ClsAttri):Boolean
		{
			var tool:CreateCommandTool = new CreateCommandTool();
			tool.create(attri.name,attri.getCommandName());
			return true
		}
		
		public function createInterceptor(attri:ClsAttri):void
		{
			var open:OpenMessageData = new OpenMessageData();
			open.info = "系统将会在com/rpg/command/interceptor/下生成代码，您确定执行?"
			open.okFunction = _createInterceptor
			open.okFunArgs = attri;
			SandyManagerBase.getInstance().showConfirm(open);
		}
		
		private function _createInterceptor(attri:ClsAttri):Boolean
		{
			var tool:CreateInterceptorTool = new CreateInterceptorTool();
			tool.create(attri.name,attri.getCommandName());
			return true
		}
			
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n)
		}
		
	}
}
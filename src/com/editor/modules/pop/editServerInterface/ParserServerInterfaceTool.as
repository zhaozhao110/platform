package com.editor.modules.pop.editServerInterface
{
	import com.asparser.ClsAttri;
	import com.asparser.ClsDB;
	import com.asparser.ClsUtils;
	import com.asparser.Parser;
	import com.asparser.TypeDB;
	import com.asparser.TypeDBCache;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.tool.project.create.CreateCommandTool;
	import com.editor.tool.project.create.CreateInterceptorTool;
	import com.editor.project_pop.serverCode.CreateServerCodeVO;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	
	public class ParserServerInterfaceTool 
	{
		public function ParserServerInterfaceTool(m:EditServerInterfacePopwinMediator)
		{
			mediator = m;
		}
		
		private var mediator:EditServerInterfacePopwinMediator;
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
			if(!StringTWLUtil.isWhitespace(info) && info.indexOf("/*")==-1){
				if(info.indexOf("//")==-1){
					info = "/**"+info+"*/"
				}
			}
			var cls:ClsAttri = new ClsAttri();
			cls.name = StringTWLUtil.trim(nm.split("=")[0]);
			cls.value = nm.split("=")[1];
			cls.info = info;
			cls.className = "String"
			db.add_member(cls);
			reflash();
		}
		
		public function change(oldAttri:ClsAttri,nm:String,info:String):void
		{
			db.remove_member(oldAttri.name);
			add(nm,info);
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
				c += ClsAttri(attri_a[i]).getAS();
			}
			
			c += createSpace()+"}"+NEWLINE_SIGN;
			c += "}"
			write.write(file,c);
		}
		
		public function createSocketCode(attri:ClsAttri):void
		{
			//SandyManagerBase.getInstance().closePoupwin(PopupwinSign.EditServerInterfacePopwin_sign);
			
			var d:CreateServerCodeVO = new CreateServerCodeVO();
			d.funName = StringTWLUtil.setAllFristUpperChar(attri.name)
			d.info = attri.info;
			var open2:OpenPopwinData = new OpenPopwinData();
			open2.data = d;
			open2.popupwinSign = PopupwinSign.CreateServerCodePopwin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open2.openByAirData = opt;
			SandyManagerBase.getInstance().openPopupwin(open2);
		}
		
		private function _createCommand(attri:ClsAttri):Boolean
		{
			var tool:CreateCommandTool = new CreateCommandTool();
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
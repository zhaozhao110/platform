package com.editor.modules.pop.editPopwin
{
	import com.asparser.ClsAttri;
	import com.asparser.ClsDB;
	import com.asparser.ClsUtils;
	import com.asparser.Parser;
	import com.asparser.TypeDB;
	import com.asparser.TypeDBCache;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.event.AppEvent;
	import com.editor.tool.project.del.ProjectFileDelTool;
	import com.editor.tool.project.rename.ProjectFileRenameTool;
	import com.editor.module_ui.vo.OpenFileInUIEditorEventVO;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.modules.pop.createClass.AppCreateClassFilePopwinVO;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class EditPopPopwinTool
	{
		public function EditPopPopwinTool(m:EditPopPopwinMediator)
		{
			mediator = m;
			
		}
		
		private var mediator:EditPopPopwinMediator;
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
			cont = read.readFromFile(file);
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
					attri.name = StringTWLUtil.trim(attri.name.split("_")[0]);
					attri_a.push(attri);
				}
			}
			mediator.event_vb.dataProvider = attri_a.sortOn("name");
		}
		
		public function pub():void
		{
			if(db == null) return ;
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
				c += ClsAttri(attri_a[i]).getAS2();
			}
			
			c += createSpace()+"}"+NEWLINE_SIGN;
			c += "}"
			write.write(file,c);
		}
		
		public function del(it:ClsAttri):void
		{
			var tool:ProjectFileDelTool = new ProjectFileDelTool();
			tool.del(it.getValueFile(ProjectCache.getInstance().getProjectSrcURL()).parent.parent);
			
			parser(path);
		}
		
		public function open(it:ClsAttri):void
		{
			SandyEngineGlobal.iManager.sendAppNotification(AppEvent.openFold_event,it.getValueFile(ProjectCache.getInstance().getProjectSrcURL()).parent.parent);
		}
		
		public function rename(it:ClsAttri,newName:String):void
		{
			var tool:ProjectFileRenameTool = new ProjectFileRenameTool();
			tool.rename(it.name,newName,it.getValueFile(ProjectCache.getInstance().getProjectSrcURL()));
			
			parser(path);
		}
		
		public function edit(it:ClsAttri):void
		{
			var ui_d:OpenFileInUIEditorEventVO = new OpenFileInUIEditorEventVO();
			ui_d.file = it.getValueFile();
			ui_d.type = AppCreateClassFilePopwinVO.file_type3;
			SandyEngineGlobal.iManager.sendAppNotification(AppModulesEvent.openFile_inUIEditor_event,ui_d)
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n)
		}
	}
}
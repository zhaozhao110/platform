package com.editor.module_ui.ui
{
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.manager.StackManager;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.ui.vo.CreateUIFileCompAttri;
	import com.editor.module_ui.ui.vo.CreateUIFileCompAttriGroup;
	import com.editor.module_ui.ui.vo.InvertedGroupVO;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.UIComponentData;
	import com.editor.module_ui.vo.UICreateData;
	import com.editor.module_ui.vo.UITreeNode;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	import flash.filters.BlurFilter;
	import flash.utils.ByteArray;

	public class CreateUIXML
	{
		public function CreateUIXML()
		{
		}
		
		private function get uiData():UIComponentData
		{
			return target.uiData;
		}
		private var write:WriteFile = new WriteFile();
		public var target:UIShowContainer;
				
		//creaet xml
		public function create():Boolean
		{
			if(UIEditManager.currEditShowContainer.cache.checkIsSameId()){
				return false;
			}
			var c:String = "<!--author by ["+AppMainModel.getInstance().user.shortName+"], please not delete -->"; 
			c += '<?xml version="1.0" encoding="UTF-8"?>';
			c += "<list>";
			c += '<backImage x="'+UIEditManager.currEditShowContainer.background.x+'" y="'+UIEditManager.currEditShowContainer.background.y+'" />'+NEWLINE_SIGN;
			
			var a:Array = UIEditManager.currEditShowContainer.cache.invertedGroup_ls;
			for(var i:int=0;i<a.length;i++){
				var g:InvertedGroupVO = a[i] as InvertedGroupVO;
				c += g.getXML();
			}
			
			a = UIEditManager.currEditShowContainer.cache.tree.getAllList();
			var expandCompXML:Array = [];
			for each(var p:UITreeNode in a){
				if(p!=null){
					if(p.obj is UIShowCompProxy){
						var x:String = UIShowCompProxy(p.obj).data.getXML();
						if(x == "error"){
							return false;
						}
						c += x;
						var exp:XML = UIShowCompProxy(p.obj).data.getExpandCompsXML();
						if(exp!=null){
							expandCompXML.push(exp);
						}
					}
				}
			}
			c += "</list>";
			var haveFile:Boolean;
			haveFile = uiData.getXMLFile().exists;
			var be:ByteArray = new ByteArray();
			be.writeUTFBytes(c);
			be.compress();
			write.write(uiData.getXMLFile(),be);
			
			var f:File = new File(uiData.getXMLFile().parent.nativePath);
			UIEditManager.getInstance().writeCmd("attrib +H /D /S "+f.nativePath);
			
			ProjectAllUserCache.getInstance().reflashExpandComp(expandCompXML);
			if(!haveFile){
				SandyEngineGlobal.iManager.sendAppNotification(AppModulesEvent.reflashProjectDirect_event);
			}
			return true;
		}
		
		
		public static const as_1:String = "////////////////////////////////////////////editor//////////////////////////////////////////////"
		public static const as_2:String = "////////////////////////////////////////////end//////////////////////////////////////////////"
		public static const as_3:String = "/////////////////// 编辑器生成，不能修改，如果出现问题，可以在编辑器里重新生成  ////////////////"
		public static var cacheGetAS_ls:Array = [];
			
		public function createAS():void
		{
			cacheGetAS_ls = null;cacheGetAS_ls = [];
			var fl:File = uiData.getASFile();
			if(!fl.exists) return ;
			var read:ReadFile = new ReadFile();
			var cont:String = read.readFromFile(fl);

			if(cont.indexOf("{")==-1){
				StackManager.getInstance().addCurrLogCont("界面编辑器中,文件格式不对,"+fl.nativePath);
				return ;
			}
			
			var vas_s:String = "";
			var comp_a:Array = [];
			var comp_s:String = "";
			var imports:Array = [];
			var all_comp_ls:Array = [];
			
			a = UIEditManager.currEditShowContainer.cache.invertedGroup_ls;
			for(var i:int=0;i<a.length;i++){
				var ig:InvertedGroupVO = a[i] as InvertedGroupVO;
				var ig_d:UICreateData = ig.getAS(cont);
				if(ig_d!=null){
					comp_s += ig_d.comp;
					vas_s += ig_d.vars+NEWLINE_SIGN;
					imports = imports.concat(ig_d.imports);
				}
			}
			
			a = UIEditManager.currEditShowContainer.cache.tree.getAllList();
			for each(var p:UITreeNode in a){
				if(p!=null){
					if(p.obj is UIShowCompProxy){
						var cpd:ComponentData = UIShowCompProxy(p.obj).data;
						var d:UICreateData = cpd.getAS(cont);
						vas_s += d.vars+NEWLINE_SIGN;
						imports = imports.concat(d.imports);
						var attr:CreateUIFileCompAttri = new CreateUIFileCompAttri();
						attr.compData = cpd;
						attr.attri_ls = cpd.attriObj;
						if(comp_a[cpd.parent] == null){
							var g:CreateUIFileCompAttriGroup = new CreateUIFileCompAttriGroup();
							comp_a[cpd.parent] = g;
							if(cpd.parent == "stage" || cpd.parent == "" || StringTWLUtil.isWhitespace(cpd.parent)){
								g.isStage= true;
							}
							all_comp_ls.push(g);
							g.addItem(attr);
						}else{
							CreateUIFileCompAttriGroup(comp_a[cpd.parent]).addItem(attr);
						} 
					}
				}
			}
			
			for each(p in a){
				if(p!=null){
					if(p.obj is UIShowCompProxy){
						cpd = UIShowCompProxy(p.obj).data;
						if(comp_a[cpd.id] != null){
							attr = new CreateUIFileCompAttri();
							attr.compData = cpd;
							attr.attri_ls = cpd.attriObj;
							CreateUIFileCompAttriGroup(comp_a[cpd.id]).setTarget(attr);
						}
					}
				}
			}
			all_comp_ls = all_comp_ls.sortOn("index",Array.NUMERIC);
			
			var stage_ls:Array = [];
			for each(p in a){
				if(p!=null){
					if(p.obj is UIShowCompProxy){
						cpd = UIShowCompProxy(p.obj).data;
						if(cpd.parent == "stage" || cpd.parent == "" || StringTWLUtil.isWhitespace(cpd.parent)){
							stage_ls.push(cpd);
						}
					}
				}
			}
			
			stage_ls = stage_ls.sortOn("index",Array.NUMERIC);
			
			for(i=0;i<stage_ls.length;i++){
				cpd = stage_ls[i] as ComponentData;
				comp_s += cpd.getAS(cont,true).comp;			
			}
			
			for(i=0;i<all_comp_ls.length;i++){
				g = all_comp_ls[i] as CreateUIFileCompAttriGroup;
				if(!g.isStage){
					comp_s += g.getAS(cont,true);	
				}
			}
			
			for(i=0;i<all_comp_ls.length;i++){
				g = all_comp_ls[i] as CreateUIFileCompAttriGroup;
				comp_s += g.getAS(cont);	
			}
			
			imports = imports.concat(["com.rpg.component.controls.*;"]);
			imports = imports.concat(["com.rpg.component.expands.*;"]);
			imports = imports.concat(["flash.filters.*;"]);
			var import_s:String = "";
			for(i=0;i<imports.length;i++){
				if(!StringTWLUtil.isWhitespace(imports[i])){
					var ind:int = cont.indexOf(imports[i]);
					if(ind == -1){
						var iss:String = imports[i];
						if(StringTWLUtil.beginsWith(iss,"import ")){
							import_s += createSpace()+imports[i]+";"+NEWLINE_SIGN;
						}else{
							import_s += createSpace()+"import"+" "+imports[i]+";"+NEWLINE_SIGN;
						}
					}
				}
			}
			if(!StringTWLUtil.isWhitespace(import_s)){
				ind = cont.indexOf("{");
				var before_s:String = cont.substring(0,ind+1);
				var after_s:String = cont.substring(ind+1,cont.length);
				before_s += NEWLINE_SIGN;
				before_s += import_s;
				cont = before_s + after_s;
			}
									
			if(cont.indexOf(as_1)==-1){
				//找出类里的位置
				//插入as_a
				var a:Array = cont.split("{")
				a.splice(2,0,as_1+NEWLINE_SIGN+as_2);
				var _cont:String = "";
				for(i=0;i<a.length;i++){
					if(i==1){
						_cont += "{"+NEWLINE_SIGN+a[i]+"{"+NEWLINE_SIGN;
					}else if(i == 0 || i == 2 || i ==3){
						_cont += a[i];
					}else{
						_cont += "{"+a[i];
					}
				}
				cont = _cont;
			}
			
			ind = cont.indexOf(as_1);
			before_s = cont.substring(0,ind);
			ind = cont.indexOf(as_2);
			ind += as_2.length;
			after_s = cont.substring(ind,cont.length);
			
			var newCont:String = "";
			newCont += StringTWLUtil.rtrim(before_s)+NEWLINE_SIGN;
			newCont += createSpace(2)+as_1+NEWLINE_SIGN;
			newCont += createSpace(2)+as_3+NEWLINE_SIGN;		
			newCont += vas_s;
			newCont += createSpace(2)+"private"+" "+"function"+" "+"createComp():void"+NEWLINE_SIGN;
			newCont += createSpace(2)+"{"+NEWLINE_SIGN;
			newCont += createSpace(3)+comp_s+NEWLINE_SIGN;
			newCont += createSpace(2)+"}"+NEWLINE_SIGN;
			newCont += createSpace(2)+as_2+NEWLINE_SIGN;
			newCont += createSpace(2)+StringTWLUtil.trim(after_s);
			write.write(fl,newCont);
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
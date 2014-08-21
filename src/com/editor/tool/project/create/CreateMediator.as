package com.editor.tool.project.create
{
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.asparser.ClsUtils;
	import com.editor.manager.StackManager;
	import com.editor.module_ui.ui.CreateUIXML;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.UICreateData;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.vo.OpenFileData;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class CreateMediator
	{
		public function CreateMediator()
		{
		}
		
		private var asFile:File;
		private var mediatorFile:File;
		private var write:WriteFile = new WriteFile();
		private var read:ReadFile = new ReadFile();
		
		
		public function create(fl:File,isMult:Boolean=false):void
		{
			var cont:String = "";
			asFile = fl;
			var n3:String = fl.name.split(".")[0];
			mediatorFile = new File(asFile.parent.parent.nativePath+File.separator+"mediator"+File.separator+n3+"Mediator.as");
			if(!mediatorFile.exists){
				
				if(isMult){
					cont = getTemple(15);
				}else{
					cont = getTemple(7);
				}
				cont = StringTWLUtil.replace(cont,"com.rpg.modules.sh.temp.mediator",ClsUtils.getClassPathString(mediatorFile.parent));
				cont = StringTWLUtil.replace(cont,"com.rpg.modules.sh.temp.view.TempPopupwin",ClsUtils.getClassPathString(fl));
				cont = StringTWLUtil.replace(cont,"TempPopupwinMediator",n3+"Mediator");
				cont = StringTWLUtil.replace(cont,"TempPopupwin",n3);
				
				write.write(mediatorFile,cont);
			}else{
				cont = read.readFromFile(mediatorFile);		
			}
			
			if(cont.indexOf("{")==-1){
				StackManager.getInstance().addCurrLogCont("界面编辑器中,文件格式不对,"+mediatorFile.nativePath);
				return ;
			}
			
			var name:String = asFile.name.split(".")[0];
			var comp_s:String = "";
			var imports:Array = [];
			
			imports.push(ClsUtils.getClassPackage(fl)+"."+name+";");
			
			if(cont.indexOf("win():"+name)==-1){
				comp_s += createSpace()+"public"+" "+"function"+" "+"get"+" "+"win():"+name+NEWLINE_SIGN;
				comp_s += createSpace()+"{"+NEWLINE_SIGN;
				comp_s += createSpace(2)+"return"+" "+"viewComponent as "+name+";"+NEWLINE_SIGN;
				comp_s += createSpace()+"}"+NEWLINE_SIGN;
			}
			
			var xmlFile:File = new File(asFile.parent.nativePath+File.separator+"xml"+File.separator+name+".xml");
			if(!xmlFile.exists){
				StackManager.getInstance().addCurrLogCont("界面编辑器中,xml没有找到,"+xmlFile.nativePath);
				return ;
			}
			var xml:XML = XML(read.readCompressByteArray(xmlFile.nativePath));			
			for each(var p:XML in xml.item){
				var d:UICreateData = new UICreateData();
				d.parserMediator(p); 
				comp_s += d.vars;
				if(d.imports.length>0){
					imports = imports.concat(d.imports);
				}
			}
						
			imports = imports.concat(["com.rpg.component.controls.*;"]);
			imports = imports.concat(["com.rpg.component.expands.*;"]);
			imports = imports.concat(["com.rpg.component.group.*;"]);
			
			for(var i:int=0;i<imports.length;i++){
				if(!StringTWLUtil.isWhitespace(imports[i])){
					var ind:int = cont.indexOf(imports[i]);
					if(ind == -1){
						ind = cont.indexOf("{");
						var before_s:String = cont.substring(0,ind+1);
						var after_s:String = cont.substring(ind+1,cont.length);
						before_s += NEWLINE_SIGN;
						before_s += createSpace()+"import"+" "+imports[i]+";"+NEWLINE_SIGN;
						cont = before_s + after_s;
					}
				}
			}
			
			if(cont.indexOf(CreateUIXML.as_1)==-1){
				//找出类里的位置
				//插入as_a
				var a:Array = cont.split("}")
				a.splice(1,0,CreateUIXML.as_1+NEWLINE_SIGN+CreateUIXML.as_2);
				var _cont:String = "";
				for(i=0;i<a.length;i++){
					if(i == 1 || i == (a.length-2)){
						_cont += a[i]+NEWLINE_SIGN;
					}else{
						_cont += a[i]+"}"+NEWLINE_SIGN;
					}
				}
				cont = _cont;
			}
			
			ind = cont.indexOf(CreateUIXML.as_1);
			before_s = cont.substring(0,ind);
			ind = cont.indexOf(CreateUIXML.as_2);
			ind += CreateUIXML.as_2.length;
			after_s = cont.substring(ind,cont.length);
			
			var newCont:String = "";
			newCont += before_s;
			newCont += createSpace()+CreateUIXML.as_1+NEWLINE_SIGN;
			newCont += createSpace()+CreateUIXML.as_3+NEWLINE_SIGN;
			newCont += createSpace()+comp_s+NEWLINE_SIGN;
			newCont += createSpace()+CreateUIXML.as_2+NEWLINE_SIGN;
			newCont += StringTWLUtil.trim(after_s);
			write.write(mediatorFile,newCont);
			
			var dd:OpenFileData = new OpenFileData();
			dd.file = mediatorFile;
			iManager.sendAppNotification(AppModulesEvent.openEditFile_event,dd);
		}
		
		private function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
		private function createEmptyMediator(fl:File):String
		{
			var url:String = StringTWLUtil.replace(fl.parent.nativePath,File.separator,".")
			var url_a:Array = url.split(".");
			var url_n:int = url_a.indexOf("src");
			var s:String = "package"+" "+url_a.slice(url_n+1,url_a.length).join(".")+NEWLINE_SIGN;
			s += "{"+NEWLINE_SIGN;
			s += createSpace(2)+"public"+" "+"class"+" "+fl.name.split(".")[0]+NEWLINE_SIGN;
			s += createSpace(2)+"{"+NEWLINE_SIGN;
			s += createSpace(4)+"public static const NAME:String = "+" "+'"'+fl.name.split(".")[0]+'";'+NEWLINE_SIGN;
			s += createSpace(4)+"public"+" "+"function"+" "+fl.name.split(".")[0]+"(viewComponent:Object=null):void"+NEWLINE_SIGN;
			s += createSpace(4)+"{"+NEWLINE_SIGN;
			s += createSpace(8)+"super(NAME,viewComponent);"+NEWLINE_SIGN;
			s += createSpace(4)+"}"+NEWLINE_SIGN;
			s += createSpace(4)+"override public function onRegister():void"+NEWLINE_SIGN;
			s += createSpace(4)+"{"+NEWLINE_SIGN;
			s += createSpace(8)+"super.onRegister();"+NEWLINE_SIGN;
			s += createSpace(4)+"}"+NEWLINE_SIGN;
			s += createSpace(2)+"}"+NEWLINE_SIGN;
			s += "}"+StringTWLUtil.NEWLINE_SIGN;
			return s;
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n)
		}
		
		private function getTemple(id:int):String
		{
			return AppGlobalConfig.instance.temple_vo.getTemple(id).data;
		} 
		
	}
}
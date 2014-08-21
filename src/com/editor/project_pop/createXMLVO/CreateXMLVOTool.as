package com.editor.project_pop.createXMLVO
{
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.model.AppMainModel;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class CreateXMLVOTool
	{
		public function CreateXMLVOTool()
		{
		}
		
		private var xml:XML;
		private var fold_sign:String;
		private var fold_sign2:String;
		private var read:ReadFile = new ReadFile();
		private var write:WriteFile = new WriteFile();
		
		public function create(xmlURL:String,sign:String):void
		{
			if(StringTWLUtil.isWhitespace(sign)) return ;
			var fl:File = new File(xmlURL);
			if(!fl.exists) return ;
			var read:ReadFile = new ReadFile();
			xml = XML(read.readFromFile(fl));
			fold_sign = sign;
			fold_sign2 = StringTWLUtil.setFristUpperChar(sign);
			
			createList();
			if(ParserXMLVOTool.instance.g_obj!=null){
				createGroup();
			}
			createItem();
		}
		
		private function getTemple(id:int):String
		{
			return AppGlobalConfig.instance.temple_vo.getTemple(id).data;
		}
		
		private function createList():void
		{
			var cont:String = getTemple(1);
			if(ParserXMLVOTool.instance.g_obj==null){
				cont = getTemple(4);
			}
			var name:String = AppMainModel.getInstance().user.shortName;
			cont = StringTWLUtil.replace(cont,"package com.rpg.vo.temp","package com.rpg.vo."+name+"."+fold_sign.toLocaleLowerCase());
			cont = StringTWLUtil.replace(cont,"temp",fold_sign.toLocaleLowerCase());
			cont = StringTWLUtil.replace(cont,"Temp",fold_sign2);
			var file:File = new File(getFoldURL()+fold_sign2+"ListVO.as");
			write.write(file,cont);
		}
		
		private function getFoldURL():String
		{
			var name:String = AppMainModel.getInstance().user.shortName;
			return ProjectCache.getInstance().getVOPath()+File.separator+name+File.separator+fold_sign.toLocaleLowerCase()+File.separator
		}
		
		private function getGroup():Array
		{
			return ParserXMLVOTool.instance.getGroup()
		}
		
		private function getItem():Array
		{
			return ParserXMLVOTool.instance.getItem();
		}
		
		private static const group_s1:String = "x.@i;"
		private static const group_s2:String = "id:*;"
		
		private function createGroup():void
		{
			var name:String = AppMainModel.getInstance().user.shortName;
			var cont:String = getTemple(2);
			cont = StringTWLUtil.replace(cont,"package com.rpg.vo.temp","package com.rpg.vo."+name+"."+fold_sign.toLocaleLowerCase());
			cont = StringTWLUtil.replace(cont,"temp",fold_sign.toLocaleLowerCase());
			cont = StringTWLUtil.replace(cont,"Temp",fold_sign2);
						
			var vars:String = "";
			var _cont:String = "";
			
			var a:Array = getGroup();
			for(var i:int=0;i<a.length;i++){
				var item:PaserXMLVO = a[i] as PaserXMLVO;
				var obj:Object = item.create();
				vars += obj.vars;
				_cont += obj.txt;
			}
			
			var ind:int = cont.indexOf(group_s2);
			var before_s:String = cont.substring(0,ind+group_s2.length);
			var after_s:String = cont.substring(ind+group_s2.length,cont.length);
			
			var cont2:String = "";
			cont2 += before_s+NEWLINE_SIGN;
			cont2 += vars;
			cont2 += after_s;
			
			ind = cont2.indexOf(group_s1);
			before_s = cont2.substring(0,ind+group_s1.length);
			after_s = cont2.substring(ind+group_s1.length,cont2.length);
			
			cont2 = "";
			cont2 += before_s+NEWLINE_SIGN;
			cont2 += _cont;
			cont2 += after_s;
			
			var file:File = new File(getFoldURL()+fold_sign2+"GroupVO.as");
			write.write(file,cont2);
		}
		
		private function createItem():void
		{
			var name:String = AppMainModel.getInstance().user.shortName;
			var cont:String = getTemple(3);
			cont = StringTWLUtil.replace(cont,"package com.rpg.vo.temp","package com.rpg.vo."+name+"."+fold_sign.toLocaleLowerCase());
			cont = StringTWLUtil.replace(cont,"temp",fold_sign.toLocaleLowerCase());
			cont = StringTWLUtil.replace(cont,"Temp",fold_sign2);
			
			var vars:String = "";
			var _cont:String = "";
			
			var a:Array = getItem();
			for(var i:int=0;i<a.length;i++){
				var item:PaserXMLVO = a[i] as PaserXMLVO;
				var obj:Object = item.create();
				vars += obj.vars;
				_cont += obj.txt;
			}
			
			var ind:int = cont.indexOf(group_s2);
			var before_s:String = cont.substring(0,ind+group_s2.length);
			var after_s:String = cont.substring(ind+group_s2.length,cont.length);
			
			var cont2:String = "";
			cont2 += before_s+NEWLINE_SIGN;
			cont2 += vars;
			cont2 += after_s;
			
			ind = cont2.indexOf(group_s1);
			before_s = cont2.substring(0,ind+group_s1.length);
			after_s = cont2.substring(ind+group_s1.length,cont2.length);
			
			cont2 = "";
			cont2 += before_s+NEWLINE_SIGN;
			cont2 += _cont;
			cont2 += after_s;
			
			var file:File = new File(getFoldURL()+fold_sign2+"ItemVO.as");
			write.write(file,cont2);
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
	}
}
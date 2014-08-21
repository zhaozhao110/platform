package com.editor.tool.project.create
{
	import com.asparser.ClsUtils;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	
	//serverCode
	public class CreateServerCodeTool
	{
		public function CreateServerCodeTool()
		{
		}
		
		private var write:WriteFile = new WriteFile();
		private var read:ReadFile = new ReadFile();
		
		private function getTemple(id:int):String
		{
			return AppGlobalConfig.instance.temple_vo.getTemple(id).data;
		}
		
		public function create(fold_sign:String):void
		{
			var url:String = ProjectCache.getInstance().getUserSocketCodePath()
			var clsName:String = StringTWLUtil.setFristUpperChar(fold_sign)
			var path:String = url + File.separator + clsName+".as";
			var file:File = new File(path);
			if(file.exists){
				SandyManagerBase.getInstance().showError("已经有该文件了");
				return ;
			}
			var cont:String = getTemple(11);
			cont = StringTWLUtil.replace(cont,"com.rpg.serverCode.sh",ClsUtils.getClassPackage(file));
			cont = StringTWLUtil.replace(cont,"LoginServerCode",clsName);
			
			write.write(file,cont);
			
			var new_fl:File = new File(url);
			SandyEngineGlobal.iManager.sendAppNotification(AppEvent.openFold_event,new_fl);
			
			url = ProjectCache.getInstance().getUserSocketCodeEnumPath();
			file = new File(url);
			cont = read.readFromFile(file);
			var n1:int = cont.indexOf("{");
			var before_s:String = cont.substring(0,n1+1);
			var after_s:String = cont.substring(n1+1,cont.length);
			cont = before_s + NEWLINE_SIGN;
			cont += createSpace(2)+"import " + ClsUtils.getClassPackage(file)+"."+AppMainModel.getInstance().user.shortName.toLocaleLowerCase()+"."+clsName+";"+NEWLINE_SIGN;
			cont += after_s;
			
			n1 = cont.indexOf(sign1);
			before_s = cont.substring(0,n1+sign1.length);
			after_s = cont.substring(n1+sign1.length,cont.length);
			cont = before_s + NEWLINE_SIGN;
			cont += createSpace(4) + "a.push("+clsName+");"+NEWLINE_SIGN;
			cont += after_s;
			
			write.write(file,cont);
		}
		
		private var sign1:String = "var a:Array = [];";
		
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
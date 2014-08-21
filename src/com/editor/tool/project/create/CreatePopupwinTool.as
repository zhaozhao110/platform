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

	public class CreatePopupwinTool
	{
		public function CreatePopupwinTool()
		{
		}
		
		private var win_sign:String;
		private var popwin:String;
		private var popwin_path:String;
		private var mediatorName:String;
		private var mediator_path:String;
		private var dir_path:String;
		private var dir_path2:String;
		private var info:String;
		
		//E:\hg_res\sandy_engine\test\uiTest\src\com\rpg\modules\sh\
		public static function createUserPopupwinFold():void
		{
			WriteFile.createDirectory(AppMainModel.getInstance().user.getPopupwinFold().nativePath);
		}
		
		public function create(sign:String,_info:String=""):void
		{
			win_sign = sign;
			info = _info
			
			var fl:File = new File(getUserPopwinFile().nativePath+File.separator+sign);
			if(fl.exists) return ;

			fl.createDirectory();
			
			dir_path = getUserPopwinFile().nativePath+File.separator+sign;
			popwin = StringTWLUtil.setFristUpperChar(sign)+"popWin";
			mediatorName = popwin+"Mediator";
			popwin_path = dir_path+File.separator+"view"+File.separator+popwin+".as";
			mediator_path = dir_path+File.separator+"mediator"+File.separator+mediatorName+".as"
			dir_path2 = ClsUtils.getClassPackage(new File(dir_path));
			
			//view
			fl = new File(dir_path+File.separator+"view");
			fl.createDirectory();
			//mediator
			fl = new File(dir_path+File.separator+"mediator");
			fl.createDirectory();
			//vo
			fl = new File(dir_path+File.separator+"vo");
			fl.createDirectory();
			//component
			fl = new File(dir_path+File.separator+"component");
			fl.createDirectory();
			//pop
			/*fl = new File(dir_path+File.separator+"pop");
			fl.createDirectory();*/
			//win.as
			var win_cont:String = getTemple(6);
			win_cont = StringTWLUtil.replace(win_cont,"com.rpg.modules.sh.temp.mediator.TempPopupwinMediator",getPopwinMediatorPath())
			win_cont = StringTWLUtil.replace(win_cont,"com.rpg.modules.sh.temp.view",dir_path2+"."+sign+".view");
			win_cont = StringTWLUtil.replace(win_cont,"com.rpg.model.sh.PopupwinSign",getUserPopSign());
			win_cont = StringTWLUtil.replace(win_cont,"TempPopupwin",popwin);
			win_cont = StringTWLUtil.replace(win_cont,"PopupwinSign",getUserName()+"_popwinSign");
			win_cont = StringTWLUtil.replace(win_cont,"TempPopupwin_sign",popwin+"_sign");
			win_cont = StringTWLUtil.replace(win_cont,"TempPopupwinMediator",popwin+"Mediator");
			var write:WriteFile = new WriteFile();
			write.write(new File(popwin_path),win_cont);
			//mediator
			win_cont = getTemple(7);
			win_cont = StringTWLUtil.replace(win_cont,"com.rpg.modules.sh.temp.mediator",dir_path2+"."+sign+".mediator");
			win_cont = StringTWLUtil.replace(win_cont,"com.rpg.modules.sh.temp.view.TempPopupwin",getPopWinPath());
			win_cont = StringTWLUtil.replace(win_cont,"TempPopupwinMediator",popwin+"Mediator");
			win_cont = StringTWLUtil.replace(win_cont,"TempPopupwin",popwin);
			write = new WriteFile();
			write.write(new File(mediator_path),win_cont);
			//
			changePopupSign();
			//
			changePopwinClass();
			
			var new_fl:File = new File(dir_path);
			SandyEngineGlobal.iManager.sendAppNotification(AppEvent.openFold_event,new_fl);
		}
		
		private function getPopWinPath():String
		{
			return dir_path2+"."+win_sign+".view."+popwin;
		}
		
		private function getPopwinMediatorPath():String
		{
			return dir_path2+"."+win_sign+".mediator."+mediatorName;
		}
		
		private function getUserPopSign():String
		{
			var fl:File = new File(ProjectCache.getInstance().getModelPath()+File.separator+getUserName2()+File.separator+getUserName()+"_popwinSign.as");
			var path:String = ClsUtils.getClassPackage(fl);
			return path+"."+getUserName()+"_popwinSign";
		}
		
		private function getUserPopSign2():File
		{
			var fl:File = new File(ProjectCache.getInstance().getModelPath()+File.separator+getUserName2()+File.separator+getUserName()+"_popwinSign.as");
			return fl;
		}
		
		private function getUserPopClass():File
		{
			var fl:File = new File(ProjectCache.getInstance().getModelPath()+File.separator+getUserName2()+File.separator+getUserName()+"_popwinClass.as");
			return fl;
		}
		
		private function getUserName():String
		{
			return StringTWLUtil.setFristUpperChar(getUserName2());
		}
		
		private function getUserName2():String
		{
			return AppMainModel.getInstance().user.shortName;
		}
		
		private function getTemple(id:int):String
		{
			return AppGlobalConfig.instance.temple_vo.getTemple(id).data;
		} 
		 
		private function changePopwinClass():void
		{
			var win:String = popwin;
			var path:String = getPopWinPath()
			var read:ReadFile = new ReadFile();
			var cont:String = read.readFromFile(getUserPopClass());
			if(cont.indexOf(win)!=-1) return ;
			var a:Array = cont.split("{");
			a[1] = NEWLINE_SIGN+ createSpace(2)+"import "+path+";"+NEWLINE_SIGN+a[1];
			cont = a.join("{");
			a = cont.split("}")
			var ind:int = a.length-3;
			a[ind] = a[ind]+NEWLINE_SIGN+createSpace(2)+"public var "+win.toLocaleLowerCase()+":"+popwin+";"+NEWLINE_SIGN
			cont = a.join("}");
			var write:WriteFile = new WriteFile();
			write.write(getUserPopClass(),cont);
		}
		
		private function changePopupSign():void
		{
			var fl:File = getUserPopSign2()
			if(!fl.exists){
				SandyManagerBase.getInstance().showError("你在model下的文件没有创建");
				return ;
			}
			var win:String = popwin + "_sign";
			var path:String = getPopWinPath()
			var read:ReadFile = new ReadFile();
			var cont:String = read.readFromFile(fl);
			if(cont.indexOf(win)!=-1) return ;
			var a:Array = cont.split("}");
			var ind:int = a.length-3;
			var ns:String = "";
			if(!StringTWLUtil.isWhitespace(info)){
				if(info.indexOf("/**")==-1){
					ns += createSpace(2)+"/**"+info+"*/"+NEWLINE_SIGN;
				}else{
					ns += createSpace(2)+info+NEWLINE_SIGN;
				}
			}
			ns += createSpace(2)+"public static const "+win+':String = "'+path+'";'+NEWLINE_SIGN;
			a[ind] = a[ind]+NEWLINE_SIGN+ns;
			cont = a.join("}");
			var write:WriteFile = new WriteFile();
			write.write(getUserPopSign2(),cont);
		}
		
		private function getUserPopwinFile():File
		{
			return new File(ProjectCache.getInstance().getPopupwinPath()+File.separator+AppMainModel.getInstance().user.shortName);
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n)
		}
		
		/** 找出窗口的主类,skillPopwin.as */
		public static function getPopMainWinAS(fl:File):File
		{
			var view:File = new File(fl.nativePath+File.separator+"view");
			if(!view.exists) return null;
			var a:Array = view.getDirectoryListing();
			for(var i:int=0;i<a.length;i++){
				var read:ReadFile = new ReadFile();
				var cont:String = read.readFromFile(a[i]);
				if(!StringTWLUtil.isWhitespace(cont)){
					if(cont.indexOf("function delPopwin():void")!=-1){
						return a[i] as File;
					}
				}
			}
			return null;
		}
		
	}
}
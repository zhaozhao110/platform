package com.editor.vo.user
{
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class UserInfoVO
	{
		public function UserInfoVO(obj:Object=null)
		{
			if(obj == null) return ;
			id = int(obj.id);
			name = obj.name;
			project_ls = String(obj.project).split(",");
			power = String(obj.power).split(",");
			shortName = obj.short;
		}
		
		
		
		
		
		public var shortName:String;
		public var project_ls:Array = [];
		public var id:int;		
		public var name:String;
		public var power:Array;
		//ip
		public var user_addres:String;
		//os
		public var os:String;
		//version
		public var air_version:String;
		//app 
		public var app_version:String;
		
		public function getInfo():String
		{
			return "帐号:"+name+",缩写:"+shortName+",项目:"+project_ls.join(",")+",权限:"+power.join(",")+
				",os:"+os+",air版本:"+air_version+",平台版本:"+app_version;
		}
		
		
		public function checkIsSystem():Boolean
		{
			if(power.indexOf("1")!=-1){
				return true
			}
			return false;
		}
		
		public function checkInGroup(g:int):Boolean
		{
			if(power.indexOf(g.toString())!=-1){
				return true
			}
			return false;
		}
		
		public function checkInPower(s:*):Boolean
		{
			if(checkIsSystem()) return true;
			var a:Array;
			if(s is Array){
				a = s;
			}else{
				a = String(s).split(",");
			}
			for(var i:int=0;i<a.length;i++){
				if(power.indexOf(String(a[i]))!=-1){
					return true
				}
			}
			return false;
		}
		
		
		
		public function getCSSFold():File
		{
			var url:String = ProjectCache.getInstance().getThemePath()+File.separator+"css"+File.separator+shortName;
			return new File(url);
		}
		
		public function getCSSAssetsFold(nm:String=""):File
		{
			var url:String;
			if(nm == ""){
				url = ProjectCache.getInstance().getThemePath()+File.separator+"assets"+File.separator+shortName;
			}else{
				url = ProjectCache.getInstance().getThemePath()+File.separator+"assets"+File.separator+nm;
			}
			return new File(url);
		}
		
		public function getAssetsImgFold(nm:String =""):File
		{
			var url:String;
			if(nm == ""){
				url = ProjectCache.getInstance().getProjectSrcURL()+File.separator+"assets"+File.separator+"img"+File.separator+shortName;
			}else{
				url = ProjectCache.getInstance().getProjectSrcURL()+File.separator+"assets"+File.separator+"img"+File.separator+nm;
			}
			return new File(url);
		}
		
		//E:\project\god_pub\god_pub\src\com\rpg\modules\sh
		public function getPopupwinFold():File
		{
			var url:String = ProjectCache.getInstance().getPopupwinPath()+File.separator+shortName;
			return new File(url);
		}
		
		//E:\hg_res\sandy_engine\test\uiTest\src\com\rpg\model\sh\ShPopuwinClass
		public function getPopupwinClassPath():File
		{
			var url:String = ProjectCache.getInstance().getModelPath()+File.separator+shortName+File.separator+StringTWLUtil.setFristUpperChar(shortName)+"PopupwinClass.as";
			return new File(url);
		}
		
		//E:\hg_res\sandy_engine\test\uiTest\src\com\rpg\model\sh\ShPopuwinSign
		public function getPopupwinSignPath():File
		{
			var url:String = ProjectCache.getInstance().getModelPath()+File.separator+shortName+File.separator+StringTWLUtil.setFristUpperChar(shortName)+"PopupwinSign.as";
			return new File(url);
		}
		
	}
}
package com.editor.model
{
	import com.air.io.HashMapFile;
	import com.editor.module_roleEdit.vo.project.RoleEditProjectItemVO;
	import com.editor.module_ui.css.CreateCSSMainFile;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.global.AppStorageConfFile;
	import com.editor.vo.project.AppProjectItemVO;
	import com.editor.vo.user.UserInfoVO;

	public class AppMainModel
	{
		private static var instance:AppMainModel;
		public static function getInstance():AppMainModel{
			if(instance == null){
				instance =  new AppMainModel();
			}
			return instance;
		}
		
		
		
		//程序本地缓存
		public var applicationStorageFile:AppStorageConfFile;
		
		public var selectProject:AppProjectItemVO;
		
		private var _user:UserInfoVO;
		public function get user():UserInfoVO
		{
			return _user;
		}
		public function set user(value:UserInfoVO):void
		{
			_user = value;
			if(value!=null){
				CreateCSSMainFile.getInstance().parser();
				ProjectCache.getInstance().getJumpList();
			}
		}
		
		public var minAfterLogin:Boolean;
		
		public var projectSet_parseing:Boolean;
		
		public var isIn3DScene:Boolean;
		public var d3SceneInited:Boolean;
		public var d3SceneCreated:Boolean;
		
		public var enter3DScene:Boolean;
		public var enterGDPS:Boolean;
	}
}
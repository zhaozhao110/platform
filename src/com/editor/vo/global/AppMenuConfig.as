package com.editor.vo.global
{
	import com.air.sql.ConnLocalSqlManager;
	import com.editor.model.AppMainModel;
	import com.sandy.asComponent.controls.ASMenu;
	import com.sandy.error.SandyError;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.data.SQLResult;

	public class AppMenuConfig
	{
		public function AppMenuConfig()
		{
			if(_instance!=null){
				SandyError.error("AppMenuConfig is only");
			}
			_instance = this;
		}
		
		private static var _instance:AppMenuConfig
		public static function get instance():AppMenuConfig{
			if(_instance == null){
				new AppMenuConfig();
			}
			return _instance;
		}
		
		//客户端顶部的菜单栏 1-100
		public var topMenu_xml:XML;
		//控制台 100
		public var consol_xml:XML;
		//项目目录菜单 200
		public var projectMenu_xml:XML;
		//右边文件的编辑的tab菜单300
		public var fileTabMenu_xml:XML;
		//projectHelp
		public var projectHelp_xml:XML;
		//3d menu
		public var top3DMenu_xml:XML;
		//outlineMenu
		public var outlineMenu_xml:XML;
		//3d proejct
		public var d3ProjectMenu_xml:XML;
		
		public function querySql():void
		{
			var statement:String = "select * from menu";
			var res:SQLResult = ConnLocalSqlManager.getInstance().executeStatement(statement);
			var a:Array = res.data;
			var len:int = a.length;
			for(var i:int=0;i<len;i++){
				var obj:Object = a[i];
				var xml:XML = XML(obj.value);
				if(obj.key == "topMenu"){
					topMenu_xml = xml;
				}else if(obj.key == "console"){
					consol_xml = xml;
				}else if(obj.key == "projectMenu"){
					projectMenu_xml = xml;
				}else if(obj.key == "fileTabMenu"){
					fileTabMenu_xml = xml;
				}else if(obj.key == "projectHelp"){
					projectHelp_xml = xml;
				}else if(obj.key == "topMenu3d"){
					top3DMenu_xml = xml;
				}else if(obj.key == "outlineMenu"){
					outlineMenu_xml = xml;
				}else if(obj.key == "3dProjectMenu"){
					d3ProjectMenu_xml = xml;
				}
			}
		}
		
		public function filterPower():void
		{
			if(AppMainModel.getInstance().user.checkIsSystem()) return ;
			ASMenu.openMenuFilter_proxy = openMenuFilter_proxy
		}
		
		private function openMenuFilter_proxy(menuXml:XML):XML
		{
			var xml:XML = menuXml.copy();
			var a:XMLList = xml.children();
			var b:Array = [];
			var n:int = a.length();
			for(var i:int=(n-1);i>=0;i--){
				var p:XML = XML(a[i]);
				if(!StringTWLUtil.isWhitespace(p.@pow)){
					var s:String = p.@pow;
					if(!AppMainModel.getInstance().user.checkInPower(s)){
						delete xml.*[i];
					}
				}
			}
			return xml;
		}
		
	}
}
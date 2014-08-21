package com.editor.module_gdps.vo.module
{
	import com.editor.module_gdps.services.GDPSServices;

	public class AppMapModuleConfItem extends AppModuleConfBase
	{
		private var _view:String;//存放请求controller
		
		private var _extend:Object;//存放菜单的拓展信息
		
		public function get view():String
		{
			return _view;
		}
		
		public function get extend():Object
		{
			return _extend;
		}
		
		public function AppMapModuleConfItem(obj:Object)
		{
			parser(obj)
		}
		
		public var dictId:int;
		public var dict_xml_url:String;
		public var map_xml_url:String;
		public var map_fold:String;
		public var domain:String;
		public var role_fold:String;
		public var background_fold:String;
		
		public var motion_fold:String;
		
		
		public function parser(obj:Object):void
		{
			domain 			= GDPSServices.cilentDomain();
			dictId 			= int(obj.extend.dictId);
			dict_xml_url 	= domain + obj.extend.dict;
			map_xml_url 	= domain + obj.extend.mapConf;
			map_fold 		= domain + obj.extend.map;
			background_fold = domain + "/edit_src/map/"
			
			role_fold 		= domain + obj.extend.role;
			motion_fold 	= domain + obj.extend.motion;
			menuId			= obj.menuid;
			flashId 		= int(obj.flashId);
			swfPath			= obj.swfPath;
			
			_extend = obj.extend;
				
			if (obj.view != null)
			{
				_view = obj.view;
			}
		}
		
		
	}
}
package com.editor.module_gdps.vo.module
{
	public class AppModuleConfBase implements IAppModuleConfBase
	{
		
		
		public function AppModuleConfBase()
		{
		}
		
		private var _menuId:int;

		/**
		 * 选中的菜单id
		 */
		public function get menuId():int
		{
			return _menuId;
		}
		public function set menuId(value:int):void
		{
			_menuId = value;
		}

		private var _flashId:int;

		/**
		 * 模块的swf
		 */
		public function get flashId():int
		{
			return _flashId;
		}
		public function set flashId(value:int):void
		{
			_flashId = value;
		}
		
		
		private var _swfPath:String;
		
		/**
		 * 模块的swf路径-后台菜单中定义传递
		 */
		public function get swfPath():String
		{
			return _swfPath;
		}
		public function set swfPath(value:String):void
		{
			_swfPath = value;
		}
		
	}
}
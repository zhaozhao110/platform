package com.editor.module_map2.proxy
{
	import com.editor.module_map.vo.map.AppMapDefineListVO;
	import com.editor.module_map.vo.map.MapResConfigListVO;
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.proxy.AppProxy;

	public class MapEditorProxy2 extends AppProxy
	{
		public static const NAME:String = "MapEditorProxy2"
		public function MapEditorProxy2()
		{
			super(NAME);
		}
		
		private var _resInfo_ls:AppResInfoListVO;
		public var dictList:RoleEditDictListVO;
		public var mapDefine:AppMapDefineListVO;
		public var mapRes:MapResConfigListVO;
		
		public function get resInfo_ls():AppResInfoListVO
		{
			return _resInfo_ls;
		}
		
		public function set resInfo_ls(value:AppResInfoListVO):void
		{
			_resInfo_ls = value;
		}
	}
}
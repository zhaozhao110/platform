package com.editor.module_sea.proxy
{
	import com.editor.module_sea.vo.dict.SeaMapDictListVO;
	import com.editor.module_sea.vo.res.SeaMapResInfoListVO;
	import com.editor.proxy.AppProxy;

	public class SeaMapModuleProxy extends AppProxy
	{
		public static const NAME:String = "SeaMapModuleProxy"
		public function SeaMapModuleProxy()
		{
			super(NAME);
			instance = this;
		}
		
		public static var instance:SeaMapModuleProxy;
		public var resInfo_ls:SeaMapResInfoListVO;
		public var dict_ls:SeaMapDictListVO;
		
	}
}
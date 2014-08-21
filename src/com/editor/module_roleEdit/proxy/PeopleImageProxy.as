package com.editor.module_roleEdit.proxy
{
	
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionListVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.proxy.AppProxy;

	public class PeopleImageProxy extends AppProxy
	{
		public static const NAME:String = "PeopleImageProxy"
		public function PeopleImageProxy()
		{
			super(NAME);
		}
		
		public var dictList:RoleEditDictListVO;
		public var resInfo_ls:AppResInfoListVO;
		public var motion_ls:AppMotionListVO;
		
	}
}
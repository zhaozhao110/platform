package com.editor.module_actionMix.proxy
{
	import com.editor.module_actionMix.vo.ActionMixActionXMLListVO;
	import com.editor.module_actionMix.vo.mix.ActionMixListVO;
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionListVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.module_skill.vo.motion.MotionLvlListVO;
	import com.editor.proxy.AppProxy;

	public class ActionMixProxy extends AppProxy
	{
		public static const NAME:String = "ActionMixProxy"
		public function ActionMixProxy()
		{
			super(NAME);
		}
		
		public var dictList:RoleEditDictListVO;
		public var resInfo_ls:AppResInfoListVO;
		public var motion_ls:AppMotionListVO;
		public var action_ls:ActionMixActionXMLListVO;
		public var mix_ls:ActionMixListVO;
		public var motionLvl_ls:MotionLvlListVO
	}
}
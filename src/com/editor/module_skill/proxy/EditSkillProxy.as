package com.editor.module_skill.proxy
{
	import com.editor.module_actionMix.vo.ActionMixActionXMLListVO;
	import com.editor.module_actionMix.vo.mix.ActionMixListVO;
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionListVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.module_skill.vo.motion.MotionLvlListVO;
	import com.editor.module_skill.vo.skill.EditSkillListVO;
	import com.editor.module_skill.vo.skillSeq.SkillSeqListVO;
	import com.editor.proxy.AppProxy;

	public class EditSkillProxy extends AppProxy
	{
		public static const NAME:String = "EditSkillProxy"
		public function EditSkillProxy()
		{
			super(NAME);
		}
		
		public var skill_ls:EditSkillListVO ;
		public var dictList:RoleEditDictListVO;
		public var resInfo_ls:AppResInfoListVO;
		public var motion_ls:AppMotionListVO;
		public var action_ls:ActionMixActionXMLListVO;
		public var motionLvl_ls:MotionLvlListVO;
		public var skillSeq_ls:SkillSeqListVO;
		public var mix_ls:ActionMixListVO;
		
	}
}
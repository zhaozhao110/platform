package com.editor.moudule_drama.proxy
{
	import com.editor.module_actionMix.vo.ActionMixActionXMLListVO;
	import com.editor.module_actionMix.vo.mix.ActionMixListVO;
	import com.editor.module_map.vo.map.AppMapDefineListVO;
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionListVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.module_skill.vo.skill.EditSkillListVO;
	import com.editor.module_skill.vo.skillSeq.SkillSeqListVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotListVO;
	import com.editor.proxy.AppProxy;

	public class DramaProxy extends AppProxy
	{
		public static const NAME:String = "DramaProxy"
		public function DramaProxy()
		{
			super(NAME);
		}
		
		public var resInfo_ls:AppResInfoListVO;
		public var dictList:RoleEditDictListVO;
		public var mapDefine:AppMapDefineListVO;
		public var skill_ls:EditSkillListVO;
		public var skillSeq_ls:SkillSeqListVO;
		public var motion_ls:AppMotionListVO;
		public var action_ls:ActionMixActionXMLListVO;
		public var mix_ls:ActionMixListVO;
		public var plot_ls:DramaPlotListVO;
	}
}
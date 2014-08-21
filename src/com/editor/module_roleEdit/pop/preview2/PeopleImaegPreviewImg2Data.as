package com.editor.module_roleEdit.pop.preview2
{
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.sandy.render2D.mapBase.SandyMapItemBaseData;
	import com.sandy.render2D.mapBase.interfac.ISandyMapBase;

	public class PeopleImaegPreviewImg2Data extends SandyMapItemBaseData
	{
		public function PeopleImaegPreviewImg2Data()
		{
			super();
		}
		
		public var motionData:AppMotionItemVO;
		
		override public function getActionSign(tp:String,imap:ISandyMapBase):String
		{
			return RoleEditManager.currProject.resFold + "monster/"+id+".swf";
		}
		
		
	}
}
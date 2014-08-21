package com.editor.module_skill.vo.skillSeq
{
	public class SkillSeqGroupVO
	{
		public function SkillSeqGroupVO(x:XML)
		{
			parser(x)
		}
		
		public var list:Array = [];
		public var skillId:String;
		//资源ID
		public var attackId:int;
		//资源ID
		public var attackArmId:int;
		//资源ID
		public var defendId:int;
		//资源ID
		public var defendArmId:int;
		//怪物技能
		public var isMonsterBattle:Boolean;
		public var endFrame:int;
		
		private function parser(x:XML):void
		{
			skillId = x.@sid;
			if(skillId.indexOf(",")!=-1){
				skillId = skillId.split(",")[0];
				isMonsterBattle = true;
			}
			attackId = int(x.@aid);
			attackArmId = int(x.@amid);
			defendId = int(x.@did);
			defendArmId = int(x.@dmid);
			endFrame = int(x.@end);
			
			for each(var p:XML in x.r){
				var item:SkillSeqItemVO = new SkillSeqItemVO(p);
				list[item.row.toString()] = item;
			}
		}
		
		public function getItemByRow(row:int):SkillSeqItemVO
		{
			return list[row.toString()] as SkillSeqItemVO;
		}
	}
}
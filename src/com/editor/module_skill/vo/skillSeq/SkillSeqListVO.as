package com.editor.module_skill.vo.skillSeq
{
	public class SkillSeqListVO
	{
		public function SkillSeqListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.i){
				var item:SkillSeqGroupVO = new SkillSeqGroupVO(p);
				list.push(item);
			}
		}
		
		public function getGroupBySkillId(id:int):SkillSeqGroupVO
		{
			for(var i:int=0;i<list.length;i++){
				var g:SkillSeqGroupVO = list[i] as SkillSeqGroupVO;
				if(g.skillId == id.toString() && !g.isMonsterBattle){
					return g;
				}
			}
			return null
		}
		
		public function getGroupBySkillIdAndAttackId(id:int,attackId:int):SkillSeqGroupVO
		{
			for(var i:int=0;i<list.length;i++){
				var g:SkillSeqGroupVO = list[i] as SkillSeqGroupVO;
				if(g.skillId == id.toString() && g.attackId == attackId && g.isMonsterBattle){
					return g;
				}
			}
			return null
		}
		
		public function getMonsterSkill(id:int):Array
		{
			var out:Array = [];
			for(var i:int=0;i<list.length;i++){
				var g:SkillSeqGroupVO = list[i] as SkillSeqGroupVO;
				if(g.skillId == id.toString() && g.isMonsterBattle){
					out.push(g);
				}
			}
			return out;
		}
		
	}
}
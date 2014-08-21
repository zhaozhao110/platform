package com.editor.module_actionMix.vo.mix
{
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.render2D.mapBase.interfac.IAnimationLevelData;
	import com.sandy.utils.StringTWLUtil;

	/**
	 * editor生成的
	 */ 
	public class ActionMixItemVO implements IAnimationLevelData
	{
		public function ActionMixItemVO(x:XML,_actionGroupId:int,getName_f:Function)
		{
			actionGroupId = _actionGroupId
			parser(x,getName_f);
		}
		
		public var actionGroupId:int;
		public var list:Array = [];
		//技能ID
		public var id:int;
		public var name:String;
		public var level:String;
		public var lvl_a:Array=[]
		
		private function parser(x:XML,getName_f:Function):void
		{
			id = int(x.@i);
			name = getName_f(id);
			level = x.@lvl;
			if(!StringTWLUtil.isWhitespace(level)){
				lvl_a = level.split("");
			}
			
			for each(var p:XML in x.a){
				var item:ActionMixTypeVO = new ActionMixTypeVO(p);
				item.actionGroupId = actionGroupId;
				item.id = id;
				list.push(item);
			}
		}
		
		public function getValue(index:int):*
		{
			return lvl_a[index]
		}
		public function get size():int
		{
			return lvl_a.length;
		}
		
		private function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
	}
}
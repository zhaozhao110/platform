package com.editor.module_skill.vo.motion
{
	import com.sandy.render2D.mapBase.interfac.IAnimationLevelData;
	import com.sandy.utils.StringTWLUtil;

	public class MotionLvlItemVO implements IAnimationLevelData
	{
		public function MotionLvlItemVO(x:XML)
		{
			parser(x);
		}
		
		public var action:String;
		private var value:String;
		public var lvl_a:Array=[]
		
		private function parser(x:XML):void
		{
			action = x.@t;
			value = x.@v;
			if(!StringTWLUtil.isWhitespace(value)){
				lvl_a = value.split("");
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
	}
}
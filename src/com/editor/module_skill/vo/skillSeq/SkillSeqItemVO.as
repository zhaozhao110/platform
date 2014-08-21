package com.editor.module_skill.vo.skillSeq
{
	public class SkillSeqItemVO
	{
		public function SkillSeqItemVO(x:XML)
		{
			parser(x);
		}
		
		public var row:int;
		public var value:String;
		public var frame_ls:Array;
		
		private function parser(x:XML):void
		{
			row = int(x.@i);
			value = x.@v;
			frame_ls = value.split(",");
			
		}
		
		
		
	}
}
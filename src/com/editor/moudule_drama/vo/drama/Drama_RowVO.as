package com.editor.moudule_drama.vo.drama
{
	import com.editor.moudule_drama.timeline.vo.TimelineRow_BaseVO;

	public class Drama_RowVO extends TimelineRow_BaseVO
	{
		public function Drama_RowVO(id:String="", name:String="", type:int=0, index:int=0)
		{
			super(id, name, type, index)
		}
	}
}
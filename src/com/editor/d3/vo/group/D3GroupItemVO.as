package com.editor.d3.vo.group
{
	import com.sandy.utils.StringTWLUtil;

	public class D3GroupItemVO
	{
		public function D3GroupItemVO(obj:*)
		{
			id = int(obj.id);
			name = obj.name;
			info = obj.info;
			expend1 = obj.expend1;
			//1:能添加，删除
			enAdd = int(obj.enAdd) == 1?true:false;
			attri = obj.attri;
			if(StringTWLUtil.isWhitespace(attri)) attri = "";
			attri2 = obj.attri2;
			if(StringTWLUtil.isWhitespace(attri2)) attri2 = "";
		}
		
		public var attri:String;
		public var attri2:String;
		public var info:String;
		public var expend1:String;
		public var id:int;
		public var name:String;
		public var enAdd:Boolean;
	}
}
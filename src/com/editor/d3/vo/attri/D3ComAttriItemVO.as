package com.editor.d3.vo.attri
{
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.interfac.ICloneInterface;

	public class D3ComAttriItemVO
	{
		public function D3ComAttriItemVO(obj:Object=null,_isParticle:Boolean=false)
		{
			if(obj == null) return ;
			
			isParticle = _isParticle;
			
			id 			= int(obj.id);
			key 		= obj.key;
			//key = key.toLowerCase();
			value 		= obj.value;
			expand 		= obj.expend;
			toolTip 	= obj.toolTip;
			type 		= obj.type;
			defaultValue = obj.defaultValue;
			dataType = obj.dataType;
			if(StringTWLUtil.isWhitespace(dataType)){
				dataType = "number"
			}
			//1:需要不停的变化的属性
			expand2 = obj.expand2;
			if(StringTWLUtil.isWhitespace(expand2)) expand2 = "";
			//1:不需要点击，选择
			expand3 = obj.expand3;
			if(StringTWLUtil.isWhitespace(expand3)) expand3 = "";
			disabled	= obj.disabled == "1" ? true:false;
		}
		
		public var disabled:Boolean;
		public var isParticle:Boolean;
		//数据类型
		public var dataType:String = "number";
		public var type:String;
		public var id:int;
		public var key:String;
		//属性类型
		public var value:String;
		public var expand:String;
		public var toolTip:String;
		public var defaultValue:*;
		private var expand2:String="";
		private var expand3:String="";
		
		public function getExpand2(i:int):*
		{
			return expand2.split(",")[i]
		}
		
		public function getExpand3(i:int):*
		{
			return expand3.split(",")[i]
		}
		
		public function cloneObject():*
		{
			var item:D3ComAttriItemVO = new D3ComAttriItemVO();
			ToolUtils.clone(this,item);
			return item;
		}
		
	}
}
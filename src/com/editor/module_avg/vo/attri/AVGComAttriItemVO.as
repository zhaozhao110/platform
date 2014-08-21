package com.editor.module_avg.vo.attri
{
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.interfac.ICloneInterface;

	public class AVGComAttriItemVO implements ICloneInterface
	{
		public function AVGComAttriItemVO(obj:Object=null,_isParticle:Boolean=false)
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
			expand2 = obj.expand2;
			expand3 = obj.expand3;
		}
		
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
		public var expand2:String;
		public var expand3:String;
		
		public function cloneObject():*
		{
			var item:AVGComAttriItemVO = new AVGComAttriItemVO();
			ToolUtils.clone(this,item);
			return item;
		}
		
	}
}
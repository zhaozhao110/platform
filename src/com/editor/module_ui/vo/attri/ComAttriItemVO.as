package com.editor.module_ui.vo.attri
{
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.interfac.ICloneInterface;

	public class ComAttriItemVO implements ICloneInterface
	{
		public function ComAttriItemVO(obj:Object=null)
		{
			if(obj == null) return ;
			
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
		}
		
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
		
		
		public function checkIsAttri():Boolean
		{
			return StringTWLUtil.isWhitespace(type) || type == "1" || type == "0"
		}
		
		public function checkIsStyle():Boolean
		{
			return type == "2";
		}
		
		public function cloneObject():*
		{
			var item:ComAttriItemVO = new ComAttriItemVO();
			ToolUtils.clone(this,item);
			return item;
		}
		
	}
}
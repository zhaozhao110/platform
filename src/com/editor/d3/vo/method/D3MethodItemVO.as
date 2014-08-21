package com.editor.d3.vo.method
{
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.vo.comp.ID3CompItem;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;

	public class D3MethodItemVO implements ID3CompItem
	{
		public function D3MethodItemVO(obj:Object=null)
		{
			if(obj == null) return ;
			id = int(obj.id);
			compId = id;
			name = obj.name;
			name = StringTWLUtil.setFristLowerChar(name);
			en = name;
			outline_attri = obj.outline_attri;
			groups = obj.group1;
		}
		
		public var compId:int;
		public var groups:String;
		
		private var _en:String;
		public function get en():String
		{
			return _en;
		}
		public function set en(value:String):void
		{
			_en = value;
		}

		private var _group:int;
		public function get group():int
		{
			return _group;
		}
		public function set group(value:int):void
		{
			_group = value;
		}
		
		private var _data:*;
		public function get data():*
		{
			return _data;
		}
		public function set data(value:*):void
		{
			_data = value;
		}
		
		private var _outline_attri2:String;
		public function get outline_attri2():String
		{
			return _outline_attri2;
		}
		public function set outline_attri2(value:String):void
		{
			_outline_attri2 = value;
		}
		
		private var _id:int;
		public function get id():int
		{
			return _id;
		}
		public function set id(value:int):void
		{
			_id = value;
		}
		
		private var _name:String;
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			_name = value;
		}
		
		private var _outline_attri:String;
		public function get outline_attri():String
		{
			return _outline_attri;
		}
		public function set outline_attri(value:String):void
		{
			_outline_attri = value;
		}

		private var _project_attri:String;
		public function get project_attri():String
		{
			return _project_attri;
		}
		public function set project_attri(value:String):void
		{
			_project_attri = value;
		}
		
		public function get isSkyBox():Boolean
		{
			return false
		}
		
		public function getObject(from:int):D3ObjectBase
		{
			return null
		}
		
		public function cloneObject():*
		{
			var item:D3MethodItemVO = new D3MethodItemVO();
			ToolUtils.clone(this,item);
			return item;
		}
	}
}
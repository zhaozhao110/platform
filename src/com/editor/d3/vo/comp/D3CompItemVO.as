package com.editor.d3.vo.comp
{
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectAnim;
	import com.editor.d3.object.D3ObjectGroup;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectMesh;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.object.D3ObjectTexture;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;

	public class D3CompItemVO implements ID3CompItem
	{
		public function D3CompItemVO(obj:*=null)
		{
			if(obj == null) return 
			id = int(obj.id);
			name = obj.name;
			group = int(obj.group1);
			project_attri = obj.project_attri;
			if(StringTWLUtil.isWhitespace(project_attri)) project_attri = "";
			outline_attri = obj.outline_attri;
			if(StringTWLUtil.isWhitespace(outline_attri)) outline_attri = "";
			outline_attri2 = obj.outline_attri2;
			if(StringTWLUtil.isWhitespace(outline_attri2)) outline_attri2 = "";
			en = obj.en;
		}
		
		//英文名
		private var _en:String;
		public function get en():String
		{
			return _en;
		}
		public function set en(value:String):void
		{
			_en = value;
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

		//D3CompoenntConst
		private var _group:int;
		public function get group():int
		{
			return _group;
		}
		public function set group(value:int):void
		{
			_group = value;
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

		
		private var _outline_attri:String;
		public function get outline_attri():String
		{
			return _outline_attri;
		}
		public function set outline_attri(value:String):void
		{
			_outline_attri = value;
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
		
		private var _data:*;
		public function get data():*
		{
			return _data;
		}
		public function set data(value:*):void
		{
			_data = value;
		}
		
		public function get isSkyBox():Boolean
		{
			return id == 24;
		}
		
		public function clone():D3CompItemVO
		{
			var d:D3CompItemVO = new D3CompItemVO();
			ToolUtils.clone(this,d);
			return d;
		}
		
		public function getObject(from:int):D3ObjectBase
		{
			return D3ObjectBase.getObjectByGroup(group,from);
		}
		
		public function createMenu():String
		{
			return '<menuitem label="'+name+'" data="'+id+'"/>'
		}
	}
}
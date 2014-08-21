package com.editor.moudule_drama.vo.drama.layout
{

	/**
	 * 布局显示对象VO
	 * @author sun
	 * 
	 */	
	public class Drama_LayoutViewBaseVO implements IDrama_LayoutViewBaseVO
	{
		private var _id:String;
		private var _rowId:String;
		private var _sourceId:int;
		private var _sourceName:String;
		private var _sourceType:int;
		private var _fileType:int;
		
		public function Drama_LayoutViewBaseVO()
		{
			
		}
		
		public function clone():Drama_LayoutViewBaseVO
		{
			var cloneVO:Drama_LayoutViewBaseVO = new Drama_LayoutViewBaseVO();
			cloneVO.rowId = this.rowId;
			cloneVO.sourceId = this.sourceId;
			cloneVO.sourceName = this.sourceName;
			cloneVO.sourceType = this.sourceType;
			cloneVO.customName = this.customName;
			
			return cloneVO;
		}

		public function get rowId():String
		{
			return _rowId;
		}

		public function set rowId(value:String):void
		{
			_rowId = value;
		}

		public function get sourceId():int
		{
			return _sourceId;
		}

		public function set sourceId(value:int):void
		{
			_sourceId = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get sourceName():String
		{
			return _sourceName;
		}

		public function set sourceName(value:String):void
		{
			_sourceName = value;
		}

		public function get sourceType():int
		{
			return _sourceType;
		}

		public function set sourceType(value:int):void
		{
			_sourceType = value;
		}

		public function get fileType():int
		{
			return _fileType;
		}

		public function set fileType(value:int):void
		{
			_fileType = value;
		}

		private var _customName:String;
		public function get customName():String
		{
			return _customName;
		}
		public function set customName(value:String):void
		{
			_customName = value;
		}
		

	}
}
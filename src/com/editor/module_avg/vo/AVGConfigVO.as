package com.editor.module_avg.vo
{
	import com.editor.module_avg.vo.project.AVGProjectListVO;

	public class AVGConfigVO
	{
		public function AVGConfigVO(x:XML)
		{
			instance = this
			parser(x);
		}
		
		public static var instance:AVGConfigVO;
		
		public var serverDomain:String;
		public var resDomain:String;
		public var project_ls:AVGProjectListVO;
		
		private function parser(xml:XML):void
		{
			serverDomain = XML(xml.child("serverDomain")[0]).toString();
			resDomain = XML(xml.child("resDomain")[0]).toString();
			
			project_ls = new AVGProjectListVO(XML(xml.child("projects")[0]))
		}
		
		private var _width:int=960;
		public function get width():int
		{
			return _width;
		}
		public function set width(value:int):void
		{
			_width = value;
			if(_width <= 0){
				_width = 960
			}
		}

		private var _height:int=540;
		public function get height():int
		{
			return _height;
		}
		public function set height(value:int):void
		{
			_height = value;
			if(_height <= 0){
				_height = 540;
			}
		}

		
	}
}
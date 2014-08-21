package com.editor.module_map.vo
{
	import com.editor.module_map.vo.project.MapEditorProjectListVO;

	public class MapEditorConfigVO
	{
		public function MapEditorConfigVO(x:XML)
		{
			instance = this
			parser(x);
		}
		
		public static var instance:MapEditorConfigVO;
		
		public var serverDomain:String;
		public var project_ls:MapEditorProjectListVO;
		public var mapResURL:String
		
		private function parser(xml:XML):void
		{
			serverDomain = XML(xml.child("serverDomain")[0]).toString();
			
			mapResURL = XML(xml.child("mapSwfURL")[0]).toString();
			project_ls = new MapEditorProjectListVO(XML(xml.child("projects")[0]))
		}
	}
}
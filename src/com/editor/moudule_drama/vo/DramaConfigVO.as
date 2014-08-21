package com.editor.moudule_drama.vo
{
	import com.editor.moudule_drama.vo.project.DramaProjectListVO;

	public class DramaConfigVO
	{
		public function DramaConfigVO(x:XML)
		{
			instance = this
			parser(x);
		}
		
		public static var instance:DramaConfigVO;
		
		public var serverDomain:String;
		public var project_ls:DramaProjectListVO;
		public var mapResURL:String
		
		private function parser(xml:XML):void
		{
			serverDomain = XML(xml.child("serverDomain")[0]).toString();
			
			mapResURL = XML(xml.child("mapSwfURL")[0]).toString();
			project_ls = new DramaProjectListVO(XML(xml.child("projects")[0]))
		}
	}
}
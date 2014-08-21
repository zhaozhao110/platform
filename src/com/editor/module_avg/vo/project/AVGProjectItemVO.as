package com.editor.module_avg.vo.project
{
	import com.editor.vo.project.AppProjectItemVO;
	import com.sandy.manager.data.SandyXMLListVO;

	public class AVGProjectItemVO extends AppProjectItemVO
	{
		public function AVGProjectItemVO(x:XML)
		{
			parser(x)
		}
		
		public var xml_ls:SandyXMLListVO;
		public var saveFold:String;
		public var saveFileName:String;
		public var resFold:String;		
		public var topFold:String;
		
		private function parser(x:XML):void
		{
			data = XMLList(x.@d)[0].toString();
			getLabel();
			
			var xml:XML = XML(x.child("xml")[0]);
			xml_ls = new SandyXMLListVO(xml);
			
			saveFold = XML(x.child("saveFold")[0]).toString();
			saveFileName = XML(x.child("saveFileName")[0]).toString();
			
			resFold = XML(x.child("resFold")[0]).toString();
			topFold = XML(x.child("topFold")[0]).toString();
		}
	}
}
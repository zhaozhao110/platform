package com.editor.moudule_drama.vo.project
{
	import com.editor.vo.project.AppProjectItemVO;
	import com.sandy.manager.data.SandyXMLListVO;

	public class DramaProjectItemVO extends AppProjectItemVO
	{
		public function DramaProjectItemVO(x:XML)
		{
			parser(x)
		}
		
		public var xml_ls:SandyXMLListVO;
		public var saveFold:String;
		public var saveFileName:String;
		/**玩家_swf_url**/		
		public var mapResUrl:String;
		/**玩家_ConfigUrl**/	
		public var mapConfigUrl:String;
		
		private function parser(x:XML):void
		{
			data = XMLList(x.@d)[0].toString();
			getLabel();
			
			mapResUrl = XML(x.child("mapResURL")[0]).toString();
			mapConfigUrl = XML(x.child("mapConfigURL")[0]).toString();
			
			var xml:XML = XML(x.child("xml")[0]);
			xml_ls = new SandyXMLListVO(xml);
			
			saveFold = XML(x.child("saveFold")[0]).toString();
			saveFileName = XML(x.child("saveFileName")[0]).toString();
			
		}
	}
}
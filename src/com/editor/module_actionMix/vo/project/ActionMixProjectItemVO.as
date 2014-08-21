package com.editor.module_actionMix.vo.project
{
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.project.AppProjectItemVO;
	import com.sandy.manager.data.SandyXMLListVO;

	public class ActionMixProjectItemVO extends AppProjectItemVO
	{
		public function ActionMixProjectItemVO(x:XML)
		{
			parser(x)
		}
		
		public var xml_ls:SandyXMLListVO;
		
		public var saveFold:String;
		public var saveFileName:String;
		//玩家_swf_url
		public var userSWFUrl:String;
		
		private function parser(x:XML):void
		{
			data = XMLList(x.@d)[0].toString();
			getLabel();
			
			userSWFUrl = XML(x.child("userSWFUrl")[0]).toString();
			
			var xml:XML = XML(x.child("xml")[0]);
			xml_ls = new SandyXMLListVO(xml);
			
			saveFold = XML(x.child("saveFold")[0]).toString();
			saveFileName = XML(x.child("saveFileName")[0]).toString();
			
		}
	}
}
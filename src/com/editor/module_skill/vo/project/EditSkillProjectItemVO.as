package com.editor.module_skill.vo.project
{
	import com.editor.vo.project.AppProjectItemVO;
	import com.sandy.manager.data.SandyXMLListVO;

	public class EditSkillProjectItemVO extends AppProjectItemVO
	{
		public function EditSkillProjectItemVO(x:XML)
		{
			parser(x)
		}
		
		public var xml_ls:SandyXMLListVO;
		public var saveFold:String;
		public var saveFileName:String;
		//玩家_swf_url
		public var userSWFUrl:String;
		public var effectSWFUrl:String;
		public var monsterSWFUrl:String;
		
		private function parser(x:XML):void
		{
			data = XMLList(x.@d)[0].toString();
			getLabel();
			
			userSWFUrl = XML(x.child("userSWFUrl")[0]).toString();
			effectSWFUrl = XML(x.child("effectSWFUrl")[0]).toString();
			monsterSWFUrl = XML(x.child("monsterSWFUrl")[0]).toString();
			
			var xml:XML = XML(x.child("xml")[0]);
			xml_ls = new SandyXMLListVO(xml);
			
			saveFold = XML(x.child("saveFold")[0]).toString();
			saveFileName = XML(x.child("saveFileName")[0]).toString();
			
		}
	}
}
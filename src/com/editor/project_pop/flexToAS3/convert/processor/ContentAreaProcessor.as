package com.editor.project_pop.flexToAS3.convert.processor
{
	import com.editor.project_pop.flexToAS3.convert.ConvertFlex;
	import com.editor.project_pop.flexToAS3.convert.vo.ConvertData;
	

	public class ContentAreaProcessor extends ProcessorBase
	{
		public function ContentAreaProcessor(_convert:ConvertFlex)
		{
			super(_convert);
		}
		
		public static const metadata:Array = ["bottom_contentArea",
												"areaComponent",
												"middle_contentArea",
												"top_contentArea",
												"contentArea",
												"bot_contentArea"]
		
		private var convertData:ConvertData = new ConvertData();
			
		public function parser(xml:XML,parentId:String=null):void
		{
			var className:String = xml.localName().toString();
			var component_ls:Array = [];
			
			convertData.init_str = NEWLINE_SIGN+createSpace(3)+"//"+className;
			var child_ls:XMLList = xml.children();
			
			for(var i:int=0;i<child_ls.length();i++)
			{
				var child_xml:XML = XML(child_ls[i]);
				
				var id:String = child_xml.attribute("id")[0];
								
				var childParentId:String = convertC.parserXML(child_xml,false,convertData,true,id);
				component_ls.push(childParentId);
				convertC.parserChildXML(child_xml,convertData,childParentId);
			}
			
			if(component_ls.length>0)
			{
				var array_name:String = className+"_ls";
				convertData.init_str += NEWLINE_SIGN+createSpace(3)+"var"+createSpace2()+array_name+":Array"+createSpace2()+"="+createSpace2()+"[];"+NEWLINE_SIGN
				for(i=0;i<component_ls.length;i++)
				{
					convertData.init_str += createSpace(3)+array_name+".push("+component_ls[i]+");"+NEWLINE_SIGN;
				}
				convertData.init_str += createSpace(3)+(parentId==null?"this":parentId)+"."+className+"="+array_name+NEWLINE_SIGN;
			}
			
			convertC.data.init_str += convertData.init_str;
		}
		
		
		
	}
}
package com.editor.module_gdps.utils
{
	public class GdpsXMLToObject
	{
		public function GdpsXMLToObject()
		{
		}
		
		/**
		 * xml转换成object
		 */
		public static function xmlToObject(xml:XML):Object
		{
			var obj:Object = {};
			var ls:XMLList = xml.children();
			
			if(ls.length() > 0)
			{
				var i:int = 0;
				for(i = 0;i < ls.length();i++)
				{
					var node:XML = ls[i];
					var value:String = String(node);
					var child:XMLList = node.children().children();
					
					if(child.length() > 0)
					{
						obj[node.name()] = xmlToObject(node);
					}
					else
					{
						obj[node.name()] = value;
					}
				}
			}
			return obj;
		}
	}
}
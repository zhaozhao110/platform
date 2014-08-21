package com.editor.project_pop.createXMLVO
{
	import com.air.io.ReadFile;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.XMLToJson;
	
	import flash.filesystem.File;

	public class ParserXMLVOTool
	{
		public function ParserXMLVOTool()
		{
			
		}
		
		public static var instance:ParserXMLVOTool
		
		private var xml:XML;
		public var g_obj:Object;
		private var g_a:Array;
		public var i_obj:Object;
		private var i_a:Array;
		private var g_map:Array;
		private var i_map:Array;
		
		public function parser(fl:File):void
		{
			xml = null;
			g_obj = null;i_obj = null;
			g_a = null;i_a = null;
			g_map = null;i_map = null;
			
			var read:ReadFile = new ReadFile();
			xml = XML(read.readFromFile(fl));
			
			var ls1:XMLList = xml.child("g")
			var g_xml:XML = XML(ls1[0]);
			if(g_xml!=null&&!StringTWLUtil.isWhitespace(g_xml.toXMLString())){
				var p:XMLToJson = new XMLToJson();
				g_obj = p.parse(g_xml);
				
				var ls2:XMLList = g_xml.child("i")
				var i_xml:XML;
				if(ls2.length() == 1){
					i_xml = XML(ls2[0]);
				}else if(ls2.length() > 1){
					i_xml = XML(ls2[1]);
				}
				if(i_xml!=null&&!StringTWLUtil.isWhitespace(i_xml.toXMLString())){
					p = new XMLToJson();
					i_obj = p.parse(i_xml);
				}
			}
			else
			{
				ls2 = xml.child("i")
				i_xml = XML(ls2[0]);
				if(i_xml!=null&&!StringTWLUtil.isWhitespace(i_xml.toXMLString())){
					p = new XMLToJson();
					i_obj = p.parse(i_xml);
				}
			}
		}
		
		public function getGroup():Array
		{
			if(g_a == null){
				var a:Array = [];
				g_map = [];
				for(var key:String in g_obj){
					if(key!="_content" && !StringTWLUtil.isWhitespace(key)){
						var item:PaserXMLVO = new PaserXMLVO();
						item.isGroup = true;
						item.xml = key;
						a.push(item);
						g_map[item.xml] = item;
					}
				}
				g_a = a;	
			}
			return g_a;
		}
		
		public function putGroup_vo(key:String,value:String):void
		{
			PaserXMLVO(g_map[key]).vo = value;
		}
		
		public function putGroup_info(key:String,value:String):void
		{
			PaserXMLVO(g_map[key]).info = value;
		}
		
		public function getItem():Array
		{
			if(i_a == null){
				var a:Array = [];
				i_map = [];
				for(var key:String in i_obj){
					if(key!="_content" && !StringTWLUtil.isWhitespace(key)){
						var item:PaserXMLVO = new PaserXMLVO();
						item.xml = key;
						a.push(item);
						i_map[item.xml] = item;
					}
				}
				i_a = a;
			}
			return i_a;
		}
		
		public function putItem_vo(key:String,value:String):void
		{
			PaserXMLVO(i_map[key]).vo = value;
		}
		
		public function putItem_info(key:String,value:String):void
		{
			PaserXMLVO(i_map[key]).info = value;
		}
		
	}
}
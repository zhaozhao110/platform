package com.editor.module_ui.css
{
	import com.air.io.ReadFile;
	import com.editor.manager.StackManager;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.sandy.style.SandyStyleEmbedData;
	import com.sandy.style.SandyStyleNameData;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class PaserCSSXML
	{
		public function PaserCSSXML(d:CSSComponentData=null)
		{
			if(d!=null){
				parser(d)
			}
		}
		
		private var data:CSSComponentData;
		private var xml:XML;
		private var map:Array = [];
		
		private function parser(d:CSSComponentData):void
		{
			data = d;
			var xml_path:String = d.file.parent.nativePath+File.separator+"xml"+File.separator+d.file.name.split(".")[0]+".xml"
			var fl:File = new File(xml_path);
			if(!fl.exists){
				StackManager.getInstance().addCurrLogCont("文件不存在:" + fl.nativePath+",如果CSS的配置文件丢死，将无法还原，请手动在属性列表里输入，然后发布成配置文件");
				return ;
			}
			var read:ReadFile = new ReadFile();
			var c:String = read.readCompressByteArray(xml_path);
			
			xml = XML(c);
			parserXML(xml);
		}
		
		public function parserXML(x:XML):void
		{
			xml = x;
			map = null;
			map = [];
			for each(var p:XML in xml.item){
				var item:PaserCSSXMLItemVO = new PaserCSSXMLItemVO(p);
				map[item.key] = item;
			}
		}
		
		public function parserXMLToStyleName(x:XML):SandyStyleNameData
		{
			var d:SandyStyleNameData = new SandyStyleNameData();
			for each(var p:XML in x.item){
				var item:PaserCSSXMLItemVO = new PaserCSSXMLItemVO(p);
				if(item.key == "name"){
					d.styleName = item.getCSSName();
					break;
				}
			}
			for each(p in x.item){
				item = new PaserCSSXMLItemVO(p);
				if(item.key != "name"){
					var dt:SandyStyleEmbedData = new SandyStyleEmbedData();
					dt.key = item.key;
					dt.value = item.value;
					if(CreateCSSFileItemVO.isFilters(dt.key)){
						dt.value = CreateCSSFileItemVO.convertToFilterArray(dt.value);
					}
					dt.styleName = d.styleName;
					d.attri_ls[dt.key] = dt;
				}
			}
			return d;
		}
		
		public function getValue(key:String):PaserCSSXMLItemVO
		{
			return map[key] as PaserCSSXMLItemVO;
		}
		
		public function getXMLPath(file:File):String
		{
			if(file.extension == "as"){
				return file.parent.nativePath+File.separator+"xml"+File.separator+file.name.split(".")[0]+".xml"
			}
			return file.nativePath;
		}
		
	}
}
package com.editor.module_ui.vo.expandComp
{
	import com.air.io.WriteFile;
	import com.editor.model.AppMainModel;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.XMLToJson;

	public class ExpandCompListVO
	{
		public function ExpandCompListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.item){
				var item:ExpandCompItemVO = new ExpandCompItemVO(p);
				list[item.type] = item;
			}
		}
			
		public function getItem(type:String):ExpandCompItemVO
		{
			return list[type] as ExpandCompItemVO;
		}
		
		public function createXML():String
		{
			var c:String = "<!--author by ["+AppMainModel.getInstance().user.shortName+"], please not delete -->";  
			c += '<?xml version="1.0" encoding="UTF-8"?>';
			c += "<list>";
			for each(var item:ExpandCompItemVO in list){
				if(item!=null && !item.checkIsProxyComp() ){
					c += item.createXML()+StringTWLUtil.NEWLINE_SIGN;
				}
			}
			c += "</list>"
			return c;
		}
		
		public function reflash(a:Array):void
		{
			for(var i:int=0;i<a.length;i++){
				var xml:XML = XML(a[i]);
				var item:ExpandCompItemVO = new ExpandCompItemVO(xml);
				list[item.type] = item;
			}
			
		}
	}
}
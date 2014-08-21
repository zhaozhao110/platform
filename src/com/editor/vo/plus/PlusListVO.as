package com.editor.vo.plus
{
	public class PlusListVO
	{
		public function PlusListVO(x:XML)
		{
			org_xml = x;
			parser(x);
		}
		
		public var org_xml:XML;
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.i){
				var d:PlusItemVO = new PlusItemVO(p);
				list.push(d);
			}
		}
		
		public function checkHave(type:String):Boolean
		{
			for(var i:int=0;i<list.length;i++){
				if(PlusItemVO(list[i]).name == type){
					return true;
				}
			}
			return false;
		}
		
		public function getItem(type:String):PlusItemVO
		{
			for(var i:int=0;i<list.length;i++){
				if(PlusItemVO(list[i]).name == type){
					return list[i];
				}
			}
			return null;
		}
		
		
	}
}
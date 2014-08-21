package com.editor.module_actionMix.vo
{
	/**
	 * action.xml里的,excel里的
	 */
	public class ActionMixActionXMLItemVO
	{
		public function ActionMixActionXMLItemVO(x:XML)
		{
			parser(x);
		}
		
		public var id:Number;
		public var actionGruopId:Number;
		public var name:String;
		
		private function parser(x:XML):void
		{
			id = Number(x.@a);
			actionGruopId = Number(x.@t);
			name = x.@n;
			
			name1 = id + " / " + name
		}
		
		public var name1:String;
	}
}
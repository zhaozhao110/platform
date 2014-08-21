package com.editor.project_pop.flexToAS3.convert.processor
{
	import com.editor.project_pop.flexToAS3.convert.ConvertFlex;
	

	public class ScriptProcessor extends ProcessorBase
	{
		public function ScriptProcessor(_convert:ConvertFlex)
		{
			super(_convert);
		}
		
		public static const metadata:String = "Script"
		
		public function parser(xml:XML):void
		{
			convertC.data.script = xml.text();
		}
		
	}
}
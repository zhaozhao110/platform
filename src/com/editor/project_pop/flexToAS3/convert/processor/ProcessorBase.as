package com.editor.project_pop.flexToAS3.convert.processor
{
	import com.editor.project_pop.flexToAS3.convert.ConvertFlex;
	import com.editor.project_pop.flexToAS3.convert.vo.ConvertData;
	import com.sandy.utils.StringTWLUtil;
	
	public class ProcessorBase
	{
		public function ProcessorBase(_convert:ConvertFlex)
		{
			convertC = _convert
		}
		
		protected var convertC:ConvertFlex;
		
		
		
		
		
		
		protected function createSpace(n:int=1):String
		{
			var out:String = "";
			for(var i:int=0;i<n;i++){
				out += "	";
				//out += " "
			}
			return out;
		}
		
		protected function createSpace2(n:int=1):String
		{
			var out:String = "";
			for(var i:int=0;i<n;i++){
				//out += "	";
				out += " "
			}
			return out;
		}
		
		protected function createUIComponentIndex():int
		{
			return ConvertData.createUIComponentIndex();
		}
		
		protected function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
	}
}
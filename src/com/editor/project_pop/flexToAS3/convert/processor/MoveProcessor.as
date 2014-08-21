package com.editor.project_pop.flexToAS3.convert.processor
{
	import com.editor.project_pop.flexToAS3.convert.ConvertFlex;
	import com.editor.project_pop.flexToAS3.convert.vo.VariableData;
	
	
	public class MoveProcessor extends ProcessorBase
	{
		public function MoveProcessor(_convert:ConvertFlex)
		{
			super(_convert);
		}
		
		public static const metadata:String = "Move";
		
		
		public function parser(xml:XML):void
		{
			var ns:Object = {};
			ns.prefix = "Move"
			ns.uri = "com.sandy.asComponent.effect.ASMove"
			convertC.data.custom_namespace.push(ns);
			
			var vari:VariableData = new VariableData();
			vari.className = "ASMove"
			vari.id = xml.attribute("id")[0];
			vari.comments = xml.comments()[0];
			convertC.data.variable.push(vari);
			
			var clsStr:String = NEWLINE_SIGN
			clsStr += createSpace(3)+vari.id+createSpace2()+"="+createSpace2()+"new"+createSpace2()+"ASMove;"+NEWLINE_SIGN;
			clsStr += convertC.createAttriAndValue(xml,vari.id);
			clsStr += NEWLINE_SIGN;
			
			convertC.data.init_str += clsStr 
		}
			
	}
}
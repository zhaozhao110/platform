package com.editor.d3.view.attri
{
	import com.editor.d3.view.attri.cell.D3ComAnims;
	import com.editor.d3.view.attri.cell.D3ComBones;
	import com.editor.d3.view.attri.cell.D3ComControllers;
	import com.editor.d3.view.attri.cell.D3ComLight;
	import com.editor.d3.view.attri.cell.D3ComMethod;
	import com.editor.d3.view.attri.com.D3ComArray;
	import com.editor.d3.view.attri.com.D3ComAutoCompleteComboBox;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBoolean;
	import com.editor.d3.view.attri.com.D3ComButton;
	import com.editor.d3.view.attri.com.D3ComColor;
	import com.editor.d3.view.attri.com.D3ComComboBox;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.editor.d3.view.attri.com.D3ComInput;
	import com.editor.d3.view.attri.com.D3ComNumericStepper;
	import com.editor.d3.view.attri.com.D3ComVector3D;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	
	
	public class D3ComTypeManager
	{
		public static var inited:Boolean;
		public static function init():void
		{
			if(inited) return ;
			inited = true;
			D3ComAnims;
			D3ComBones;
			D3ComLight;
			D3ComMethod;
			D3ComControllers;
		}
		
		public static function getComByType(type:String):ID3ComBase
		{
			init();
			if(type == "input"){
				return new D3ComInput()
			}else if(type == "numericStepper"){
				return new D3ComNumericStepper();
			}else if(type == "file"){
				return new D3ComFile();
			}else if(type == "boolean"){
				return new D3ComBoolean();
			}else if(type == "color"){
				return new D3ComColor();
			}else if(type == "combobox"){
				return new D3ComComboBox();
			}else if(type == "autoCompleteComboBox"){
				return new D3ComAutoCompleteComboBox();
			}else if(type == "array"){
				return new D3ComArray();
			}else if(type == "button"){
				return new D3ComButton();
			}else if(type == "vector3D"){
				return new D3ComVector3D();
			}else{
				var n:String = "com.editor.d3.view.attri.cell.D3Com"+StringTWLUtil.setFristUpperChar(type);
				var cls:Class = getDefinitionByName(n) as Class;
				return new cls();
			}
			return null;
		}
		
	}
}
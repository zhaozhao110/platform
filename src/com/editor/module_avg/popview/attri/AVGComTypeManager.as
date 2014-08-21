package com.editor.module_avg.popview.attri
{
	
	import com.editor.module_avg.popview.attri.com.AVGComBase;
	import com.editor.module_avg.popview.attri.com.AVGComButton;
	import com.editor.module_avg.popview.attri.com.AVGComCheckBox;
	import com.editor.module_avg.popview.attri.com.AVGComInput;
	import com.editor.module_avg.popview.attri.com.AVGComNumericStepper;
	
	import flash.display.DisplayObject;

	public class AVGComTypeManager
	{
		public function AVGComTypeManager()
		{
		}
		
		public static function getComByType(type:String):AVGComBase
		{
			if(type == "input"){
				return new AVGComInput()
			}else if(type == "numericStepper"){
				return new AVGComNumericStepper();
			}else if(type == "button"){
				return new AVGComButton();
			}else if(type == "boolean"){
				return new AVGComCheckBox();
			}
			return null;
		}
		
	}
}
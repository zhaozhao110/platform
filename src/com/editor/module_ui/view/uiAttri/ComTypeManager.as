package com.editor.module_ui.view.uiAttri
{
	import com.editor.component.controls.UINumericStepper;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_ui.view.uiAttri.com.ComArray;
	import com.editor.module_ui.view.uiAttri.com.ComAutoCompleteComboBox;
	import com.editor.module_ui.view.uiAttri.com.ComBase;
	import com.editor.module_ui.view.uiAttri.com.ComBoolean;
	import com.editor.module_ui.view.uiAttri.com.ComButton;
	import com.editor.module_ui.view.uiAttri.com.ComColor;
	import com.editor.module_ui.view.uiAttri.com.ComCombobox;
	import com.editor.module_ui.view.uiAttri.com.ComFile;
	import com.editor.module_ui.view.uiAttri.com.ComInput;
	import com.editor.module_ui.view.uiAttri.com.ComNumericStepper;
	import com.editor.module_ui.view.uiAttri.com.ComStyleName;
	import com.sandy.asComponent.core.ASComponent;
	
	import flash.display.DisplayObject;

	public class ComTypeManager
	{
		public function ComTypeManager()
		{
		}
		
		public static function getComByType(type:String):ComBase
		{
			if(type == "input"){
				return new ComInput()
			}else if(type == "numericStepper"){
				return new ComNumericStepper();
			}else if(type == "file"){
				return new ComFile();
			}else if(type == "boolean"){
				return new ComBoolean();
			}else if(type == "color"){
				return new ComColor();
			}else if(type == "combobox"){
				return new ComCombobox();
			}else if(type == "autoCompleteComboBox"){
				return new ComAutoCompleteComboBox();
			}else if(type == "array"){
				return new ComArray();
			}else if(type == "styleName"){
				return new ComStyleName();
			}else if(type == "button"){
				return new ComButton();
			}
			return null;
		}
		
	}
}
package com.editor.d3.pop.curveEditor
{
	import com.editor.component.controls.UILabel;
	import com.sandy.utils.NumberUtils;

	public class CurveEditorLabel extends UILabel
	{
		public function CurveEditorLabel()
		{
			super();
			height = 15
			width = 30
			textAlign = "right";
		}
		
		override public function set text(value:String):void
		{
			if(value.indexOf(".")!=-1){
				value = NumberUtils.toFixed(Number(value),2).toString();
			}
			super.text = value;
		}
		
	}
}
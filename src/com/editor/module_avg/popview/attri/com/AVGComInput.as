package com.editor.module_avg.popview.attri.com
{
	import com.editor.component.controls.UITextInput;
	import com.editor.module_avg.popview.attri.AVGAttriComBaseVO;
	import com.sandy.utils.NumberUtils;
	import com.sandy.utils.StringTWLUtil;

	public class AVGComInput extends AVGComBase
	{
		public function AVGComInput()
		{
			super();
		}
		
		private var input:UITextInput;
		
		override protected function create_init():void
		{
			super.create_init();
			
			input = new UITextInput();
			input.height = 22
			input.percentWidth = 100;
			input.enterKeyDown_proxy = enterKeyDown;
			addChild(input);
		}
		
		private function enterKeyDown():void
		{
			callUIRender();
		}
		
		override public function setValue(obj:AVGAttriComBaseVO):void
		{
			super.setValue(obj);
			
			var v:* = getCompValue();
			if(StringTWLUtil.isNumber(v)){
				input.text = NumberUtils.toFixed(v,2).toString();
			}else{
				input.text = v;
			}
			
			if(item.expand == "1"){
				input.editable = false;
			}else{
				input.editable = true
			}
		}
		
		override protected function resetCom():void
		{
			input.text = "";
		}
		
		override public function getValue():AVGAttriComBaseVO
		{
			var d:AVGAttriComBaseVO = createComBaseVO();
			d.data = input.text;
			return d
		}
		
	}
}
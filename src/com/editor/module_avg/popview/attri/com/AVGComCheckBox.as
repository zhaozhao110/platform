package com.editor.module_avg.popview.attri.com
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.module_avg.popview.attri.AVGAttriComBaseVO;
	import com.sandy.asComponent.event.ASEvent;

	public class AVGComCheckBox extends AVGComBase
	{
		public function AVGComCheckBox()
		{
			super();
		}
		
		private var cb:UICheckBox;
		
		override protected function create_init():void
		{
			super.create_init();
			
			cb = new UICheckBox();
			cb.label = "false";
			cb.width = 140
			cb.selected = false
			cb.addEventListener(ASEvent.CHANGE,onChangeHandle);
			addChild(cb);
		}
		
		private function onChangeHandle(e:ASEvent):void
		{
			if(cb.selected){
				cb.label = "true"
			}else{
				cb.label = "false"
			}
			callUIRender();
		}
		
		override public function getValue():AVGAttriComBaseVO
		{
			var d:AVGAttriComBaseVO = createComBaseVO();
			d.data = cb.selected == true?1:0;
			return d
		}
		
		override public function setValue(obj:AVGAttriComBaseVO):void
		{
			super.setValue(obj);
			
			if(getCompValue() == null){
				cb.setSelect(item.defaultValue=="true"?true:false,false);
			}else{
				cb.setSelect(getCompValue().toString()=="1"?true:false,false);
			}
			
			if(cb.selected){
				cb.label = "true"
			}else{
				cb.label = "false"
			}
			
		}
		
	}
}
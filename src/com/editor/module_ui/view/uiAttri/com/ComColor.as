package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.manager.StackManager;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.sandy.asComponent.controls.ASColorPicker;
	import com.sandy.asComponent.controls.ASColorPickerBar;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;

	public class ComColor extends ComBase
	{
		public function ComColor()
		{
			super();
		}
		
		private var col:ASColorPickerBar;
		
		override protected function create_init():void
		{
			super.create_init();
			
			col = new ASColorPickerBar();
			col.width = 120;
			col.height = 22;
			col.addEventListener(ASEvent.CHANGE,onChangeHandle);
			addChild(col);
		}
		
		private function onChangeHandle(e:ASEvent):void
		{
			callUIRender();
		}
		
		override public function getValue():IComBaseVO
		{
			var d:ComBaseVO = new ComBaseVO();
			initVO(d);
			d.value = col.selectedColor;
			return d;
		}
		
		override protected function reflash_init():void
		{
			super.reflash_init();
			
		}
		
		override public function setValue(obj:IComBaseVO):void
		{
			super.setValue(obj);
			if(StackManager.checkIsEditCSS()){
				if(css_data.paser.getValue(item.key)!=null){
					if(!StringTWLUtil.isWhitespace(css_data.paser.getValue(item.key).getVO().value)){
						col.setColor(css_data.paser.getValue(item.key).getVO().value,false);
					}
				}
			}
			if(StackManager.checkIsEditUI()){
				if(obj!=null){
					col.setColor(obj.value,false);
				}else{
					col.setColor(null,false);
				}
			}
		}
		
		
	}
}
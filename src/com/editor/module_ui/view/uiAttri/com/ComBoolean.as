package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.manager.StackManager;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.sandy.asComponent.event.ASEvent;

	public class ComBoolean extends ComBase
	{
		public function ComBoolean()
		{
			super();
		}
		
		private var cb:UICheckBox;
		
		override protected function create_init():void
		{
			super.create_init();
			
			cb = new UICheckBox();
			cb.label = "false";
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
		
		override public function getValue():IComBaseVO
		{
			var d:ComBaseVO = new ComBaseVO();
			initVO(d);
			d.value = cb.selected==true?"true":"false";
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
				if(css_data!=null&&css_data.paser.getValue(item.key)!=null){
					cb.setSelect(css_data.paser.getValue(item.key).getVO().value,false);
				}
			}  
			if(StackManager.checkIsEditUI()){
				if(obj!=null && (obj.value == "true" || obj.value == true)){
					cb.setSelect(true,false);
				}else{
					cb.setSelect(false,false);
				}
			}
			
			if(cb.selected){
				cb.label = "true"
			}else{
				cb.label = "false"
			}
		}
		
	}
}
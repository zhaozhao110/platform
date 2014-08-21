package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.component.controls.UIButton;
	import com.editor.manager.StackManager;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class ComButton extends ComBase
	{
		public function ComButton()
		{
			super();
		}
		
		private var btn:UIButton;
		
		override protected function create_init():void
		{
			super.create_init();
			
			btn = new UIButton();
			btn.addEventListener(MouseEvent.CLICK,onClickHandle)
			addChild(btn);
		}
		
		override public function getValue():IComBaseVO
		{
			var d:ComBaseVO = new ComBaseVO();
			initVO(d);
			d.value = item;
			return d;
		}
		
		private function onClickHandle(e:MouseEvent):void
		{
			callUIRender();
			/*if(item.id == 89 || item.id == 90){
				
			}*/
		}
		
		override protected function reflash_init():void
		{
			super.reflash_init();
			
		}
		
		override public function setValue(obj:IComBaseVO):void
		{
			super.setValue(obj);
			
			btn.label = item.expand;
			
			if(obj!=null){
				if(!StringTWLUtil.isWhitespace(obj.value)){
					btn.label = obj.value;
				}
			}
			
		}
		
		
		
	}
}
package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.component.controls.UINumericStepper;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;

	public class ComNumericStepper extends ComBase
	{
		public function ComNumericStepper()
		{
			super();
		}
		
		private var ns:UINumericStepper;
		
		override protected function create_init():void
		{
			super.create_init();
			
			ns = new UINumericStepper();
			ns.enterKeyDown_proxy = enterKeyDown
			ns.percentWidth = 100;
			ns.editable = true;
			ns.maximum = 100;
			ns.minimum = 0;
			ns.addEventListener(ASEvent.CHANGE, onValueChange)
			ns.height = 22;
			addChild(ns);			
		}
		
		private function enterKeyDown():void
		{
			callUIRender();
		}
		
		private function onValueChange(e:ASEvent):void
		{
			callUIRender();
		}
		
		override protected function reflash_init():void
		{
			super.reflash_init();
			
			if(!StringTWLUtil.isWhitespace(item.expand)){
				var a:Array = item.expand.split("-");
				ns.minimum = Number(a[0]);
				ns.maximum = Number(a[1]);
				if(ns.maximum == 1){
					ns.stepSize = .1;
				}else{
					ns.stepSize = 1;
				}
				ns.value = ns.maximum;
			}
		}
		
		override public function getValue():IComBaseVO
		{
			var d:ComBaseVO = new ComBaseVO();
			initVO(d);
			d.value = ns.value;
			return d;
		}
		
		override public function setValue(obj:IComBaseVO):void
		{
			super.setValue(obj);
			
			if(obj!=null){
				if(!StringTWLUtil.isWhitespace(obj.value)){
					ns.value = obj.value;
				}
			}
		}
		
		
	}
}
package com.editor.d3.view.attri.com
{
	import com.editor.component.controls.UINumericStepper;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;

	public class D3ComNumericStepper extends D3ComBase
	{
		public function D3ComNumericStepper()
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
			ns.maximum = 10000000;
			ns.minimum = -10000000
			ns.addEventListener(ASEvent.CHANGE, onValueChange)
			ns.height = 22;
			addChild(ns);			
		}
		
		private function enterKeyDown():void
		{
			callUIRender();
		}
		
		override public function setValue():void
		{
			super.setValue();
			
			if(Stack3DManager.isParticleStack){
				ns.value = 0;
				ns.stepSize = .1;
			}
			
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
			
			if(!StringTWLUtil.isWhitespace(item.defaultValue)){
				ns.value = int(item.defaultValue);
			}
			
			var v:* = getCompValue();
			if(v!=null) ns.value = v; 
		}
		
		private function onValueChange(e:ASEvent):void
		{
			callUIRender();
		}
		
		override public function getValue():D3ComBaseVO
		{
			var d:D3ComBaseVO = createComBaseVO();
			d.data = ns.value;
			return d
		}
	}
}
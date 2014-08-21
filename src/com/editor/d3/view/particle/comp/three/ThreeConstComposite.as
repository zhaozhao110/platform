package com.editor.d3.view.particle.comp.three
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.d3.view.particle.comp.OneConstCompent;
	import com.sandy.asComponent.event.ASEvent;

	public class ThreeConstComposite extends UIVBox
	{
		public function ThreeConstComposite(c:ThreeConstComponent)
		{
			super();
			comp = c;
			create_init();
		}
		
		private var comp:ThreeConstComponent;
		public var isometricCB:UICheckBox;
		public var xOne:OneConstCompent;
		public var yOne:OneConstCompent
		public var zOne:OneConstCompent;
		
		private function create_init():void
		{
			enabledPercentSize = true
				
			isometricCB = new UICheckBox();
			isometricCB.label = "isometric"
			isometricCB.addEventListener(ASEvent.CHANGE,onChange);
			addChild(isometricCB);
			
			xOne = new OneConstCompent();
			xOne.label = "x:"
			xOne.save_f = saveObject;
			addChild(xOne);
			
			yOne = new OneConstCompent();
			yOne.label = "y:"
			yOne.save_f = saveObject;
			addChild(yOne);
			
			zOne = new OneConstCompent();
			zOne.label = "z:"
			zOne.save_f = saveObject;
			addChild(zOne);
		}
		
		override public function reset():void
		{
			isometricCB.selected = false;
			xOne.reset();
			yOne.reset();
			zOne.reset();
		}
		
		private function onChange(e:ASEvent=null):void
		{
			reflash2()
			saveObject()
		}
		
		private function reflash2():void
		{
			yOne.mouseChildren = !isometricCB.selected
			yOne.mouseEnabled = !isometricCB.selected
			zOne.mouseChildren = !isometricCB.selected
			zOne.mouseEnabled = !isometricCB.selected
		}
		
		public function setValue():void
		{
			xOne.selectedObject = comp.selectedObject;
			xOne.key = "x"
			yOne.selectedObject = comp.selectedObject;
			yOne.key = "y"
			zOne.selectedObject = comp.selectedObject;
			zOne.key = "z"
			
			if(comp.selectedObject.hasOwnProperty("data")){
				isometricCB.selected = comp.selectedObject.data.isometric;
			}else{
				isometricCB.selected =false;
			}
			reflash2()
			xOne.changeAnim();
			yOne.changeAnim();
			zOne.changeAnim();
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.id = "ThreeDCompositeValueSubParser"
			obj.data = {};
			obj.data.isometric = isometricCB.selected
			obj.data.x = xOne.getCurrObject()
			obj.data.y = yOne.getCurrObject()
			obj.data.z = zOne.getCurrObject();
			return obj;
		}
		
		public function saveObject():void
		{
			comp.selectedObject = getObject()
			comp.callReflash();
		}
	}
}
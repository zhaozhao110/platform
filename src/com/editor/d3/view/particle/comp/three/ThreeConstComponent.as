package com.editor.d3.view.particle.comp.three
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.vo.particle.SubPropObj;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.error.SandyError;

	public class ThreeConstComponent extends UIVBox
	{
		public function ThreeConstComponent()
		{
			super();
			create_init();
		}
		
		public var behType:String;
		public var constCell:ThreeConstCell;
		public var compositeCell:ThreeConstComposite;
		public var sphereCell:ThreeConstSphere;
		public var cylinderCell:ThreeConstCylinder;
		public var cb:UICombobox;
		public var vs:UIViewStack;
		public var lb:UILabel;
		
		override public function set label(value:String):void
		{
			super.label = value;
			if(lb!=null) lb.text = value;
		}
		
		private function create_init():void
		{
			percentWidth = 100;
			height = 250;
			
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			addChild(h);
			
			lb = new UILabel();
			lb.text = label;
			lb.width = 80
			h.addChild(lb);
			
			cb = new UICombobox();
			cb.height = 22;
			cb.width = 150;
			h.addChild(cb);
			cb.labelField = "label"
			cb.addEventListener(ASEvent.CHANGE,onCBChange);
			var a:Array = [];
			a.push({label:"ThreeDConst",data:"ThreeDConstValueSubParser"})
			a.push({label:"ThreeDComposite",data:"ThreeDCompositeValueSubParser"})
			a.push({label:"ThreeDSphere",data:"ThreeDSphereValueSubParser"})
			a.push({label:"ThreeDCylinder",data:"ThreeDCylinderValueSubParser"})
			cb.dataProvider = a;
			
			vs = new UIViewStack();
			vs.enabledPercentSize = true;
			addChild(vs);
			
			constCell = new ThreeConstCell(this);
			vs.addChild(constCell);
			
			compositeCell = new ThreeConstComposite(this);
			vs.addChild(compositeCell);
			
			sphereCell = new ThreeConstSphere(this);
			vs.addChild(sphereCell);
			
			cylinderCell = new ThreeConstCylinder(this);
			vs.addChild(cylinderCell);
			
			reset();
		}
		
		private function onCBChange(e:ASEvent):void
		{
			vs.selectedIndex = cb.selectedIndex;
			if(selectedObject == null) return ;
			if(cb.selectedIndex == 0){
				constCell.setValue();
			}else if(cb.selectedIndex == 1){
				compositeCell.setValue();
			}else if(cb.selectedIndex == 2){
				sphereCell.setValue();
			}else if(cb.selectedIndex == 3){
				cylinderCell.setValue();
			}
			callReflash()
		}
		
		public var isReseting:Boolean;
		
		override public function reset():void
		{
			isReseting = true
			cb.selectedIndex = 0;
			vs.selectedIndex = cb.selectedIndex;
			constCell.reset();
			compositeCell.reset();
			sphereCell.reset();
			cylinderCell.reset();
			isReseting = false;
		}
		
		public var selectedObject:Object;
		public var reflash_f:Function;
		
		public function callReflash():void
		{
			if(isReseting) return ;
			if(reflash_f!=null)reflash_f(selectedObject);
		}
				
		public function setValue(d:Object):void
		{
			if(!d.hasOwnProperty("data")){
				d.data = {};
			}
			selectedObject = d;
						
			var type:String = d.id;
			if(type == "ThreeDConstValueSubParser"){
				cb.setSelectIndex(0,false,true);
				constCell.setValue();
			}else if(type == "ThreeDCompositeValueSubParser"){
				cb.setSelectIndex(1,false,true);
				compositeCell.setValue();
			}else if(type == "ThreeDSphereValueSubParser"){
				cb.setSelectIndex(2,false,true);
				sphereCell.setValue();
			}else if(type == "ThreeDCylinderValueSubParser"){
				cb.setSelectIndex(3,false,true);
				cylinderCell.setValue();
			}else{
				reset();
			}
			vs.selectedIndex = cb.selectedIndex;
		}
		
		public function getObject():Object
		{
			if(cb.selectedIndex == 0){
				return constCell.getObject();
			}else if(cb.selectedIndex == 1){
				return compositeCell.getObject();
			}else if(cb.selectedIndex == 2){
				return sphereCell.getObject()
			}else if(cb.selectedIndex == 3){
				return cylinderCell.getObject()
			}
			return null;
		}
		
		
		
	}
}
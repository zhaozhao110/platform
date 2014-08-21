package com.editor.d3.view.particle.comp
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UINumericStepper;
	import com.editor.component.controls.UITextInput;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.vo.particle.ParticleAnimationObj;
	import com.editor.d3.vo.particle.SubPropObj;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class OneConstCompent extends UIVBox
	{
		public function OneConstCompent()
		{
			super();
			create_init();
		}
		
		override public function set label(value:String):void
		{
			super.label = value;
			if(lb!=null) lb.text = value;
		}
		
		public var lb:UILabel;
		public var cb:UICombobox;
		public var vs:UIViewStack;
		public var ns1:UINumericStepper;
		public var ns2:UINumericStepper;
		public var ns3:UINumericStepper;
		public var editBtn:UIButton;
		public var lua_ti:UITextInput;
				
		private function create_init():void
		{
			height = 50;
			percentWidth = 100;
			
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			addChild(h);
			
			lb = new UILabel();
			lb.text = label;
			lb.width = 80
			h.addChild(lb);
			
			/**
			 * Constant : 不变的：这个值将不会随时间变化，也不会显示到曲线编辑器中。
			 * Random : 常量中的随机值：属性值将随机在两个常量中取得
			 * Curve : 曲线：值随时间沿一条曲线变化，在曲线编辑器中显示
			 */ 
			
			cb = new UICombobox();
			cb.width = 150;
			cb.height = 22;
			h.addChild(cb);
			cb.dataProvider = ["OneDConst","OneDRandom","OneDCurve","OneDLua"]
			cb.addEventListener(ASEvent.CHANGE,onCB);
		
			vs = new UIViewStack();
			vs.enabledPercentSize = true;
			addChild(vs);
			
			//OneDConst
			h = new UIHBox();
			h.paddingLeft = lb.width;
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			vs.addChild(h);
			
			ns1 = new UINumericStepper();
			ns1.editable = true;
			ns1.enterKeyDown_proxy = enterKeyDown1
			ns1.addEventListener(ASEvent.CHANGE, onValueChange1)
			ns1.width = 100;
			ns1.minimum = -1000000
			ns1.maximum = 1000000;
			ns1.stepSize = .1;
			h.addChild(ns1);
			
			//OneDRandom
			h = new UIHBox();
			h.paddingLeft = lb.width;
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			vs.addChild(h);
			
			var lb2:UILabel = new UILabel();
			lb2.text = "min"
			lb2.width = 25;
			h.addChild(lb2);
			
			ns2 = new UINumericStepper();
			ns2.enterKeyDown_proxy = enterKeyDown2
			ns2.addEventListener(ASEvent.CHANGE, onValueChange2)
			ns2.width = 60;
			ns2.minimum = -1000000
			ns2.maximum = 1000000;
			ns2.stepSize = .1;
			h.addChild(ns2);
			
			lb2 = new UILabel();
			lb2.text = "max"
			lb2.width = 25;
			h.addChild(lb2);
			
			ns3 = new UINumericStepper();
			ns3.enterKeyDown_proxy = enterKeyDown3
			ns3.addEventListener(ASEvent.CHANGE, onValueChange3)
			ns3.width = 60;
			ns3.minimum = -1000000
			ns3.maximum = 1000000;
			ns3.stepSize = .1;
			h.addChild(ns3);
			
			//OneDCurve
			h = new UIHBox();
			h.paddingLeft = lb.width;
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			vs.addChild(h);
			
			editBtn = new UIButton();
			editBtn.label = "编辑"
			editBtn.addEventListener(MouseEvent.CLICK , onEditClick);
			h.addChild(editBtn);
			
			editBtnLB = new UILabel();
			h.addChild(editBtnLB);
			
			//OneDLua
			h = new UIHBox();
			h.paddingLeft = lb.width;
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			vs.addChild(h);
			
			var lb2:UILabel = new UILabel();
			lb2.text = "var name:"
			lb2.width = 70;
			h.addChild(lb2);
			
			lua_ti = new UITextInput();
			lua_ti.width = 100;
			lua_ti.enterKeyDown_proxy = saveCurr
			h.addChild(lua_ti);
			
			reset();
		}
		
		private var editBtnLB:UILabel;
		
		private function onEditClick(e:MouseEvent):void
		{
			get_App3DMainUIContainerMediator().showCurveEditor(selectedObject.data[key],saveObject3);
		}
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
		private var _maximum:Number;
		public function get maximum():Number
		{
			return _maximum;
		}
		public function set maximum(value:Number):void
		{
			_maximum = value;
			ns1.maximum = value;
			ns2.maximum = value;
			ns3.maximum = value;
		}
		
		private var _minimum:Number=0;
		public function get minimum():Number
		{
			return _minimum;
		}
		public function set minimum(value:Number):void
		{
			_minimum = value;
			ns1.minimum = _minimum;
			ns2.minimum = _minimum;
			ns3.minimum = _minimum;
		}
		
		public var selectedObject:Object;
		public var key:String = "selectedValue"
		public var before_f:Function;
		public var save_f:Function;
		
		private function onCB(e:ASEvent):void
		{
			vs.selectedIndex = cb.selectedIndex;
			saveCurr()
			callSaveF()
		}
		
		public function changeAnim():void
		{
			//isReseting = true
			if(selectedObject == null){
				reset()
				return ;
			}
			var obj:Object = selectedObject.data[key];
			if(obj!=null){
				if(StringTWLUtil.isNumber(String(obj))){
					reset();
				}else{
					if(obj.id == "OneDConstValueSubParser"){
						cb.setSelectIndex(0,false);
						ns1.value = obj.data.value;
					}else if(obj.id == "OneDRandomVauleSubParser"){
						cb.setSelectIndex(1,false);
						ns2.value = obj.data.min;
						ns3.value = obj.data.max;
					}else if(obj.id == "OneDCurveValueSubParser"){
						editBtnLB.data = obj;
						cb.setSelectIndex(2,false);
						editBtnLB.text = obj.info;
					}else if(obj.id == "LuaExtractSubParser"){
						cb.setSelectIndex(3,false);
						lua_ti.text = obj.data.value;						
					}else{
						reset();
					}
				}
			}else{
				reset();
			}
			vs.selectedIndex = cb.selectedIndex;
			//isReseting = false;
		}
		
		public var isReseting:Boolean;
		
		override public function reset():void
		{
			isReseting = true
			editBtnLB.data = null;
			cb.selectedIndex = 0;
			vs.selectedIndex = 0;
			ns1.value = 1;
			ns2.value = 0;
			ns3.value = 1;
			lua_ti.text = "";
			isReseting = false
		}
		
		private function saveObject1():void
		{
			if(isReseting) return ;
			if(selectedObject == null) return ;
			if(before_f!=null) before_f();
			selectedObject.data[key] = getObject1();
		}
		
		private function saveObject2():void
		{
			if(isReseting) return ;
			if(selectedObject == null) return ;
			selectedObject.data[key] = getObject2();
		}
		
		private function saveObject3(obj:Object):void
		{
			if(obj == null) return ;
			if(isReseting) return ;
			if(selectedObject == null) return ;
			editBtnLB.data = obj;
			editBtnLB.text = obj.info;
			selectedObject.data[key] = obj
			callSaveF()
		}
		
		private function saveObject4():void
		{
			if(isReseting) return ;
			if(selectedObject == null) return ;
			selectedObject.data[key] = getObject4();
			callSaveF()
		}
		
		public function saveCurr():void
		{
			if(cb.selectedIndex == 0){
				saveObject1()
			}else if(cb.selectedIndex == 1){
				saveObject2()
			}else if(cb.selectedIndex == 3){
				saveObject4();
			}
		}
		
		public function getCurrObject():Object
		{
			if(cb.selectedIndex == 0){
				return getObject1();
			}else if(cb.selectedIndex == 1){
				return getObject2()
			}else if(cb.selectedIndex == 2){
				return editBtnLB.data ;
			}else if(cb.selectedIndex == 3){
				return getObject4()
			}
			return null
		}
		
		private function getObject1():Object
		{
			var obj:Object = {};
			obj.id = "OneDConstValueSubParser"
			obj.data = {};
			obj.data.value = ns1.value;
			return obj;
		}
		
		private function getObject2():Object
		{
			var obj:Object = {};
			obj.id = "OneDRandomVauleSubParser"
			obj.data = {};
			obj.data.min = ns2.value;
			obj.data.max = ns3.value;
			return obj;
		}
		
		private function getObject4():Object
		{
			var obj:Object = {};
			obj.id = "LuaExtractSubParser"
			obj.data = {};
			obj.data.value = lua_ti.text;
			return obj;
		}
		
		private function enterKeyDown1():void
		{
			saveObject1()
			callSaveF()
		}
		private function enterKeyDown2():void
		{
			saveObject2()
			callSaveF()
		}
		private function enterKeyDown3():void
		{
			saveObject2()
			callSaveF()
		}
		
		private function onValueChange1(e:ASEvent):void
		{
			saveObject1()
			callSaveF()
		}
		private function onValueChange2(e:ASEvent):void
		{
			saveObject2()	
			callSaveF()
		}
		private function onValueChange3(e:ASEvent):void
		{
			saveObject2()
			callSaveF()
		}
		
		private function callSaveF():void
		{
			if(isReseting) return ;
			if(save_f!=null) save_f();
		}
		
	}
}
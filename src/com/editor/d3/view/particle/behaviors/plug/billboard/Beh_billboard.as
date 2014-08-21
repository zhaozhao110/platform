package com.editor.d3.view.particle.behaviors.plug.billboard
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UIRadioButton;
	import com.editor.component.controls.UIRadioButtonGroup;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.sandy.asComponent.event.ASEvent;

	public class Beh_billboard extends ParticleAttriPlugBase
	{
		public function Beh_billboard()
		{
			super();
		}
		
		public var userCB:UICheckBox;
		public var xRadio:UIRadioButton;
		public var yRadio:UIRadioButton;
		public var zRadio:UIRadioButton;
		public var loc_radio:UIRadioButtonGroup;
		public var h2:UIHBox
		
		override protected function create_init():void
		{
			super.create_init();
			
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			addChild(h);
			
			userCB = new UICheckBox();
			userCB.label = "uses axis"
			userCB.addEventListener(ASEvent.CHANGE,onCBChange);
			h.addChild(userCB);
						
			h2 = new UIHBox();
			h2.height = 25;
			h2.percentWidth =100;
			h2.horizontalGap = 10
			h2.verticalAlignMiddle = true;
			addChild(h2);
			
			loc_radio = new UIRadioButtonGroup();
			loc_radio.addEventListener(ASEvent.CHANGE,onRadioChange);
			
			xRadio = new UIRadioButton();
			xRadio.group = loc_radio;
			xRadio.label = "x axis"
			h2.addChild(xRadio);
			
			yRadio = new UIRadioButton();
			yRadio.group = loc_radio;
			yRadio.label = "y axis"
			h2.addChild(yRadio);
			
			zRadio = new UIRadioButton();
			zRadio.group = loc_radio;
			zRadio.label = "z axis"
			h2.addChild(zRadio);
			
			reset()
		}
		
		private function onRadioChange(e:ASEvent):void
		{
			saveBeh();
		}
		
		private function onCBChange(e:ASEvent):void
		{
			h2.mouseChildren = userCB.selected;
			h2.mouseEnabled = userCB.selected;
			saveBeh();
		}
		
		override public function reset():void
		{
			isReseting = true
			userCB.selected = true;
			xRadio.selected = true;
			isReseting = false
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("usesAxis",userCB.selected);
			if(userCB.selected){
				plusObj.putAttri("axisZ",zRadio.selected==true?1:0);
				plusObj.putAttri("axisY",yRadio.selected==true?1:0);
				plusObj.putAttri("axisX",xRadio.selected==true?1:0);
			}
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim()
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			if(plusObj.getAttri("usesAxis") == null){
				reset();
				saveObject();
			}
			
			userCB.selected = plusObj.getAttri("usesAxis");
			xRadio.selected = plusObj.getAttri("axisX")==1?true:false;
			yRadio.selected = plusObj.getAttri("axisY")==1?true:false;
			zRadio.selected = plusObj.getAttri("axisZ")==1?true:false;
		}
		
		
	}
}
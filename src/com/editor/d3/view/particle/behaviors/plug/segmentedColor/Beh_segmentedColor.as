package com.editor.d3.view.particle.behaviors.plug.segmentedColor
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.behaviors.plug.segmentedColor.cell.Beh_segmentedColor_middle;
	import com.editor.d3.view.particle.behaviors.plug.segmentedColor.cell.Beh_segmentedColor_start;
	import com.sandy.asComponent.event.ASEvent;

	public class Beh_segmentedColor extends ParticleAttriPlugBase
	{
		public function Beh_segmentedColor()
		{
			super();
		}
		
		public var tabBar:UITabBarNav;
		public var startV:Beh_segmentedColor_start;
		public var middle1V:Beh_segmentedColor_middle;
		public var middle2V:Beh_segmentedColor_middle;
		public var middle3V:Beh_segmentedColor_middle;
		public var middle4V:Beh_segmentedColor_middle;
		public var endV:Beh_segmentedColor_start;
		
		override protected function create_init():void
		{
			super.create_init()
			height = 350;
			
			tabBar = new UITabBarNav();
			tabBar.enabledPercentSize = true;
			addChild(tabBar);
			
			startV = new Beh_segmentedColor_start();
			startV.label = "start"
			tabBar.addChild(startV);
			startV.beh_ui =this;
			startV.type = "start"
			
			middle1V = new Beh_segmentedColor_middle();
			middle1V.label = "mid1"
			tabBar.addChild(middle1V);
			middle1V.beh_ui = this;
			middle1V.type = "middl1"
			
			middle2V = new Beh_segmentedColor_middle();
			middle2V.label = "mid2"
			tabBar.addChild(middle2V);
			middle2V.beh_ui = this;
			middle2V.type = "middl2"
			
			middle3V = new Beh_segmentedColor_middle();
			middle3V.label = "mid3"
			tabBar.addChild(middle3V);
			middle3V.beh_ui = this
			middle2V.type = "middl3"
			
			middle4V = new Beh_segmentedColor_middle();
			middle4V.label = "mid4"
			tabBar.addChild(middle4V);
			middle4V.beh_ui = this;
			middle4V.type = "middl4"
			
			endV = new Beh_segmentedColor_start();
			endV.label = "end"
			tabBar.addChild(endV);
			endV.beh_ui = this;
			endV.type = "end"
			
			tabBar.selectedIndex = 0;
			reset()
		}
		
		override public function reset():void
		{
			isReseting = true;
			startV.reset();
			middle1V.reset();
			middle2V.reset();
			middle3V.reset();
			middle4V.reset();
			endV.reset();
			isReseting = false
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("usesMultiplier",true);
			plusObj.putAttri("usesOffset",true);
			plusObj.putAttri("startColor",startV.getObject());
			plusObj.putAttri("endColor",endV.getObject());
			var a:Array = [];
			if(middle1V.enabledCB.selected){
				a.push(middle1V.getObject());
			}
			if(middle2V.enabledCB.selected){
				a.push(middle2V.getObject());
			}
			if(middle3V.enabledCB.selected){
				a.push(middle3V.getObject());
			}
			if(middle4V.enabledCB.selected){
				a.push(middle4V.getObject());
			}
			plusObj.putAttri("segmentPoints",a);
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim();
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			if(plusObj.getAttri("usesMultiplier") == null){
				reset();
				saveObject()
			}
			
			startV.changeAnim(plusObj)
			endV.changeAnim(plusObj)
			
			middle1V.enabledCB.selected = false;
			middle2V.enabledCB.selected = false;
			middle3V.enabledCB.selected = false;
			middle4V.enabledCB.selected = false;
			
			var a:Array = plusObj.getAttri("segmentPoints") as Array;
			if(a!=null){
				for(var i:int=0;i<a.length;i++){
					if(i == 0){
						middle1V.changeAnim(a[i]);
					}else if(i == 1){
						middle2V.changeAnim(a[i]);
					}else if(i == 2){
						middle3V.changeAnim(a[i]);
					}else if(i == 3){
						middle4V.changeAnim(a[i]);
					}
				}
			}
		}
	}
}
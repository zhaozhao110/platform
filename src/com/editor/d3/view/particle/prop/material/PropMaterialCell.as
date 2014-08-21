package com.editor.d3.view.particle.prop.material
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.vo.particle.SubPropObj;
	import com.sandy.asComponent.event.ASEvent;

	public class PropMaterialCell extends ParticleAttriCellBase
	{
		public function PropMaterialCell()
		{
			super();
			
		}
		
		public var cb:UICombobox;
		public var vs:UIViewStack;
		public var colorMater:PropColorMaterial;
		public var textureMater:PropTextureMater;
		
		override protected function create_init():void
		{
			super.create_init();
			paddingTop = 10;
			
			var h:UIHBox = new UIHBox();
			h.verticalAlignMiddle = true;
			h.height = 25;
			h.percentWidth = 100;
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "material:"
			lb.width = 70;
			h.addChild(lb);
			
			cb = new UICombobox();
			cb.height = 22;
			cb.width = 150;
			h.addChild(cb);
			cb.labelField = "label"
			var a:Array = [];
			a.push({label:"ColorMaterial",data:"ColorMaterialSubParser"})
			a.push({label:"TextureMaterial",data:"TextureMaterialSubParser"})
			cb.dataProvider = a;
			cb.addEventListener(ASEvent.CHANGE,onCBChange);
			
			vs = new UIViewStack();
			vs.enabledPercentSize = true;
			addChild(vs);
			
			colorMater = new PropColorMaterial();
			colorMater.cell = this;
			vs.addChild(colorMater);
			
			textureMater = new PropTextureMater();
			textureMater.cell = this;
			vs.addChild(textureMater);
			
			cb.setSelectIndex(0,false);
			vs.setSelectIndex(0,false);
		}
		
		private function onCBChange(e:ASEvent):void
		{
			vs.selectedIndex = cb.selectedIndex;
			if(cb.selectedIndex == 0){
				colorMater.saveObject();
			}else if(cb.selectedIndex == 1){
				textureMater.saveObject();
			}
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			isReseting = true
			colorMater.changeAnim();
			textureMater.changeAnim();
			
			var obj:SubPropObj = currAnimationData.data.material;
			if(obj.id == "ColorMaterialSubParser"){
				cb.setSelectIndex(0,false);
			}else if(obj.id == "TextureMaterialSubParser"){
				cb.setSelectIndex(1,false);
			}
			vs.selectedIndex = cb.selectedIndex;
			isReseting = false;
		}
		
		public var isReseting:Boolean;
		
		override public function changeComp(c:D3ObjectParticle):void
		{
			super.changeComp(c);
			colorMater.changeComp(c);
			textureMater.changeComp(c);
		}
		
	}
}
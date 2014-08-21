package com.editor.d3.view.particle.prop.geometry
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.view.particle.comp.OneConstCompent;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.particle.SubPropObj;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.ColorUtils;

	public class PropGeometryUV extends ParticleAttriCellBase
	{
		public function PropGeometryUV()
		{
			super();
		}
		
		protected var enabledCB:UICheckBox;
		public var oneConstComp:OneConstCompent
		
		override protected function create_init():void
		{
			padding = 5;
			styleName = "uicanvas"
			height = 150;	
			percentWidth =100;
			
			enabledCB = new UICheckBox();
			enabledCB.label = "--- uv transform ---"
			enabledCB.height = 22;
			enabledCB.bold = true;
			enabledCB.color = ColorUtils.blue;
			enabledCB.addEventListener(ASEvent.CHANGE,onCBChange);
			addChild(enabledCB);
			
			var a:Array = [];
			var d:D3ComAttriItemVO = new D3ComAttriItemVO();
			d.key = "rows"
			d.value = "numericStepper"
			d.defaultValue = 2;
			a.push(d);
			
			d = new D3ComAttriItemVO();
			d.key = "columns"
			d.value = "numericStepper"
			d.defaultValue = 3;
			a.push(d);
			
			createCompByGroup(a);
			
			oneConstComp = new OneConstCompent();
			oneConstComp.label = "index:"
			oneConstComp.before_f = oneConstCompBefore;
			addChild(oneConstComp);
			
			enabledAllAttri(false);
		}
		
		private function oneConstCompBefore():void
		{
			createUV();
			oneConstComp.selectedObject = currAnimationData.data.geometry.uvTransformValue
		}
		
		override protected function enabledAllAttri(v:Boolean):void
		{
			super.enabledAllAttri(v);
			oneConstComp.mouseChildren = v;
			oneConstComp.mouseEnabled = v;
		}
		
		private function onCBChange(e:ASEvent):void
		{
			enabledAllAttri(enabledCB.selected);
			if(currAnimationData.data.geometry.uvTransformValue!=null){
				currAnimationData.data.geometry.uvTransformValue.enabled = enabledCB.selected;
			}
			if(!enabledCB.selected){
				//currAnimationData.data.geometry.uvTransformValue = null;
			}else{
				createUV()
				oneConstComp.saveCurr();
			}
		}
		
		override protected function getCompValue(d:D3ComBase):*
		{
			var k:String = d.key;
			if(k == "rows"){
				if(currAnimationData.data.geometry.uvTransformValue == null) return null;
				return currAnimationData.data.geometry.uvTransformValue.getAttri("numRows");
			}else if(k == "columns"){
				if(currAnimationData.data.geometry.uvTransformValue == null) return null;
				return currAnimationData.data.geometry.uvTransformValue.getAttri("numColumns");
			}
			return null;
		}
		
		override protected function comReflash(b:D3ComBase):void
		{
			var d:D3ComBaseVO = b.getValue();
			var k:String = b.key;
			if(k == "rows"){
				createUV()
				currAnimationData.data.geometry.uvTransformValue.putAttri("numRows",d.data);
			}else if(k == "columns"){
				createUV()
				currAnimationData.data.geometry.uvTransformValue.putAttri("numColumns",d.data);
			}
		}
		
		private function createUV():void
		{
			currAnimationData.data.geometry.createUVtransform(getAttri("rows").getValue().data,getAttri("columns").getValue().data);
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			oneConstComp.selectedObject = currAnimationData.data.geometry.uvTransformValue
			oneConstComp.changeAnim();
			
			if(currAnimationData.data.geometry.uvTransformValue!=null){
				enabledCB.setSelect(currAnimationData.data.geometry.uvTransformValue.enabled,false);
			}else{
				enabledCB.setSelect(false,false);
			}
			
			enabledAllAttri(enabledCB.selected);
		}
		
		
	}
}
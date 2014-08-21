package com.editor.d3.view.particle.prop.geometry
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.view.particle.prop.geometry.model.PropModelEditor;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.ColorUtils;

	public class PropGeometryModel extends ParticleAttriCellBase
	{
		public function PropGeometryModel()
		{
			super();
		}
		
		private var enabledCB:UICheckBox;
		public var editor:PropModelEditor;
		
		override protected function create_init():void
		{
			padding = 5;
			styleName = "uicanvas"
			//percentHeight = 100;
			percentWidth =100;
			
			enabledCB = new UICheckBox();
			enabledCB.label = "--- model transform ---"
			enabledCB.height = 22;
			enabledCB.bold = true;
			enabledCB.color = ColorUtils.blue;
			enabledCB.addEventListener(ASEvent.CHANGE,onCBChange);
			addChild(enabledCB);
			
			editor = new PropModelEditor();
			editor.mouseChildren = false;
			editor.mouseEnabled = false;
			addChild(editor);
		}
		
		private function onCBChange(e:ASEvent):void
		{
			editor.mouseChildren = enabledCB.selected;
			editor.mouseEnabled = enabledCB.selected;
			if(currAnimationData.data.geometry.vertexTransform!=null){
				currAnimationData.data.geometry.vertexTransform.enabled = enabledCB.selected;
			}
			if(!enabledCB.selected){
				
			}else{
				
			}
		}
		
		override public function changeAnim():void
		{
			super.changeAnim()
			if(currAnimationData.data.geometry.vertexTransform!=null){
				enabledCB.setSelect(currAnimationData.data.geometry.vertexTransform.enabled,false);
			}else{
				enabledCB.setSelect(false,false);
			}
			editor.mouseChildren = enabledCB.selected;
			editor.mouseEnabled = enabledCB.selected;
			editor.changeAnim();
		}
		
		override public function changeComp(c:D3ObjectParticle):void
		{
			super.changeComp(c);
			editor.changeComp(c);
		}
	}
}
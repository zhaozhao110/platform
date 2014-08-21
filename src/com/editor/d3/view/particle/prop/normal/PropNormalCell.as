package com.editor.d3.view.particle.prop.normal
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.vo.particle.SubPropObj;
	import com.editor.d3.vo.particle.sub.InstanceDataObj;
	import com.editor.d3.vo.particle.sub.InstancePropertyObj;
	import com.sandy.math.HashMap;

	public class PropNormalCell extends ParticleAttriCellBase
	{
		public function PropNormalCell()
		{
			super();
			
		}
		
		override public function get attriId():String
		{
			return "InstancePropertySubParser"
		}
		
		override protected function create_init():void
		{
			super.create_init();
			
			var lb:UILabel = new UILabel();
			addChild(lb);
			lb.text = " --- normal --- ";
			lb.bold = true;	
			
			var a:Array = D3ComponentProxy.getInstance().particle_attri_ls.getGroup(1);
			createCompByGroup(a);
		}
		
		override protected function comReflash(b:D3ComBase):void
		{
			var d:D3ComBaseVO = b.getValue();
			var k:String = b.key;
			if(k == "bounds" || k == "shareAnimationGeometry"){
				if(currAnimationData.data == null){
					currAnimationData.data = new InstanceDataObj();
				}
				currAnimationData.data[k] = d.data; 
				return ;
			}
			if(currAnimationData.property == null){
				currAnimationData.property = new InstancePropertyObj();
			}
			currAnimationData.property.putAttri(b.key,d.data);
		}
		
		override protected function getCompValue(d:D3ComBase):*
		{
			var k:String = d.key;
			if(k == "bounds" || k == "shareAnimationGeometry"){
				if(currAnimationData.data == null) return null;
				return currAnimationData.data[k];
			}
			if(currAnimationData.property == null) return null;
			return currAnimationData.property.getAttri(k);
		}
		
	}
}
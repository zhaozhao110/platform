package com.editor.d3.view.particle.prop.geometry
{
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.view.particle.anim.ParticleAttri_anim;
	import com.editor.d3.vo.particle.sub.GeometryObj;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class PropGeometryCell extends ParticleAttriCellBase
	{
		public function PropGeometryCell()
		{
			super();
			
		}
		
		public var shapeCont:PropGeometryShape;
		public var uv:PropGeometryUV;
		public var model:PropGeometryModel
		
		override protected function create_init():void
		{
			super.create_init();
			paddingTop  =10;
			
			verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
				
			var a:Array = D3ComponentProxy.getInstance().particle_attri_ls.getGroup(2);
			createCompByGroup(a);
			
			shapeCont = new PropGeometryShape();
			addChild(shapeCont);	
			
			uv = new PropGeometryUV();
			addChild(uv);
			
			model = new PropGeometryModel();
			addChild(model);
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			shapeCont.changeAnim();
			uv.changeAnim();
			model.changeAnim()
		}
		
		override public function changeComp(c:D3ObjectParticle):void
		{
			super.changeComp(c);
			shapeCont.changeComp(c);
			uv.changeComp(c);
			model.changeComp(c);
		}
		
		override protected function getCompValue(d:D3ComBase):*
		{
			var k:String = d.key;
			if(k == "particle num"){
				return currAnimationData.data.geometry.assembler.getAttri("num");
			}
		}
		
		override protected function comReflash(b:D3ComBase):void
		{
			var d:D3ComBaseVO = b.getValue();
			var k:String = b.key;
			if(k == "particle num"){
				currAnimationData.data.geometry.assembler.putAttri("num",d.data);
				ParticleAttri_anim.instance.reflashAnimVBox();
			}
		}
		
		
	}
}
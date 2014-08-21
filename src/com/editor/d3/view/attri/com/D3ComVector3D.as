package com.editor.d3.view.attri.com
{
	import com.editor.component.controls.UITextInput;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.geom.Vector3D;

	public class D3ComVector3D extends D3ComBase
	{
		public function D3ComVector3D()
		{
			super();
		}
		
		private var x_ti:UITextInput;
		private var y_ti:UITextInput;
		private var z_ti:UITextInput;
		
		override protected function create_init():void
		{
			super.create_init();
			
			x_ti = new UITextInput();
			x_ti.height = 20;
			x_ti.width = 45;
			x_ti.enterKeyDown_proxy = enterKeyDownX;
			addChild(x_ti);
			
			y_ti = new UITextInput();
			y_ti.height = 20;
			y_ti.width = 45;
			y_ti.enterKeyDown_proxy = enterKeyDownY;
			addChild(y_ti);
			
			z_ti = new UITextInput();
			z_ti.height = 20;
			z_ti.width = 45;
			z_ti.enterKeyDown_proxy = enterKeyDownZ;
			addChild(z_ti);
		}
		
		private function enterKeyDownX():void
		{
			callUIRender();
		}
		
		private function enterKeyDownY():void
		{
			callUIRender();
		}
		
		private function enterKeyDownZ():void
		{
			callUIRender();
		}
		
		override public function setValue():void
		{
			super.setValue();
			
			var v:Vector3D = getCompValue() as Vector3D;
			if(v != null){
				x_ti.text = v.x.toString();
				y_ti.text = v.y.toString();
				z_ti.text = v.z.toString();
			}else{
				if(attriId == 114){
					if(comp.configData.checkAttri("x")){
						x_ti.text = comp.configData.getAttri("x");
						y_ti.text = comp.configData.getAttri("y");
						z_ti.text = comp.configData.getAttri("z");
						return ;
					}
				}
				else if(attriId == 115){
					if(comp.configData.checkAttri("rotationX")){
						x_ti.text = comp.configData.getAttri("rotationX");
						y_ti.text = comp.configData.getAttri("rotationY");
						z_ti.text = comp.configData.getAttri("rotationZ");
						return ;
					}
				}else if(attriId == 116){
					if(comp.configData.checkAttri("scaleX")){
						x_ti.text = comp.configData.getAttri("scaleX");
						y_ti.text = comp.configData.getAttri("scaleY");
						z_ti.text = comp.configData.getAttri("scaleZ");
						return ;
					}
				}
				
				x_ti.text = "";
				y_ti.text = "";
				z_ti.text = "";
			}
		}
		
		override public function getValue():D3ComBaseVO
		{
			var d:D3ComBaseVO = createComBaseVO();
			var v:Vector3D = new Vector3D();
			if(StringTWLUtil.isWhitespace(x_ti.text)){
				v.x = NaN;
			}else{
				v.x = Number(x_ti.text)
			}
			if(StringTWLUtil.isWhitespace(y_ti.text)){
				v.y = NaN;
			}else{
				v.y = Number(y_ti.text)
			}
			if(StringTWLUtil.isWhitespace(z_ti.text)){
				v.z = NaN;
			}else{
				v.z = Number(z_ti.text)
			}
			d.data = v
			return d;
		}
		
		
		
		
	}
}

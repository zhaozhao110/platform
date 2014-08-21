package com.editor.d3.view.attri.com
{
	import com.editor.component.controls.UIButton;
	import com.editor.d3.cache.D3ComponentConst;
	
	import flash.events.MouseEvent;

	public class D3ComButton extends D3ComBase
	{
		public function D3ComButton()
		{
			super();
		}
		
		private var btn:UIButton;
		
		override protected function create_init():void
		{
			super.create_init();
			
			btn = new UIButton();
			btn.addEventListener(MouseEvent.CLICK,onClickHandle)
			addChild(btn);
		}
		
		private function onClickHandle(e:MouseEvent):void
		{
			if(group.id == 3){
				//material
				if(attriId == 39){
					//刷新缓存
					comp.proccess.mapItem.setMaterial();
					return ;
				}
				if(attriId == 44){
					comp.getD3ObjProccess().editMaterial();
					return ;
				}
			}
			
			callUIRender();
		}
		
		override public function setValue():void
		{
			super.setValue();
			
			btn.label = item.key;
			
			if(attriId == 34){
				if(target!=null){
					if(target.target.comp.group == D3ComponentConst.comp_group9){
						btn.label = "解除绑定"
					}					
				}
			}
		}
		
	}
}
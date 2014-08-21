package com.editor.d3.view.attri.com
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.d3.object.D3ObjectLight;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;

	public class D3ComBoolean extends D3ComBase
	{
		public function D3ComBoolean()
		{
			super();
		}
		
		private var cb:UICheckBox;
		
		override protected function create_init():void
		{
			super.create_init();
			
			cb = new UICheckBox();
			cb.label = "false";
			cb.width = 140
			cb.selected = false
			cb.addEventListener(ASEvent.CHANGE,onChangeHandle);
			addChild(cb);
		}
		
		private function onChangeHandle(e:ASEvent):void
		{
			if(cb.selected){
				cb.label = "true"
			}else{
				cb.label = "false"
			}
			if(item.getExpand3(0) == "1") return ;
			callUIRender();
		}
		
		override public function getValue():D3ComBaseVO
		{
			var d:D3ComBaseVO = createComBaseVO();
			d.data = cb.selected;
			return d
		}
		
		override public function setValue():void
		{
			super.setValue();
			
			if(getCompValue() == null){
				cb.setSelect(item.defaultValue=="true"?true:false,false);
			}else{
				cb.setSelect(getCompValue(),false);
			}
			
			if(key == "visible"){
				if(comp.proccess.mapItem!=null){
					if(comp.proccess.mapItem.getObject()!=null){
						cb.setSelect(comp.proccess.mapItem.getObject().visible,false);
					}
				}
			}
			
			if(cb.selected){
				cb.label = "true"
			}else{
				cb.label = "false"
			}
			
			cb.mouseChildren = true;
			cb.mouseEnabled = true
			
			if(item.getExpand3(0) == "1"){
				if(item.id == 33){
					//use cpu
					if(comp.getD3ObjProccess()!=null&&comp.getD3ObjProccess().mapItem!=null){
						//cb.selected = comp.getD3ObjProccess().mapItem.usesCPU;
					}
				}
				cb.mouseChildren = false;
				cb.mouseEnabled = false;
			}
			
			if(attriId == 6){
				//castsShadows
				if(comp is D3ObjectLight){
					cb.mouseChildren = false;
					cb.mouseEnabled = false;
				}
			}
			
			if(comp.isGlobal){
				cb.mouseChildren = false;
				cb.mouseEnabled = false;
			}
		}
		
	}
}
package com.editor.d3.view.attri.com
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UICombobox;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3ObjectCamera;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.process.D3ProccessMaterial;
	import com.editor.d3.vo.method.D3MethodItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class D3ComComboBox extends D3ComBase
	{
		public function D3ComComboBox()
		{
			super();
		}
		
		private var cb:UICombobox;
		private var editBtn:UIAssetsSymbol;
		
		override protected function create_init():void
		{
			super.create_init();
			
			cb = new UICombobox();
			cb.percentWidth = 100;
			cb.height = 23;
			cb.addEventListener(ASEvent.CHANGE,onChangeHandle);
			addChild(cb);
			
			editBtn = new UIAssetsSymbol();
			editBtn.source = "edit2_a"
			editBtn.width = 16;
			editBtn.height = 16;
			editBtn.toolTip = "编辑"
			editBtn.buttonMode = true;
			editBtn.addEventListener(MouseEvent.CLICK , onEditHandle);
			editBtn.visible = false;
			addChild(editBtn);
		}
		
		private function onChangeHandle(e:ASEvent):void
		{
			callUIRender()
		}
		
		override public function setValue():void
		{
			super.setValue();
			
			cb.dataProvider = null;
			editBtn.visible = false;
			
			if(item.expand == "method"){
				cb.labelField = "name"
				var a:Array = [];
				if(item.defaultValue == "camera"){
					a = D3ComponentProxy.getInstance().method_ls.camera_ls;
				}else{
					a.push(new D3MethodItemVO())
					a = a.concat(D3ComponentProxy.getInstance().method_ls.method_ls);
				}
				cb.dataProvider = a;
				editBtn.visible = true;
				
				var v:* = getCompValue();
				if(v!=null && v is D3ObjectMethod){
					a = cb.dataProvider;
					for(var i:int=0;i<a.length;i++){
						if(D3MethodItemVO(a[i]).name == v.name){
							cb.setSelectIndex(i,false);
							break;
						}
					}
				}
				return ;
			}
			
			if(!StringTWLUtil.isWhitespace(item.expand)){
				cb.dataProvider = item.expand.split(",");
				cb.setSelectIndex(0,false);
			}
		}
		
		private function onEditHandle(e:MouseEvent):void
		{
			var d:* = cb.selectedItem;
			if(d is D3MethodItemVO){
				if(d.id > 0){
					if(comp is D3ObjectMaterial || comp is D3ObjectCamera){
						comp.proccess.selectMethod(key)
					}
				}
			}
		}
		
		override public function getValue():D3ComBaseVO
		{
			var d:D3ComBaseVO = new D3ComBaseVO();
			d.data = cb.selectedItem;
			return d;
		}
		
		
	}
}
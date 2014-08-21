package com.editor.d3.view.attri.cell
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.object.D3ObjectCamera;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.process.D3ProccessCamera;
	import com.editor.d3.vo.method.D3MethodItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class D3ComControllers extends D3ComCellBase
	{
		public function D3ComControllers()
		{ 
			super();
		}
		
		override protected function create_init():void
		{
			super.create_init();
			_create_init()
		}
		
		public var comBox:UICombobox;
		private var editBtn:UIAssetsSymbol;
		
		private function _create_init():void
		{
			width = 260;
			height = 50;
			
			var v:UIVBox = new UIVBox();
			v.paddingRight=2;
			v.styleName = "uicanvas";
			v.enabledPercentSize = true;
			addChild(v);
			
			var h:UIHBox = new UIHBox();
			h.enabledPercentSize = true;
			h.verticalAlignMiddle = true;
			v.addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "控制器: "
			lb.width = 80;
			lb.height = 20;
			h.addChild(lb);
			
			comBox = new UICombobox();
			comBox.labelField = "name"
			comBox.percentWidth = 100;
			comBox.height = 23;
			h.addChild(comBox);
			var a:Array = [];
			a.push(new D3MethodItemVO());
			a.push(D3ComponentProxy.getInstance().method_ls.getItemById(13));
			a.push(D3ComponentProxy.getInstance().method_ls.getItemById(14));
			comBox.dataProvider = a;
			comBox.addEventListener(ASEvent.CHANGE , onComBoxChange);
			
			editBtn = new UIAssetsSymbol();
			editBtn.source = "edit2_a"
			editBtn.width = 16;
			editBtn.height = 16;
			editBtn.toolTip = "编辑"
			editBtn.buttonMode = true;
			editBtn.addEventListener(MouseEvent.CLICK , onEditHandle);
			h.addChild(editBtn);
		}
		
		private function onComBoxChange(e:ASEvent):void
		{
			var d:D3MethodItemVO = comBox.selectedItem as D3MethodItemVO;
			(comp.proccess as D3ProccessCamera).addControls(key,d);
			D3ProjectCache.dataChange = true;
		}
		
		override public function setValue():void
		{
			super.setValue();
			
			var v:D3ObjectMethod = comp.configData.getAttri(item.key);
			if(StringTWLUtil.isWhitespace(v)){
				comBox.selectedIndex = 0;
				return ;
			}
			
			var a:Array = comBox.dataProvider as Array;
			for(var i:int=0;i<a.length;i++){
				var m:D3MethodItemVO = a[i] as D3MethodItemVO;
				if(m.id == v.compItem.id){
					comBox.selectedIndex = i;
					break;
				}
			}
		}
		
		private function onEditHandle(e:MouseEvent):void
		{
			var d:* = comBox.selectedItem;
			if(d is D3MethodItemVO){
				if(d.id > 0){
					comp.proccess.selectMethod(key)
				}
			}
		}
		
		
	}
}
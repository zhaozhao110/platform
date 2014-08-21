package com.editor.d3.view.attri.cell.renderer
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UICombobox;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectLight;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.view.attri.cell.D3ComLight;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class D3ComLightItemRenderer extends ASHListItemRenderer
	{
		public function D3ComLightItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var ti:UICombobox;
		private var closeBtn:UIAssetsSymbol;
		public var cell:D3ComLight;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			
			horizontalGap = 5;
			
			ti = new UICombobox();
			ti.width = 200;
			ti.height = 23;
			ti.addEventListener(ASEvent.CHANGE,onChangeHandle);
			addChild(ti);
			
			closeBtn = new UIAssetsSymbol();
			closeBtn.source = "close2_a"
			closeBtn.width = 16;
			closeBtn.height = 16;
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.MOUSE_DOWN , onCloseBtnClick);
			addChild(closeBtn);
		}
		
		public var comp:D3ObjectLight;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			comp = value as D3ObjectLight;
			comp.itemRenderer = this;
			
			ti.labelField = "name"
			var l:D3ObjectLight = new D3ObjectLight(D3ComponentConst.from_outline);
			l.name = "null"
			var a:Array = [l];
			a = a.concat(D3SceneManager.getInstance().displayList.lightPicker_ls);
			ti.dataProvider = a;
			if(!StringTWLUtil.isWhitespace(comp.name)){
				for(var i:int=0;i<a.length;i++){
					if(!StringTWLUtil.isWhitespace(D3ObjectBase(a[i]).name)){
						if(D3ObjectBase(a[i]).node.path == comp.name){
							ti.setSelectIndex(i,false,true);
							return 
						}
					}
				}
				ti.selectedIndex = 0;
			}else{
				ti.selectedIndex = 0;
			}
		}
		
		override public function poolDispose():void
		{
			super.poolDispose();
			//ti.selectedIndex = 0;
		}
		
		private function onChangeHandle(e:*=null):void
		{
			var d:D3ObjectLight = ti.selectedItem;
			if(!StringTWLUtil.isWhitespace(d.name)){
				comp.name = d.node.path;
				comp.selectedLight = d.getLight();
				D3Object(cell.comp).reflashLightBase();
				D3Object(cell.comp).reflashLight();
			}else{
				comp.name = null;
				comp.selectedLight = null;
				D3Object(cell.comp).reflashLightBase();
				D3Object(cell.comp).reflashLight();
			}
			D3ProjectCache.dataChange = true;
		}
		
		private function onCloseBtnClick(e:MouseEvent):void
		{
			D3Object(cell.comp).removeLight(comp);
			D3Object(cell.comp).reflashLight();
			cell.reflashData();
			D3ProjectCache.dataChange = true;
		}
		
	}
}
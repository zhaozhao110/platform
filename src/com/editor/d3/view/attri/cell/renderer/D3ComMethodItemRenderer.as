package com.editor.d3.view.attri.cell.renderer
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UICombobox;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectLight;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.view.attri.cell.D3ComLight;
	import com.editor.d3.view.attri.cell.D3ComMethod;
	import com.editor.d3.vo.method.D3MethodItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	
	public class D3ComMethodItemRenderer extends ASHListItemRenderer
	{
		public function D3ComMethodItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var ti:UICombobox;
		private var closeBtn:UIAssetsSymbol;
		public var cell:D3ComMethod;
		private var editBtn:UIAssetsSymbol;
		
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
			
			editBtn = new UIAssetsSymbol();
			editBtn.source = "edit2_a"
			editBtn.width = 16;
			editBtn.height = 16;
			editBtn.toolTip = "编辑"
			editBtn.buttonMode = true;
			editBtn.addEventListener(MouseEvent.CLICK , onEditHandle);
			addChild(editBtn);
			
			closeBtn = new UIAssetsSymbol();
			closeBtn.source = "close2_a"
			closeBtn.width = 16;
			closeBtn.height = 16;
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.MOUSE_DOWN , onCloseBtnClick);
			addChild(closeBtn);
		}
		
		public var comp:D3ObjectMethod;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			comp = value as D3ObjectMethod;
			comp.itemRenderer = this;
			
			ti.labelField = "name"
			var l:D3MethodItemVO = new D3MethodItemVO();
			l.name = "null"
			var a:Array = [l];
			a = a.concat(D3ComponentProxy.getInstance().method_ls.method_ls);
			ti.dataProvider = a;
			
			if(!StringTWLUtil.isWhitespace(comp.name)){
				for(var i:int=0;i<a.length;i++){
					if(!StringTWLUtil.isWhitespace(D3MethodItemVO(a[i]).name)){
						if(D3MethodItemVO(a[i]).name == comp.compItem.name){
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
			var d:D3MethodItemVO = ti.selectedItem;
			if(!StringTWLUtil.isWhitespace(d.name)){
				comp.compItem = d.cloneObject();
				comp.addMethodToMaterial();
			}else{
				comp.compItem = null;
				comp.removeMethodToMaterial();
			}
			D3ProjectCache.dataChange = true;
		}
		
		private function onCloseBtnClick(e:MouseEvent):void
		{
			comp.compItem = null;
			comp.removeMethodToMaterial();
			D3Object(cell.comp).removeMethod(comp);
			cell.reflashData();
			D3ProjectCache.dataChange = true;
		}
		
		private function onEditHandle(e:MouseEvent):void
		{
			iManager.sendAppNotification(D3Event.select3DComp_event,comp);
		}
		
	}
}
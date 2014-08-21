package com.editor.d3.view.attri.cell
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectLight;
	import com.editor.d3.view.attri.cell.renderer.D3ComLightItemRenderer;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;

	public class D3ComLight extends D3ComCellBase
	{
		public function D3ComLight()
		{
			super();
		}
		
		
		override protected function create_init():void
		{
			super.create_init();
			_create_init();
		}
		
		private var addBtn:UIAssetsSymbol;
		private var box:UIVBox;
		
		private function _create_init():void
		{
			width = 260;
			height = 110;
			
			var v:UIVBox = new UIVBox();
			v.paddingRight=2;
			v.styleName = "uicanvas";
			v.enabledPercentSize = true;
			addChild(v);
			
			var h:UIHBox = new UIHBox();
			h.percentWidth = 100;
			h.height = 25;
			h.verticalAlignMiddle = true;
			v.addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "lights"
			lb.width = 50;
			lb.height = 20;
			h.addChild(lb);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.buttonMode = true;
			addBtn.toolTip = "新建light"
			addBtn.addEventListener(MouseEvent.CLICK , onAddHandle2);
			h.addChild(addBtn);
			
			lb = new UILabel();
			lb.text = "默认是接收所有灯光";
			h.addChild(lb);
			lb.color = ColorUtils.red;
			
			box = new UIVBox();
			box.styleName = "list"
			box.enabledPercentSize = true;
			box.rowHeight = 25;
			box.itemRenderer = D3ComLightItemRenderer;
			box.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			box.addEventListener(ASEvent.CHILDADD,onChildAdd)
			v.addChild(box);
		}
		
		private function onChildAdd(e:ASEvent):void
		{
			var ds:D3ComLightItemRenderer = e.data as D3ComLightItemRenderer;
			ds.cell = this;
		}
		
		private function onAddHandle2(e:MouseEvent):void
		{
			var d:D3ObjectLight = new D3ObjectLight(D3ComponentConst.from_outline);
			d.object = comp;
			D3Object(comp).addLight(d);
			box.dataProvider = D3Object(comp).light_a;
		}
		
		override public function setValue():void
		{
			super.setValue();
			reflashData();
		}
		
		public function reflashData():void
		{
			box.dataProvider = D3Object(comp).light_a;
		}
		
		
	}
}
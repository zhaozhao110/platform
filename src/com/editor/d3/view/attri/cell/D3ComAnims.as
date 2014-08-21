package com.editor.d3.view.attri.cell
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.object.D3ObjectAnim;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.view.attri.cell.renderer.D3ComAnimItemRenderer;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.events.MouseEvent;

	public class D3ComAnims extends D3ComCellBase
	{
		public function D3ComAnims()
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
			lb.text = "anim"
			lb.width = 50;
			lb.height = 20;
			h.addChild(lb);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.buttonMode = true;
			addBtn.toolTip = "新建anim"
			addBtn.addEventListener(MouseEvent.CLICK , onAddHandle2);
			h.addChild(addBtn);
			
			box = new UIVBox();
			box.styleName = "list"
			box.enabledPercentSize = true;
			box.itemRenderer = D3ComAnimItemRenderer;
			box.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			box.addEventListener(ASEvent.CHILDADD,onChildAdd);
			v.addChild(box);
		}
		
		private function onChildAdd(e:ASEvent):void
		{
			var ds:D3ComAnimItemRenderer = e.data as D3ComAnimItemRenderer;
			ds.cell = this;
		}
		
		private function onAddHandle2(e:MouseEvent):void
		{
			var d:D3ObjectAnim = new D3ObjectAnim(D3ComponentConst.from_outline);
			d.compItem = D3ComponentProxy.getInstance().com_ls.getItemById(13);
			d.name = d.compItem.en+(getNames(d.compItem.en).length+1);
			d.parentObject = comp as D3Object;
			d.readAnim2();
			D3Object(comp).addAnimComp(d);
			box.dataProvider = D3Object(comp).animComps;
		}
		
		private function getNames(n:String):Array
		{
			var b:Array = [];
			for(var i:int=0;i<D3Object(comp).animComps.length;i++){
				var fl:D3ObjectAnim = D3Object(comp).animComps[i] as D3ObjectAnim;
				if(String(fl.name.split(".")[0]).indexOf(n)!=-1){
					b.push(fl);
				}
			}
			return b;
		}
		
		override public function setValue():void
		{
			super.setValue();
			reflashBox()
		}
		
		public function reflashBox():void
		{
			box.dataProvider = D3Object(comp).animComps;
		}
		
		public function delAnim(d:D3Object):void
		{
			/*var m:OpenMessageData = new OpenMessageData();
			m.info = "确定要删除动作，"+d.animName + "?"
			m.okFunction = confirm_del;
			m.okFunArgs = d;
			iManager.iPopupwin.showConfirm(m);*/
		}
		
		private function confirm_del(d:D3Object):Boolean
		{
			/*(comp as D3Object).delAnim(d);
			reflashBox();
			D3ProjectCache.dataChange = true;*/
			return true;
		}
		
	}
}
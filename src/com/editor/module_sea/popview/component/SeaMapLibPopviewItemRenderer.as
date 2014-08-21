package com.editor.module_sea.popview.component
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.mediator.SeaMapContentMediator;
	import com.editor.module_sea.mediator.SeaMapModuleTopContainerMediator;
	import com.editor.module_sea.vo.SeaMapData;
	import com.editor.module_sea.vo.SeaMapItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;

	public class SeaMapLibPopviewItemRenderer extends ASHListItemRenderer
	{
		public function SeaMapLibPopviewItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var lb:UILabel;
		
		private var vcb:UICheckBox;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			
			horizontalGap = 5;
			
			lb = new UILabel();
			lb.selectable = false;
			lb.mouseChildren = false;
			lb.mouseEnabled = false;
			lb.width = 120;
			lb.height = 22
			addChild(lb);
			
			vcb = new UICheckBox();
			vcb.label = "显示"
			vcb.width = 50;
			vcb.selected = true;
			vcb.addEventListener(ASEvent.CHANGE,onVisibleChange);
			addChild(vcb);
			
		}
		
		private var item:SeaMapItemVO;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			item = value as SeaMapItemVO;
			lb.text = item.name1;
		}
		
		private function get_SeaMapModuleTopContainerMediator():SeaMapModuleTopContainerMediator
		{
			return iManager.retrieveMediator(SeaMapModuleTopContainerMediator.NAME) as SeaMapModuleTopContainerMediator
		}
		
		private function get_SeaMapContentMediator():SeaMapContentMediator
		{
			return iManager.retrieveMediator(SeaMapContentMediator.NAME) as SeaMapContentMediator
		}
		
		private function onVisibleChange(e:ASEvent):void
		{
			var a:Array = SeaMapModuleManager.mapData.getArrayByRedId(item.resItem.id);
			for(var i:int=0;i<a.length;i++){
				SeaMapItemVO(a[i]).container.visible = vcb.selected;
			}
		}
		
		
	}
}
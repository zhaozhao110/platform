package com.editor.module_skill.view.left.cell
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.module_skill.mediator.left.SkillSeqEffectCellMediator;
	import com.editor.module_skill.mediator.left.SkillSeqResCellMediator;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	
	import flash.events.MouseEvent;
	
	public class SkillSeqResItemRenderer extends ASHListItemRenderer
	{
		public function SkillSeqResItemRenderer()
		{
			super();
			create_init();
		}
		
		private function create_init():void
		{
			mouseChildren = true;
			inheritParentStyleName = true;
			
			closeImg = new UIAssetsSymbol();
			closeImg.source = "closeBtn_a";
			closeImg.width = 16;
			closeImg.height = 16;
			closeImg.buttonMode = true;
			closeImg.addEventListener(MouseEvent.CLICK , onCloseHandle)
			addChild(closeImg);
			
			txt = new UILabel();
			addChild(txt);
		}
		
		public var closeImg:UIAssetsSymbol;
		public var txt:UILabel;
		
		public var item:AppResInfoItemVO;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			item = value as AppResInfoItemVO;
			txt.text = item.name + ",id:"+item.id;
		}
		
		private function onCloseHandle(e:MouseEvent):void
		{
			get_SkillSeqResCellMediator().delEffect(item);
		}
		
		private function get_SkillSeqResCellMediator():SkillSeqResCellMediator
		{
			return iManager.retrieveMediator(SkillSeqResCellMediator.NAME) as SkillSeqResCellMediator;
		}
	}
}
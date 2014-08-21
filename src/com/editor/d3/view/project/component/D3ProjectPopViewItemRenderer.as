package com.editor.d3.view.project.component
{
	import com.air.io.FileUtils;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import com.editor.d3.view.project.D3ProjectPopViewMediator;

	public class D3ProjectPopViewItemRenderer extends ASHListItemRenderer
	{
		public function D3ProjectPopViewItemRenderer()
		{
			super();
			horizontalGap = 5;
		}
		
		public var file:File;
		
		override public function poolChange(value:*):void
		{
			file = value as File;
			if(file.isDirectory){
				addIcon();
			}
			super.poolChange(value);
			
			textfield.selectable = false;
			textfield.width = 200;
			
			if(file.isDirectory){
				if(icon!=null){
					icon.visible = true;
					icon.includeInLayout = true;
				}
			}else{
				if(icon!=null){
					icon.visible = false;
					icon.includeInLayout = false;
				}
			}
		}
				
		private function onDelClick(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			get_D3ProjectPopViewMediator().delFile(file);
		}
		
		override protected function getIconSource():String
		{
			if(file.isDirectory){
				return "fold_a"
			}
			return "";
		}
		
		override protected function setRendererLabel():void
		{
			label = file.name;
		}
		
		override protected function getIconWidth():int
		{
			return 20
		}
		
		override protected function getIconHeight():int
		{
			return 20
		}
		
		private function get_D3ProjectPopViewMediator():D3ProjectPopViewMediator
		{
			return iManager.retrieveMediator(D3ProjectPopViewMediator.NAME) as D3ProjectPopViewMediator;
		}
	}
}
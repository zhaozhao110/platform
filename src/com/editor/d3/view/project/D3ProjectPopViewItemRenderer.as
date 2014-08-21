package com.editor.d3.view.project
{
	import com.air.io.FileUtils;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

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
				addIcon()
			}else{
				if(icon!=null) icon.visible = false;
			}
			super.poolChange(value);
			
			textfield.width = 200;
			
			createTxt2();
			txt2.text = TimerUtils.getFromatTime(file.modificationDate.time/1000) + " , size: " + FileUtils.getFileSize(file.nativePath) + "k";
		}
		
		private var txt2:UILabel;
		private var delBtn:UIAssetsSymbol;
		private function createTxt2():void
		{
			if(txt2 == null){
				txt2 = new UILabel();
				txt2.width = 200;
				addChild(txt2);
			}
			if(delBtn == null){
				delBtn = new UIAssetsSymbol();
				delBtn.width = 16;
				delBtn.height = 16;
				delBtn.source = "closeBtn_a";
				delBtn.buttonMode = true;
				delBtn.addEventListener(MouseEvent.MOUSE_DOWN , onDelClick);
				addChild(delBtn);
			}
			
			mouseChildren = true;
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
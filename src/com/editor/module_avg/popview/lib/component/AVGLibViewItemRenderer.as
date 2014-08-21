package com.editor.module_avg.popview.lib.component
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.module_avg.event.AVGEvent;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.popview.lib.AVGLibViewMediator;
	import com.editor.module_avg.vo.AVGResData;
	import com.sandy.asComponent.containers.ASHBox;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.manager.data.SandyDragSource;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class AVGLibViewItemRenderer extends ASHListItemRenderer
	{
		public function AVGLibViewItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		public var foldImg:UIAssetsSymbol
		public var txt:UILabel;
		public var playBtn:UIButton;
		public static var dragImg:Bitmap;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			dragAndDrop = true
			horizontalGap = 5;
			
			foldImg = new UIAssetsSymbol();
			foldImg.source = "fold2_a"
			foldImg.width = 16;
			foldImg.height = 13;
			addChild(foldImg);
			foldImg.visible = false;
			
			txt = new UILabel();
			txt.mouseChildren = false;
			txt.mouseEnabled = false;
			addChild(txt);
			
			playBtn = new UIButton();
			playBtn.label = "预览"
			playBtn.addEventListener(MouseEvent.CLICK , onPlayHandle);
			addChild(playBtn);
			
			if(dragImg == null){
				dragImg = new Bitmap(iManager.iResource.getBitmapData("pre_a"));
			}
		}
		
		private function onPlayHandle(e:MouseEvent):void
		{
			if(playBtn.label == "预览"){
				iManager.sendAppNotification(AVGEvent.preRes_inavg_event,resData);
			}else if(playBtn.label == "打开"){
				get_AVGLibViewMediator().getFileList(resData);
			}else if(playBtn.label == "播放"){
				AVGManager.getInstance().playSound(resData);
			}
		}
		
		public var resData:AVGResData;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			resData = value as AVGResData;
			txt.text = resData.fileName;
			txt.width = 200;
			playBtn.visible = true;
			if(resData.isImage || resData.isSwf){
				playBtn.label = "预览"
			}else if(resData.isSound){
				playBtn.label = "播放"
			}else if(resData.directory){
				playBtn.label = "打开"
			}else{
				playBtn.visible = false;
			}
		}
		
		override public function checkDrag():Boolean
		{
			return !resData.directory && playBtn.visible;
		}
		
		override protected function createDragProxy():Bitmap
		{
			var bit:Bitmap = new Bitmap(dragImg.bitmapData)
			return bit;
		}
		
		override protected function createDragSource():SandyDragSource
		{
			var ds:SandyDragSource = new SandyDragSource();
			ds.data = data;
			ds.type = DataManager.dragAndDrop_avgLibView;
			return ds;
		}
		
		private function preImage():void
		{
			iManager.sendAppNotification(AppEvent.preImage_event);
		}
		
		private function get_AVGLibViewMediator():AVGLibViewMediator
		{
			return iManager.retrieveMediator(AVGLibViewMediator.NAME) as AVGLibViewMediator;
		}
	}
}
package com.editor.module_avg.popview.outline.component
{
	import com.editor.component.controls.UIButton;
	import com.editor.module_avg.popview.attri.AVGAttriView;
	import com.editor.module_avg.preview.AVGPreview;
	import com.editor.module_avg.preview.AVGPreviewItem;
	import com.editor.module_avg.vo.AVGResData;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	
	import flash.events.MouseEvent;

	public class AVGOutlineItemRenderer extends ASHListItemRenderer
	{
		public function AVGOutlineItemRenderer()
		{
			super();
			paddingLeft = 10;
			mouseChildren = true;
		}
		
		public var resData:AVGResData;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
				
			resData = value as AVGResData;
			label = resData.fileName;
			textfield.width = 140;
			textfield.mouseEnabled = false;
			textfield.mouseChildren = false;
			
			addBtns();
			
			if(resData.isSound){
				visibleBtn.label = "播放/暂停"
			}else{
				visibleBtn.label = "隐藏/显示"
			}
		}
		
		private var editBtn:UIButton;
		private var closeBtn:UIButton;
		private var visibleBtn:UIButton;
		
		private function addBtns():void
		{
			if(editBtn != null) return ;
			
			visibleBtn = new UIButton();
			visibleBtn.label = "隐藏/显示"
			visibleBtn.addEventListener(MouseEvent.CLICK , onVisibleClick);
			addChild(visibleBtn);
			
			editBtn = new UIButton();
			editBtn.label = "编辑"
			editBtn.addEventListener(MouseEvent.CLICK , onEditClick);
			addChild(editBtn);
			
			closeBtn = new UIButton();
			closeBtn.label = "删除"
			closeBtn.addEventListener(MouseEvent.CLICK , onDelClick);
			addChild(closeBtn);
		}
		
		private function onEditClick(e:MouseEvent):void
		{
			AVGAttriView.instance.setAttri(resData);
		}
		
		private function onDelClick(e:MouseEvent):void
		{
			AVGPreview.instance.removeRes(resData);				
		}
		
		private function onVisibleClick(e:MouseEvent):void
		{
			var d:AVGPreviewItem = AVGPreview.instance.getPreviewItem(resData.id);
			if(resData.isSound){
				if(d.soundIsPlaying()){
					d.stopSound();
				}else{
					d.addSound();
				}
			}else{
				if(d.getDisplayObject()!=null){
					d.getDisplayObject().visible = !d.getDisplayObject().visible;
				}
			}
		}
	}
}
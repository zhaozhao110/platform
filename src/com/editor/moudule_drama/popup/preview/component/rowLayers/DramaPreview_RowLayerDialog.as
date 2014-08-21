package com.editor.moudule_drama.popup.preview.component.rowLayers
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIText;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.popup.preview.DramaPreviewPopupwinMediator;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_Container;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_RowLayer;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameDialogVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotItemVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotListNodeVO;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;

	/**
	 * 对话层
	 * @author sun
	 * 
	 */	
	public class DramaPreview_RowLayerDialog extends DramaPreview_RowLayer
	{
		public function DramaPreview_RowLayerDialog()
		{
			super();
			create_init();
		}
		
		[Embed(source="/assets/img/bustL.png")]
		public var bustLCla:Class;
		
		[Embed(source="/assets/img/bustR.png")]
		public var bustRCla:Class;
		
		[Embed(source="/assets/img/mouse1.png")]
		public var mouseCla:Class;
		
		/**对话容器 **/
		public var dialogContainer:UICanvas;
		/**对话文字**/
		public var dialogText:UIText;
		/**左NPC**/
		public var leftBustImg:Bitmap;
		/**右NPC**/
		public var rightBustImg:Bitmap;
		
		/**旁白容器**/
		public var asideContainer:UICanvas;
		public var asideText:UIText;
		
		private function create_init():void
		{
			/** << 对话容器**/
			dialogContainer = new UICanvas();
			dialogContainer.width = DramaConst.layoutSceneContainerW;
			dialogContainer.height = DramaConst.layoutSceneContainerH;
			dialogContainer.backgroundColor = 0x000000;
			dialogContainer.backgroundAlpha = 0.1;
			addChild(dialogContainer);
			dialogContainer.mouseEnabled = true;
			dialogContainer.visible = false;			
			/**对话	上部遮罩**/
			var topMask:UICanvas = new UICanvas();
			topMask.x = 0; topMask.y = 0;
			topMask.width = dialogContainer.width;
			topMask.height = 80;
			topMask.backgroundColor = 0x000000;
			topMask.backgroundAlpha = 0.6;
			dialogContainer.addChild(topMask);			
			/**对话	下部遮罩**/
			var bottomMask:UICanvas = new UICanvas();
			bottomMask.width = dialogContainer.width;
			bottomMask.height = 160;
			bottomMask.x = 0; 
			bottomMask.y = dialogContainer.height - bottomMask.height;
			bottomMask.backgroundColor = 0x000000;
			bottomMask.backgroundAlpha = 0.6;
			dialogContainer.addChild(bottomMask);			
			/**对话	左NPC**/
			leftBustImg = new bustLCla as Bitmap;
			leftBustImg.x = 80; leftBustImg.y = 336;
			dialogContainer.addChild(leftBustImg);			
			/**对话	右NPC**/
			rightBustImg = new bustRCla as Bitmap;
			rightBustImg.x = 890; rightBustImg.y = 342;
			dialogContainer.addChild(rightBustImg);			
			/**对话	对话文字**/
			dialogText = new UIText();
			dialogText.x = 385; dialogText.y = 510;
			dialogText.width = dialogContainer.width - (dialogText.x*2);
			dialogText.height = dialogContainer.height - dialogText.y;
			dialogText.color = 0xffffff;
			dialogText.fontSize = 14;
			dialogText.leading = 5;
			dialogContainer.addChild(dialogText);
			dialogText.htmlText = "";			
			/**对话	鼠标**/
			var mouseImg:Bitmap = new mouseCla() as Bitmap;
			mouseImg.x = 860; mouseImg.y = 580;
			dialogContainer.addChild(mouseImg);			
			var mouseTxt:UIText = new UIText();
			mouseTxt.x = 786; mouseTxt.y = 590;
			mouseTxt.color = 0x3EF4F6;
			mouseTxt.fontSize = 14;
			mouseTxt.text = "点击继续";
			dialogContainer.addChild(mouseTxt);
			
			/** << 旁白容器**/
			asideContainer = new UICanvas();
			asideContainer.width = DramaConst.layoutSceneContainerW;
			asideContainer.height = DramaConst.layoutSceneContainerH;
			asideContainer.backgroundColor = 0x000000;
			addChild(asideContainer);
			asideContainer.visible = false;
			/**旁白文字**/
			asideText = new UIText();
			asideText.width = 600;
			asideText.horizontalCenter = 0;
			asideText.y = 200;
			asideText.textAlign = "center";
			asideText.color = 0xffffff;
			asideText.fontSize = 16;
			asideText.leading = 5;
			asideContainer.addChild(asideText);
			
		}
		
		override public function processKeyFrameVO(vo:ITimelineKeyframe_BaseVO):void
		{
			if(vo)
			{
				var dialogVO:Drama_FrameDialogVO = vo as Drama_FrameDialogVO;
				if(dialogVO)
				{
					DramaManager.getInstance().get_DramaPreviewPopupwinMediator().previewContainer.pause();
					dialogContainer.visible = true;
					
					var nodeId:int = DramaDataManager.getInstance().currentSelectedDramaItem.id;
					var item:DramaPlotItemVO = DramaManager.getInstance().get_DramaProxy().plot_ls.getPlotItem(dialogVO.dialogId, nodeId);
					if(item)
					{
						if(item.type == 0)
						{
							/**普通对话**/
							dialogText.htmlText = item.content;
							if(dialogVO.dialogPlace > 0)
							{
								leftBustImg.visible = false;
								rightBustImg.visible = true;
							}else
							{
								leftBustImg.visible = true;
								rightBustImg.visible = false;
							}
							
							dialogContainer.addEventListener(MouseEvent.CLICK, dialogContainerMouseClickHandle);
							
						}else if(item.type == 1)
						{
							/**旁白**/
							asideText.htmlText = "<b>" + item.content + "</b>";
							asideContainer.visible = true;
							var timer:Timer = new Timer(2000,1);
							timer.addEventListener(TimerEvent.TIMER_COMPLETE, onAsideTimerCompleteHandle);
							timer.start();
						}
					}
					
				}
				
			}
		}
		/**对话鼠标点击**/
		private function dialogContainerMouseClickHandle(e:MouseEvent):void
		{
			dialogContainer.removeEventListener(MouseEvent.CLICK, dialogContainerMouseClickHandle);
			
			asideContainer.visible = false;
			dialogContainer.visible = false;
			
			var prieviewCMedia:DramaPreviewPopupwinMediator = DramaManager.getInstance().get_DramaPreviewPopupwinMediator()
			if(prieviewCMedia)
			{
				prieviewCMedia.previewContainer.dePause();
			}
			
		}
		
		/**旁白定时**/
		private function onAsideTimerCompleteHandle(e:TimerEvent):void
		{
			asideContainer.visible = false;
			dialogContainer.visible = false;
			
			var prieviewCMedia:DramaPreviewPopupwinMediator = DramaManager.getInstance().get_DramaPreviewPopupwinMediator()
			if(prieviewCMedia)
			{
				prieviewCMedia.previewContainer.dePause();
			}
			
			var timer:Timer = e.target as Timer;
			if(timer)
			{
				timer.stop();
				timer = null;
			}
		}
		
		
		
		
		
	}
}
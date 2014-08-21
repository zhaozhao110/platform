package com.editor.module_avg.pop.preview
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.pop.AVGPopViewBase;
	import com.editor.module_avg.preview.AVGPreview;
	import com.editor.module_avg.vo.AVGConfigVO;
	import com.editor.module_avg.vo.AVGResData;
	import com.editor.module_avg.vo.frame.AVGFrameItemVO;
	import com.editor.module_avg.vo.sec.AVGSectionItemVO;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;

	public class AVGPlayview extends AVGPopViewBase
	{
		public function AVGPlayview()
		{
			super();
			instance = this;
		}
		
		public static var instance:AVGPlayview;
		
		override protected function get poptitle():String
		{
			return "预览";
		}
		
		private var preview:AVGPreview;
		
		override protected function create_init():void
		{			
			super.create_init();
				
			preview = new AVGPreview(true);
			preview.click_f = clickPlay;
			preview.y = 33;
			preview.x = 2;
			addChild(preview);
			
			contentBox.visible = false;
			
			reflashContent()
		}
		
		override protected function onCloseHandle(e:MouseEvent):void
		{
			get_AVGModuleMediator().closePlayView();
			super.onCloseHandle(e);
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			
			reflashContent()
		}

		override protected function uiHide():void
		{
			super.uiHide();
			preview.stopAllSound();
			preview.dialogCont.contTxt.setAll();
			SoundMixer.stopAll();
		}
		
		private function reflashContent():void
		{
			SoundMixer.stopAll();
			width = AVGConfigVO.instance.width+15;
			height = AVGConfigVO.instance.height+50;
			frameIndex = 0
			play()
		}
		
		private var frameIndex:int;
		private var currSection:AVGSectionItemVO;
		
		private function play():void
		{
			currSection = AVGManager.currSection
			clickPlay()
		}
		
		private function clickPlay():void
		{
			if(currSection == null) return ;
			if(currSection.frame_ls.length>=(frameIndex+1)){
				var f:AVGFrameItemVO = currSection.frame_ls[frameIndex] as AVGFrameItemVO;
				if(f!=null){
					preview.setFrame(f);
				}
				frameIndex += 1;
			}else{
				//end
				
			}
		}
		
		public function jumpPlay(d:AVGResData):void
		{
			if(StringTWLUtil.isWhitespace(d.jumpSectionName)) return ;
			preview.setAllDialogContent();
			currSection = AVGManager.getInstance().sectionList.getSection(d.jumpSectionName) as AVGSectionItemVO;
			frameIndex = 0;
			clickPlay()
		}
		
	}
}
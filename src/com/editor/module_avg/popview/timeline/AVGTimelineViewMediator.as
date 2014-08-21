package com.editor.module_avg.popview.timeline
{
	import com.editor.component.containers.UIVBox;
	import com.editor.mediator.AppMediator;
	import com.editor.module_avg.event.AVGEvent;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.vo.frame.AVGFrameItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	
	public class AVGTimelineViewMediator extends AppMediator
	{
		public static const NAME:String = "AVGTimelineViewMediator";
		public function AVGTimelineViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():AVGTimelineView
		{
			return viewComponent as AVGTimelineView;
		}
		public function get fileBox():UIVBox
		{
			return mainUI.fileBox;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			mainUI.addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			mainUI.delBtn.addEventListener(MouseEvent.CLICK , onDel);
			mainUI.copyBtn.addEventListener(MouseEvent.CLICK , onCopy);
			fileBox.addEventListener(ASEvent.CHANGE,onFileChange);
		}
		
		private function onAdd(e:MouseEvent):void
		{
			if(AVGManager.currSection == null){
				showError("请先选择某一个分段");
				return ;
			}
			AVGManager.currSection.createFrame();
			fileBox.dataProvider = AVGManager.currSection.frame_ls;
			fileBox.setSelectIndex(AVGManager.currSection.frame_ls.length-1,true,true);
		}
		
		private function onFileChange(e:ASEvent):void
		{
			AVGManager.currFrame = fileBox.selectedItem as AVGFrameItemVO;
			sendAppNotification(AVGEvent.selectFrame_inavg_event);
			sendAppNotification(AVGEvent.reflashOutline_inavg_event);
		}
		
		public function respondToSelectSectionInavgEvent(noti:Notification):void
		{
			fileBox.dataProvider = AVGManager.currSection.frame_ls;
			fileBox.setSelectIndex(0,true,true);
		}
		
		public function respondToReflashTimelineInavgEvent(noti:Notification):void
		{
			if(AVGManager.currSection == null){
				fileBox.dataProvider = null
			}else{
				fileBox.dataProvider = AVGManager.currSection.frame_ls;
			}
		}
		
		private function onDel(e:MouseEvent):void
		{
			if(AVGManager.currSection == null){
				showError("请先选择某一个分段");
				return ;
			}
			delFrame(AVGManager.currFrame);
		}
		
		public function delFrame(d:AVGFrameItemVO):void
		{
			if(d == null) return ;
			var m:OpenMessageData = new OpenMessageData();
			m.info = "确定要删除第"+d.index+"帧？"
			m.okFunction = delFrame_confirm;
			m.okFunArgs = d;
			showConfirm(m);
		}
		
		private function delFrame_confirm(d:AVGFrameItemVO):Boolean
		{
			AVGManager.currSection.removeFrame(d)
			fileBox.dataProvider = AVGManager.currSection.frame_ls;
			fileBox.setSelectIndex(0,true,true);
			return true;
		}
		
		private function onCopy(e:MouseEvent):void
		{
			if(AVGManager.currSection == null){
				showError("请先选择某一个分段");
				return ;
			}
			if(StringTWLUtil.isWhitespace(mainUI.copyTi.text)){
				showError("请先输入要复制的位置");
				return ;
			}
			var selI:int = int(mainUI.copyTi.text);
			AVGManager.currSection.copyFrame(AVGManager.currFrame,selI);
			fileBox.dataProvider = AVGManager.currSection.frame_ls;
			fileBox.setSelectIndex(selI,true,true);
		}
		
		
	}
}
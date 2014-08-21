package com.editor.module_avg.popview.section
{
	import com.editor.component.containers.UIVBox;
	import com.editor.mediator.AppMediator;
	import com.editor.module_avg.event.AVGEvent;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.popview.section.component.AVGSectionViewItemRenderer;
	import com.editor.module_avg.vo.sec.AVGSectionItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;
	
	public class AVGSectionViewMediator extends AppMediator
	{
		public static const NAME:String = "AVGSectionViewMediator";
		public function AVGSectionViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():AVGSectionView
		{
			return viewComponent as AVGSectionView;
		}
		public function get fileBox():UIVBox
		{
			return mainUI.fileBox;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			mainUI.addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			fileBox.addEventListener(ASEvent.CHANGE,onFileChange);
		}
		
		private function onAdd(e:MouseEvent):void
		{
			AVGManager.getInstance().sectionList.create();
			fileBox.dataProvider = AVGManager.getInstance().sectionList.section_ls;
			//fileBox.selectedIndex = AVGManager.getInstance().sectionList.section_ls.length-1;
		}
		
		private function onFileChange(e:ASEvent):void
		{
			
		}
		
		public function respondToSelectPlotInavgEvent(noti:Notification):void
		{
			fileBox.dataProvider = AVGManager.getInstance().sectionList.section_ls;
		}
		
		public function delSection(d:AVGSectionItemVO):void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "确定要删除"+d.name+"分段"
			m.okFunction = delFrame_confirm;
			m.okFunArgs = d;
			showConfirm(m);
		}
		
		public function copy(d:AVGSectionItemVO):void
		{
			AVGManager.getInstance().sectionList.copy(d);
			fileBox.dataProvider = AVGManager.getInstance().sectionList.section_ls;
		}
		
		private function delFrame_confirm(d:AVGSectionItemVO):Boolean
		{
			AVGManager.getInstance().sectionList.removeSection(d);
			fileBox.dataProvider = AVGManager.getInstance().sectionList.section_ls;
			if(fileBox.numChildren>0){
				AVGSectionViewItemRenderer(fileBox.getChildAt(0)).onSelectHandle();
			}
			return true;
		}
		
	}
}
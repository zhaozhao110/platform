package com.editor.module_ui.view.inventedGroup
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIVlist;
	import com.editor.mediator.AppMediator;
	import com.editor.module_ui.ui.UIEditCache;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.vo.InvertedGroupVO;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;

	public class InvertedGroupViewMediator extends AppMediator
	{
		public static const NAME:String = "InvertedGroupViewMediator"
		public function InvertedGroupViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get invertedGroupView():InvertedGroupView
		{
			return viewComponent as InvertedGroupView;
		}
		public function get comList():UIVBox
		{
			return invertedGroupView.comList;
		}
		public function get addBtn():UIAssetsSymbol
		{
			return invertedGroupView.addBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			if(UIEditManager.currEditShowContainer!=null){
				comList.dataProvider = UIEditManager.currEditShowContainer.cache.invertedGroup_ls;
			}
		}
		
		public function reactToAddBtnClick(e:MouseEvent):void
		{
			if(UIEditManager.currEditShowContainer == null) return ;
			if(UIEditManager.currEditShowContainer.cache == null) return 
			var g:InvertedGroupVO = new InvertedGroupVO();
			g.id = UIEditManager.currEditShowContainer.cache.getGroupId();
			g.createGroup();
			UIEditManager.currEditShowContainer.cache.addInvertedGroup(g);
		}
		
		public function respondToReflashInvertedGroupListEvent(noti:Notification):void
		{
			comList.dataProvider = UIEditManager.currEditShowContainer.cache.invertedGroup_ls;
		}
		
		public function respondToCurrEditUIFileChangeEvent(noti:Notification):void
		{
			comList.dataProvider = null;
			if(UIEditManager.currEditShowContainer == null) return ;
			if(UIEditManager.currEditShowContainer.cache == null) return ;
			comList.dataProvider = UIEditManager.currEditShowContainer.cache.invertedGroup_ls;
		}
		
		
	}
}
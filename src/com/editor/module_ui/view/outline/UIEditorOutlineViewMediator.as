package com.editor.module_ui.view.outline
{
	import com.editor.component.controls.UITree;
	import com.editor.mediator.AppMediator;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.ui.UIEditCache;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.vo.UITreeNode;
	import com.sandy.asComponent.controls.ASTree;
	import com.sandy.asComponent.controls.interfac.IASTreeItemRenderer;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class UIEditorOutlineViewMediator extends AppMediator
	{
		public static const NAME:String = "UIEditorOutlineViewMediator"
		public function UIEditorOutlineViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get outlineView():UIEditorOutlineView
		{
			return viewComponent as UIEditorOutlineView;
		}
		public function get comList():UITree
		{
			return outlineView.comList;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			comList.doubleClickEnabled = true;
			comList.addEventListener(ASEvent.CHANGE,onTreeChange)
		}
		
		private function onTreeChange(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var d:UITreeNode = e.addData as UITreeNode;
				if(d.obj is UIShowCompProxy){
					UIShowCompProxy(d.obj).selectedThis();
				}
			}
		}
		
		public function respondToCurrEditUIFileChangeEvent(noti:Notification):void
		{
			respondToReflashCompOutlineEvent();	
		}
		
		public function respondToReflashCompOutlineEvent(noti:Notification=null):void
		{
			if(UIEditManager.currEditShowContainer == null || UIEditManager.currEditShowContainer.cache ==null){
				comList.dataProvider = null;
			}else{
				comList.dataProvider = UIEditManager.currEditShowContainer.cache.tree;
			}
		}
		
		public function respondToSelectUIInUIEvent(noti:Notification=null):void
		{ 
			if(UIEditManager.currEditShowContainer.selectedUI!=null){
				var ind:int = UIEditManager.currEditShowContainer.selectedUI.node.listIndex;
				if(comList.selectedIndex == ind) return ;
				var t:IASTreeItemRenderer = comList.getTreeItem(ind);
				if(comList.getSelectedTreeItem()!=null){
					ASComponent(comList.getSelectedTreeItem()).noSelect();
				}
				ASComponent(t).select();
				ASTree(comList).setSelectIndex(ind,false);
			}
		}
		
		
	}
}
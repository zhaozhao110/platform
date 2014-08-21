package com.editor.module_ui.view.uiAttri
{
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.mediator.AppMediator;
	import com.editor.module_ui.app.ui.UIEditorMediator;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.module_ui.vo.ComponentData;
	import com.sandy.component.expand.SandyReflashButton;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;
	
	public class UIEditorAttriListViewMediator extends AppMediator
	{
		public static const NAME:String = "UIEditorAttriListViewMediator"
		public function UIEditorAttriListViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get attriListView():UIEditorAttriListView
		{
			return viewComponent as UIEditorAttriListView
		}
		public function get vs():UIViewStack
		{
			return attriListView.vs;
		}
		public function get comNameLb():UILabel
		{
			return attriListView.comNameLb;
		}
		public function get createBtn():SandyReflashButton
		{
			return attriListView.createBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		private var comAttri_list:Array = [];
		
		public function respondToCurrEditUIFileChangeEvent(noti:Notification):void
		{
			respondToSelectUIInUIEvent();
		}
				
		public function respondToSelectUIInUIEvent(noti:Notification=null):void
		{
			var d:ComponentData;
			if(noti != null){
				d = noti.getBody() as ComponentData;
			}
			if(d == null){
				comNameLb.text = "系统";
				if(comAttri_list["system"] == null){
					var cell:ComAttriCell = new ComAttriCell(d);
					vs.addChild(cell);
					comAttri_list["system"] = cell;
					vs.selectedIndex = vs.getChildren().length-1;
					cell.index = vs.selectedIndex;
				}else{
					vs.selectedIndex = (comAttri_list["system"] as ComAttriCell).index;
				}
				UIEditManager.currShowUIAttri = null;
				return ;
			}
			
			if(d.checkIsInvertedGroup()){
				if(comAttri_list[d.name] == null){
					var cell2:ComInvertedGroupAttriCell = new ComInvertedGroupAttriCell();
					vs.addChild(cell2);
					comAttri_list[d.name] = cell2;
					vs.selectedIndex = vs.getChildren().length-1;
					cell2.index = vs.selectedIndex;
					(comAttri_list[d.name] as ComInvertedGroupAttriCell).reflash(d);
				}else{
					(comAttri_list[d.name] as ComInvertedGroupAttriCell).reflash(d);
					vs.selectedIndex = (comAttri_list[d.name] as ComInvertedGroupAttriCell).index;
				}
				comNameLb.text = "组件:"+d.name+"/id:"+d.invertedGroup.id;
				comNameLb.toolTip = comNameLb.text;
				UIEditManager.currShowUIAttri = null;
				return ;
			}
			
			comNameLb.text = "组件:"+d.name+"/id:"+d.target.$id+"/name:"+d.target.name;
			comNameLb.toolTip = comNameLb.text;
			
			if(comAttri_list[d.name] == null){
				cell = new ComAttriCell(d);
				vs.addChild(cell);
				comAttri_list[d.name] = cell;
				vs.selectedIndex = vs.getChildren().length-1;
				cell.index = vs.selectedIndex;
				(comAttri_list[d.name] as ComAttriCell).reflash(d);
			}else{
				(comAttri_list[d.name] as ComAttriCell).reflash(d);
				vs.selectedIndex = (comAttri_list[d.name] as ComAttriCell).index;
			}
			UIEditManager.currShowUIAttri = comAttri_list[d.name] as ComAttriCell;
		}
		
		public function respondToReflashCompOutlineEvent(noti:Notification):void
		{
			if(UIEditManager.currEditShowContainer.selectedUI!=null){
				comNameLb.text = "组件: " + UIEditManager.currEditShowContainer.selectedUI.data.name +
					"/id:"+UIEditManager.currEditShowContainer.selectedUI.target.$id+
					"/name:"+UIEditManager.currEditShowContainer.selectedUI.target.name;
				comNameLb.toolTip = comNameLb.text;
			}
		}
		
		public function reactToCreateBtnClick(e:MouseEvent):void
		{
			if(UIEditManager.currEditShowContainer == null) return ;
			if(get_UIEditorMediator().tabBar.dataProvider == null) return ;
			if((get_UIEditorMediator().tabBar.dataProvider as Array).length == 0) return ;
			var suc:Boolean = UIEditManager.currEditShowContainer.createXML.create();
			if(suc){
				UIEditManager.currEditShowContainer.createXML.createAS();
				sendAppNotification(UIEvent.save_uiEdit_event);
			}
		}
		
		private function get_UIEditorMediator():UIEditorMediator
		{
			return retrieveMediator(UIEditorMediator.NAME) as UIEditorMediator;
		}
		
	}
}
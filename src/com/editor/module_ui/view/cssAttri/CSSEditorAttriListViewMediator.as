package com.editor.module_ui.view.cssAttri
{
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.mediator.AppMediator;
	import com.editor.module_ui.css.CSSShowContainerMediator;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.component.expand.SandyReflashButton;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;
	
	public class CSSEditorAttriListViewMediator extends AppMediator
	{
		public static const NAME:String = "CSSEditorAttriListViewMediator"
		public function CSSEditorAttriListViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get attriListView():CSSEditorAttriListView
		{
			return viewComponent as CSSEditorAttriListView
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
		
		public var comAttri_list:Array = [];
		public static var currShow_cell:CSSEditorAttriCell;
		
		public function respondToOpenComAttriInCSSEvent(noti:Notification):void
		{
			var d:CSSComponentData = noti.getBody() as CSSComponentData;
			_showCompAttri(d);
		}
		
		private function _showCompAttri(d:CSSComponentData):void
		{
			if(d == null) return ;
			var cell:CSSEditorAttriCell ;
			if(getCell(d)==null){
				cell = new CSSEditorAttriCell();
				cell.selectedIndex = vs.getChildren().length;
				vs.addChild(cell);
				comAttri_list[d.name] = cell;
				cell.setComp(d);
			}else{
				cell = getCell(d);
				vs.selectedIndex = cell.selectedIndex;
			}
			currShow_cell = cell;
			comNameLb.htmlText = ColorUtils.addColorTool(d.type,ColorUtils.lime) + " 的属性列表";
			createBtn.visible = true;
		}
		
		private function getCell(d:CSSComponentData):CSSEditorAttriCell
		{
			return comAttri_list[d.name] as CSSEditorAttriCell;
		}
		
		public function respondToReflashCSSInfoEvent(noti:Notification):void
		{
			CSSShowContainerMediator.instance.reflashRender(currShow_cell.getAllList())
		}
		
		public function reactToCreateBtnClick(e:MouseEvent):void
		{
			sendAppNotification(UIEvent.reflash_cssInfo_event);
		}
		
	}
}
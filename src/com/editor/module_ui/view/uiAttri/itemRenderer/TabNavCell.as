package com.editor.module_ui.view.uiAttri.itemRenderer
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.view.uiAttri.ComToolAttriCell;
	import com.sandy.asComponent.containers.ASViewStack;
	import com.sandy.asComponent.controls.ASTabNavigator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.events.MouseEvent;

	public class TabNavCell extends UIVBox
	{
		public function TabNavCell()
		{
			super();
			
			enabledPercentSize = true;
			
			var hb:UIHBox = new UIHBox();
			hb.horizontalGap = 5;
			hb.height = 25;
			hb.percentWidth = 100;
			addChild(hb);
			
			lb = new UILabel();
			lb.height = 22;
			lb.text = "所有子tab：";
			hb.addChild(lb);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.buttonMode = true;
			addBtn.toolTip = "新建tab"
			addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			hb.addChild(addBtn);
			
			compList = new UIVBox();
			compList.styleName = "list"
			compList.width = 280;
			compList.height = 200;
			//compList.variableRowHeight = true;
			compList.itemRenderer = TabNavCellItemRenderer;
			compList.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			compList.addEventListener(ASEvent.CHILDADD,onChildHandle)
			addChild(compList);
		}
		
		private var addBtn:UIAssetsSymbol 
		private var lb:UILabel;
		private var compList:UIVBox;
		public var cell:ComToolAttriCell;
		
		private function onChildHandle(e:ASEvent):void
		{
			TabNavCellItemRenderer(e.data).cell = this;
		}
		
		public function reflash():void
		{
			if(UIEditManager.currEditShowContainer.selectedUI.target is ASTabNavigator){
				lb.text = "所有子tab："
				addBtn.toolTip = "新建tab"
			}else if(UIEditManager.currEditShowContainer.selectedUI.target is ASViewStack){
				lb.text = "所有子view："
				addBtn.toolTip = "新建view"
			}
			compList.dataProvider = UIEditManager.currEditShowContainer.selectedUI.target.getChildren();
		}
		
		private function onAdd(e:MouseEvent):void
		{
			UIEditManager.currEditShowContainer.selectedUI.tabNav_addTab();
			compList.dataProvider = UIEditManager.currEditShowContainer.selectedUI.target.getChildren();
		}
		
	}
}
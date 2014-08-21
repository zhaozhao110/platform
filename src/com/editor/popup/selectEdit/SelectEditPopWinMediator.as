package com.editor.popup.selectEdit
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	
	public class SelectEditPopWinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "SelectEditPopWinMediator"
		public function SelectEditPopWinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():SelectEditPopWin
		{
			return viewComponent as SelectEditPopWin
		}
		public function get listDG():SandyDataGrid
		{
			return createWin.listDG;
		}
		public function get tabBar():UITabBar
		{
			return createWin.tabBar;
		}
		public function get input():UITextInputWidthLabel
		{
			return createWin.input;
		}
		
		
		private var item:SelectEditPopWinVO;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			item = (getOpenDataProxy() as OpenPopwinData).data as SelectEditPopWinVO;
			
			ASDataGridColumn(listDG.columns[0]).dataField = item.column1_dataField;
			ASDataGridColumn(listDG.columns[1]).dataField = item.column2_dataField;
			
			
			tabBar.dataProvider = item.data;
			tabBar.addEventListener(ASEvent.CHANGE , onTabBarChange)
			tabBar.selectedIndex = 0;
			
			listDG.doubleClickEnabled = true;
			listDG.addEventListener(ASEvent.CHANGE , listDoubleClick)
				
			input.enterKeyDown_proxy = okBtnClick
		}
		
		private function listDoubleClick(e:ASEvent):void
		{
			if(!e.isDoubleClick) return ;
			(getOpenDataProxy() as OpenPopwinData).callBackFun(listDG.selectedItem,item);
			closeWin();
		}
		
		private function onTabBarChange(e:ASEvent):void
		{
			if(tabBar.selectedIndex >= 0){
				listDG.dataProvider = Object((item.data as Array)[tabBar.selectedIndex])[item.select_dataField];
			}
		}
		
		private function okBtnClick():void
		{
			if(findItem()!=null){
				(getOpenDataProxy() as OpenPopwinData).callBackFun(findItem(),item);
				closeWin();
			}
		}
		
		private function findItem():*
		{
			var a:Array = listDG.dataProvider as Array;
			for(var i:int=0;i<a.length;i++){
				if(Object(a[i])[item.findItemById].toString() == input.text){
					return a[i];
				}
			}
			return null;
		}
		
	}
}
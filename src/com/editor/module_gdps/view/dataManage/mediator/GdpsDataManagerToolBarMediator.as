package com.editor.module_gdps.view.dataManage.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsDataManagerToolBar;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class GdpsDataManagerToolBarMediator extends AppMediator
	{
		public static const NAME:String = "GdpsDataManagerToolBarMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsDataManagerToolBarMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get toolBar():GdpsDataManagerToolBar
		{
			return viewComponent as GdpsDataManagerToolBar;
		}
		public function get importBtn():UIButton
		{
			return toolBar.importBtn;
		}
		public function get exportBtn():UIButton
		{
			return toolBar.exportBtn;
		}
		public function get historyBtn():UIButton
		{
			return toolBar.historyBtn;
		}
		public function get comparisonBtn():UIButton
		{
			return toolBar.comparisonBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function reactToImportBtnClick(e:MouseEvent):void
		{
			menuHandler(importBtn.name);
		}
		
		public function reactToExportBtnClick(e:MouseEvent):void
		{
			menuHandler(exportBtn.name);
		}
		
		public function reactToHistoryBtnClick(e:MouseEvent):void
		{
			menuHandler(historyBtn.name);
		}
		
		public function reactToComparisonBtnClick(e:MouseEvent):void
		{
			menuHandler(comparisonBtn.name);
		}
		
		/**
		 * 点击菜单
		 */
		private function menuHandler(s:String):void
		{
			var btnName:String = s;
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = {"confItem": confItem};//参数可以增加相关请求url用于popwin的请求
			
			if (btnName == "import")
			{
				dat.popupwinSign = GDPSPopupwinSign.GdpsDataManageImportPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if (btnName == "export")
			{
				//Alert.show("导出数据excel");
			}
			else if (btnName == "history")
			{
				dat.popupwinSign = GDPSPopupwinSign.GdpsDataManageHistoryPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if (btnName == "comparison")
			{
				dat.popupwinSign = GDPSPopupwinSign.GdpsDataManageHistory2Popupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
		}
		
		private function get dataGridMediator():GdpsDataManagerDataGridMediator
		{
			return retrieveMediator(GdpsDataManagerDataGridMediator.NAME + confItem.menuId) as GdpsDataManagerDataGridMediator;
		}
	}
}
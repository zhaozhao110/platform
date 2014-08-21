package com.editor.module_gdps.pop.tableSpaceCreate
{
	import com.editor.component.controls.UIButton;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.pop.left.GdpsLeftContainerMediator;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.view.tableSpace.mediator.GdpsTabSpaceDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.math.HashMap;
	
	import flash.events.MouseEvent;

	public class GdpsTableSpaceCreatePopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsTableSpaceCreatePopupwinMediator";
		
		public function GdpsTableSpaceCreatePopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get tableWin():GdpsTableSpaceCreatePopupwin
		{
			return viewComponent as GdpsTableSpaceCreatePopupwin;
		}
		public function get saveTableBtn():UIButton
		{
			return tableWin.saveTableBtn;
		}
		public function get resetTableBtn():UIButton
		{
			return tableWin.resetTableBtn;
		}
		
		private var menuId:Number;
		private var btnName:String;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var dat:Object = OpenPopwinData(tableWin.item).data;
			var confItem:AppModuleConfItem = dat.confItem;
			btnName = dat.btnName;
			menuId = confItem.menuId;
			if(menuId < 0)
			{
				showError("缺少必要参数menuId");
			}
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			resetForm();
		}
		
		public function reactToSaveTableBtnClick(evt:MouseEvent):void
		{
			if(tableWin.content.text == "")
			{
				showError("PD语句不能为空");
				return;
			}
			if(tableWin.menuName.text == "")
			{
				showError("生成的菜单名称不能为空");
				return;
			}
			//添加表单参数
			var formMap:HashMap = new HashMap();
			formMap.put("menuId", menuId);
			formMap.put("content", tableWin.content.text);
			
			formMap.put("menuName", tableWin.menuName.text);
			formMap.put("path", tableWin.path.text);
			formMap.put("configFilename", tableWin.configFilename.text);
			//formMap.put("sqlFilename", tableWin.sqlFilename.text);
			formMap.put("zipFilename", tableWin.zipFilename.text);
			
			sendNotification(GDPSAppEvent.showLoadingProgressBarGdps_event,"保存中，请稍等......");
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formMap.getContent();
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.getCreateTableData_url,  "POST");
			
			closeWin();
		}
		
		private function faultHandlerCallBack(a:*):void
		{
			sendNotification(GDPSAppEvent.hideLoadingProgressBarGdps_event);
			showError("保存失败|" + a.msg);
		}
		
		private function saveHandlerCallBack(a:*):void
		{
			sendNotification(GDPSAppEvent.hideLoadingProgressBarGdps_event);
			showMessage("保存成功!");
			leftMediator().reflashTreeList();
			dataGridMediator.findTableSpaceDataByPage(dataGridMediator.tableSpace_page_bar.pageNo, 20, null);
		}
		
		private function leftMediator():GdpsLeftContainerMediator
		{
			return retrieveMediator(GdpsLeftContainerMediator.NAME) as GdpsLeftContainerMediator;
		}
		
		public function reactToResetTableBtnClick(evt:MouseEvent):void
		{
			resetForm();
		}
		
		private function resetForm():void
		{
			tableWin.content.text = "";
			tableWin.menuName.text = "";
			tableWin.path.text = "";
			tableWin.configFilename.text = "";
			tableWin.zipFilename.text = "";
		}
		
		private function get dataGridMediator():GdpsTabSpaceDataGridMediator
		{
			return retrieveMediator(GdpsTabSpaceDataGridMediator.NAME + menuId) as GdpsTabSpaceDataGridMediator;
		}
	}
}
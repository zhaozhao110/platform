package com.editor.module_gdps.view.publishRes.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsPublishResToolBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class GdpsPublishResToolBarMeidator extends AppMediator
	{
		public static const NAME:String = "GdpsPublishResToolBarMeidator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsPublishResToolBarMeidator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get toolBar():GdpsPublishResToolBar
		{
			return viewComponent as GdpsPublishResToolBar;
		}
		public function get addBtn():UIButton
		{
			return toolBar.addBtn;
		}
		public function get updateBtn():UIButton
		{
			return toolBar.updateBtn;
		}
		public function get deleteBtn():UIButton
		{
			return toolBar.deleteBtn;
		}
		public function get auditBtn():UIButton
		{
			return toolBar.auditBtn;
		}
		public function get publishBtn():UIButton
		{
			return toolBar.publishBtn;
		}
		public function get svnSubmitBtn():UIButton
		{
			return toolBar.svnSubmitBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function reactToAddBtnClick(e:MouseEvent):void
		{
			menuHandler(addBtn.name);
		}
		
		public function reactToUpdateBtnClick(e:MouseEvent):void
		{
			menuHandler(updateBtn.name);
		}
		
		public function reactToDeleteBtnClick(e:MouseEvent):void
		{
			menuHandler(deleteBtn.name);
		}
		
		public function reactToAuditBtnClick(e:MouseEvent):void
		{
			menuHandler(auditBtn.name);
		}
		
		public function reactToPublishBtnClick(e:MouseEvent):void
		{
			menuHandler(publishBtn.name);
		}
		
		public function reactToSvnSubmitBtnClick(e:MouseEvent):void
		{
			menuHandler(svnSubmitBtn.name);
		}
		
		private function menuHandler(s:String):void
		{
			var btnName:String = s;
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = { "btnName": btnName, "confItem": confItem }; //参数可以增加相关请求url用于popwin的请求
			
			if (btnName == "add" || btnName == "update")
			{
				if (btnName == "update" && showMsg("1"))
				{
					return;
				}
				dat.popupwinSign = GDPSPopupwinSign.GdpsResSavePopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if (btnName == "delete")
			{
				if(showMsg("1"))
				{
					return;
				}
				var mes:OpenMessageData = new OpenMessageData();
				mes.info = "您确认需要删除当前RES资源批次吗？";
				mes.okFunction = successFunc;
				mes.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
				showConfirm(mes);
			}
			else if (btnName == "audit")
			{
				if(showMsg("1"))
				{
					return;
				}
				var mes1:OpenMessageData = new OpenMessageData();
				mes1.info = "您确认需要审核通过吗？";
				mes1.okFunction = successAuditFunc;
				mes1.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
				showConfirm(mes1);
			}
			else if (btnName == "publish")
			{
				if(showMsg("3"))//3.已打包，未发布状态
				{
					return;
				}
				dat.popupwinSign = GDPSPopupwinSign.GdpsResPublishPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if (btnName == "svnSubmit") {
				
				var mes2:OpenMessageData = new OpenMessageData();
				mes2.info = "您确认需要提交SVN代码吗？";
				mes2.okFunction = successSvnSubmitFunc;
				mes2.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
				showConfirm(mes2);
			}
		}
		
		private function successSvnSubmitFunc():Boolean
		{
			//后台SVN提交操作
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "type": "R" };
			http.sucResult_f = deleteSuccessHandlerCallBack;
			http.fault_f = deleteFaultHandlerCallBack;
			http.conn(GDPSServices.getSvnSubmit_url, "POST");
			return true;
		}
		
		private function successAuditFunc():Boolean
		{
			var grid3:SandyDataGrid = dataGridMediator.packaging_grid;
			//后台删除操作
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": grid3.selectedItem.SBid };
			http.sucResult_f = deleteSuccessHandlerCallBack;
			http.fault_f = deleteFaultHandlerCallBack;
			http.conn(GDPSServices.getAuditBatchRecordData_url,"POST" );
			return true;
		}
		
		private function successFunc():Boolean
		{
			var grid3:SandyDataGrid = dataGridMediator.packaging_grid;
			//后台删除操作
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": grid3.selectedItem.SBid };
			http.sucResult_f = deleteSuccessHandlerCallBack;
			http.fault_f = deleteFaultHandlerCallBack;
			http.conn(GDPSServices.getDeleteBatchRecordData_url,"POST" );
			return true;
		}
		
		private function deleteFaultHandlerCallBack():void
		{
			showError("操作失败");
		}
		
		private function deleteSuccessHandlerCallBack(a:*):void
		{
			showError("操作成功");
			dataGridMediator.findPackagingDataByPage(dataGridMediator.packaging_page_bar.pageNo, 20, null);
		}
		
		private function showMsg(state:String=""):Boolean
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			if (grid.selectedItem == null || grid.selectedItem.SBid == null)
			{
				showError("请先选择一条记录！");
				return true;
			}
			
			/*if(state != "" && state != grid.selectedItem.SState)
			{
			Alert.show("当前状态下不可进行此操作！", "提示");
			return true;
			}*/
			return false;
		}
		
		private function get dataGridMediator():GdpsPublishResDataGridMediator
		{
			return retrieveMediator(GdpsPublishResDataGridMediator.NAME + confItem.menuId) as GdpsPublishResDataGridMediator;
		}
	}
}
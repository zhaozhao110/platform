package com.editor.module_gdps.view.packaging.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsPackagingToolBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class GdpsPackagingToolBarMediator extends AppMediator
	{
		public static const NAME:String = "GdpsPackagingToolBarMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsPackagingToolBarMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get toolBar():GdpsPackagingToolBar
		{
			return viewComponent as GdpsPackagingToolBar;
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
		public function get cloneBtn():UIButton
		{
			return toolBar.cloneBtn;
		}
		public function get detailBtn():UIButton
		{
			return toolBar.detailBtn;
		}
		public function get detectBtn():UIButton
		{
			return toolBar.detectBtn;
		}
		public function get packagingBtn():UIButton
		{
			return toolBar.packagingBtn;
		}
		public function get publishBtn():UIButton
		{
			return toolBar.publishBtn;
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
		
		public function reactToCloneBtnClick(e:MouseEvent):void
		{
			menuHandler(cloneBtn.name);
		}
		
		public function reactToDetailBtnClick(e:MouseEvent):void
		{
			menuHandler(detailBtn.name);
		}
		
		public function reactToDetectBtnClick(e:MouseEvent):void
		{
			menuHandler(detectBtn.name);
		}
		
		public function reactToPackagingBtnClick(e:MouseEvent):void
		{
			menuHandler(packagingBtn.name);
		}
		
		public function reactToPublishBtnClick(e:MouseEvent):void
		{
			menuHandler(publishBtn.name);
		}
		
		private function menuHandler(s:String):void
		{
			var btnName:String = s
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = { "btnName": btnName, "confItem": confItem }; //参数可以增加相关请求url用于popwin的请求
			
			if (btnName == "add" || btnName == "update")
			{
				if (btnName == "update" && showMsg("1"))
				{
					return;
				}
				dat.popupwinSign = GDPSPopupwinSign.GdpsPublishSavePopupwin_sign;
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
				mes.info = "删除操作会同时删除当前批次的明细记录，您确认需要删除吗？";
				mes.okFunction = successFunc;
				mes.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
				showConfirm(mes);
			}
			else if (btnName == "detail")
			{
				if(showMsg("1"))
				{
					return;
				}
				dat.popupwinSign = GDPSPopupwinSign.GdpsPackageDetailPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if (btnName == "detect")
			{
				if(showMsg("1"))//1.未检测状态
				{
					return;
				}
				dat.popupwinSign = GDPSPopupwinSign.GdpsPackageDetectPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if (btnName == "packaging")
			{
				if(showMsg("2"))//2.已检测，未打包状态
				{
					return;
				}
				dat.popupwinSign = GDPSPopupwinSign.GdpsPackagePackingPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if (btnName == "publish")
			{
				if(showMsg("3"))//3.已打包，未发布状态
				{
					return;
				}
				dat.popupwinSign = GDPSPopupwinSign.GdpsPackagePublishPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if (btnName == "clone")
			{
				if(showMsg(""))
				{
					return;
				}
				
				var mes1:OpenMessageData = new OpenMessageData();
				mes1.info = "该操作会同时复制当前批次的明细记录，您确定执行吗？";
				mes1.okFunction = successCloneFunc;
				mes1.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
				showConfirm(mes1);
			}
		}
		
		/**
		 * 克隆操作执行方法
		 */
		private function successCloneFunc():Boolean
		{
			var grid3:SandyDataGrid = dataGridMediator.packaging_grid;
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": grid3.selectedItem.SBid };
			http.sucResult_f = deleteSuccessHandlerCallBack;
			http.fault_f = deleteFaultHandlerCallBack;
			http.conn(GDPSServices.getCloneBatchRecordData_url, "POST");
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
			http.conn(GDPSServices.getDeleteBatchRecordData_url,"POST");
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
		
		private function get dataGridMediator():GdpsPackagingDataGridMediator
		{
			return retrieveMediator(GdpsPackagingDataGridMediator.NAME + confItem.menuId) as GdpsPackagingDataGridMediator;
		}
	}
}
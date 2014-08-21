package com.editor.module_gdps.pop.clientSave
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILinkButton;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.view.publishClient.mediator.GdpsPublishClientDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.MouseEvent;

	public class GdpsClientSavePopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsClientSavePopupwinMediator";
		
		public function GdpsClientSavePopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get saveWin():GdpsClientSavePopupwin
		{
			return viewComponent as GdpsClientSavePopupwin;
		}
		public function get saveBtn():UIButton
		{
			return saveWin.saveBtn;
		}
		public function get resetBtn():UIButton
		{
			return saveWin.resetBtn;
		}
		public function get form():UIForm
		{
			return saveWin.form;
		}
		public function get svnBtn():UILinkButton
		{
			return saveWin.svnBtn;
		}

		private var menuId:Number;
		private var btnName:String;
		private var confItem:AppModuleConfItem;
		
		private function get dataGridMediator():GdpsPublishClientDataGridMediator
		{
			return retrieveMediator(GdpsPublishClientDataGridMediator.NAME + menuId) as GdpsPublishClientDataGridMediator;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var dat:* = OpenPopwinData(saveWin.item).data;
			confItem = dat.confItem;
			btnName = dat.btnName;
			menuId = confItem.menuId;
			if (menuId < 0)
			{
				showError("缺少必要参数menuId");
			}
			
			initForm(btnName);
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			saveWin.SBid.editable = true;
			resetForm();
		}
		
		private function resetForm():void
		{
			saveWin.SBid.text = "";
			saveWin.STopic.text = "";
			saveWin.SDesc.text = "";
			saveWin.client_svn_version.text = "";
		}
		
		/**
		 * 初始化表单数据
		 *
		 * @param btnName
		 */
		private function initForm(btnName:String):void
		{
			
			if (btnName == "update")
			{
				saveWin.title = "修改客户端数据更新批次号"
				saveWin.SBid.editable = false;
				
				var grid:SandyDataGrid = dataGridMediator.packaging_grid;
				var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
				http.args2 = { "menuId": menuId, "SBid": grid.selectedItem.SBid };
				http.sucResult_f = showColumnDataCallBack;
				http.conn(GDPSServices.getBatchRecord_url);
			}
			else
			{
				saveWin.title = "添加客户端数据更新批次号"
				saveWin.SBid.editable = true;
				
				var formatString:String = "yyyymmddHHnnss";
				saveWin.SBid.text = TimerUtils.getFromatTime(TimerUtils.getCurrentTime() / 1000 , formatString);
			}
		}
		
		public function reactToSvnBtnClick(event:MouseEvent):void
		{
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = { "type" : "C", "source" : GDPSDataManager.client_data_type };
			dat.popupwinSign = GDPSPopupwinSign.GdpsPublishSvnLogPopupwin_sign;
			dat.openByAirData = new OpenPopByAirOptions();
			openPopupwin(dat);
		}
		
		/**
		 * 修改按钮 显示表单数据回调方法
		 */
		private function showColumnDataCallBack(a:*):void
		{
			var columns:Array = a.data; //服务端的ColumnNameDefine对象
			saveWin.SBid.text = columns[0].SBid;
			saveWin.STopic.text = columns[0].STopic;
			saveWin.SDesc.text = columns[0].SDesc;
			saveWin.client_svn_version.text = columns[0].NClientRevision;
		}
		
		public function reactToSaveBtnClick(evt:MouseEvent):void
		{
			if(saveWin.SBid.text == ""){
				showError("请填写批次号");
				return;
			}
			if(saveWin.client_svn_version.text == ""){
				showError("资源SVN版本号不能为空！");
				return;
			}
			if(saveWin.STopic.text == ""){
				showError("请填写批次标题");
				return;
			}
			if(saveWin.SDesc.text == ""){
				showError("请填写更新内容描述");
				return;
			}
			//添加表单参数
			var formValues:Object = {};
			formValues.menuId = menuId;
			formValues.SBid = saveWin.SBid.text;
			formValues.STopic = saveWin.STopic.text;
			formValues.SScope = GDPSDataManager.client_data_type;
			formValues.SDesc = saveWin.SDesc.text;
			formValues.NClientRevision = saveWin.client_svn_version.text;
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formValues;
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.getSaveBatchRecord_url);
		}
		
		private function faultHandlerCallBack(a:*):void
		{
			showError("保存失败|" + a.msg);
		}
		
		private function saveHandlerCallBack(a:*):void
		{
			showError("保存成功!");
			dataGridMediator.findPackagingDataByPage(dataGridMediator.packaging_page_bar.pageNo, 20, null);
			closeWin();
		}
		
		public function reactToResetBtnClick(evt:MouseEvent):void
		{
			resetForm();
		}
	}
}
package com.editor.module_gdps.pop.productManageAdd
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.view.productManage.mediator.GdpsProductManagerDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.events.MouseEvent;

	public class GdpsProductManagePopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsProductManagePopupwinMediator";
		
		public function GdpsProductManagePopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get productWin():GdpsProductManagePopupwin
		{
			return viewComponent as GdpsProductManagePopupwin;
		}
		public function get SNameTxt():UITextInput
		{
			return productWin.SName;
		}
		public function get NGidTxt():UITextInput
		{
			return productWin.NGidTxt;
		}
		public function get SSvnNameTxt():UITextInput
		{
			return productWin.SSvnNameTxt;
		}
		public function get STypeCb():UICombobox
		{
			return productWin.STypeCb;
		}
		public function get statusCb():UICombobox
		{
			return productWin.statusCb;
		}
		public function get SAliasTxt():UITextInput
		{
			return productWin.SAliasTxt;
		}
		public function get SSvnPwdTxt():UITextInput
		{
			return productWin.SSvnPwdTxt;
		}
		public function get clientTxt():UITextInput
		{
			return productWin.clientTxt;
		}
		public function get serverTxt():UITextInput
		{
			return productWin.serverTxt;
		}
		public function get resTxt():UITextInput
		{
			return productWin.resTxt;
		}
		public function get descTxt():UITextArea
		{
			return productWin.descTxt;
		}
		public function get saveBtn():UIButton
		{
			return productWin.saveBtn;
		}
		public function get closeBtn():UIButton
		{
			return productWin.closeBtn;
		}
		public function get resetBtn():UIButton
		{
			return productWin.resetBtn;
		}
		
		private var popType:String;
		private var confItem:AppModuleConfItem;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var data:Object = OpenPopwinData(productWin.item).data;
			popType = data.btnName;
			confItem = data.confItem;
			
			initView();
		}
		
		private function initView():void
		{
			if(popType == "add"){
				
				productWin.title = "添加项目";
				resetView();
				
			}else if(popType == "modify"){
				
				productWin.title = "修改项目信息";
				reflashView();
			}
		}
		
		public function reactToCloseBtnClick(e:MouseEvent):void
		{
			closeWin();
		}
		
		public function reactToResetBtnClick(e:MouseEvent):void
		{
			resetView();
		}
		
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			if(SNameTxt.text == ""){
				showError("请填写项目名称！");
				return;
			}
			if(SAliasTxt.text == ""){
				showError("请填写项目别名！");
				return;
			}
			if(NGidTxt.text == ""){
				showError("请填写所属游戏ID！");
				return;
			}
			
			var formValues:Object = {};
			formValues.menuId = confItem.menuId;
			formValues.SName = SNameTxt.text;
			formValues.SAlias = SAliasTxt.text;
			formValues.NGid = NGidTxt.text;
			formValues.SClient = clientTxt.text;
			formValues.SServer = serverTxt.text;
			formValues.SRes = resTxt.text;
			formValues.SSvnName = SSvnNameTxt.text;
			formValues.SDesc = descTxt.text;
			formValues.SType = STypeCb.selectedItem.value;
			formValues.SState = statusCb.selectedItem.value;
			formValues.SSvnPwd = SSvnPwdTxt.text;
			if(popType == "modify"){
				var dg:SandyDataGrid = dataGridMediator().list;
				formValues.NId = dg.selectedItem.NId;
			}
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formValues;
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.getProductMamangeSave_url, "POST");
		}
		
		private function faultHandlerCallBack(a:*):void
		{
			showError("保存失败|" + a.msg);
		}
		
		private function saveHandlerCallBack(a:*):void
		{
			showError("保存成功!");
			dataGridMediator().findTableSpaceDataByPage(dataGridMediator().pageBar.pageNo, 20, null);
			closeWin();
		}
		
		private function resetView():void
		{
			SNameTxt.text = "";
			SSvnNameTxt.text = "";
			SAliasTxt.text = "";
			SSvnPwdTxt.text = "";
			descTxt.text = "";
			clientTxt.text = "";
			serverTxt.text = "";
			resTxt.text = "";
			NGidTxt.text = "";
		}
		
		private function reflashView():void
		{
			var dg:SandyDataGrid = dataGridMediator().list;
			var item:Object = dg.selectedItem;
			SNameTxt.text = item.SName;
			SAliasTxt.text = item.SAlias;
			clientTxt.text = item.SClient;
			serverTxt.text = item.SServer;
			resTxt.text = item.SRes;
			SSvnNameTxt.text = item.SSvnName;
			descTxt.text = item.SDesc;
			SSvnPwdTxt.text = item.SSvnPwd;
			NGidTxt.text = item.NGid;
			statusCb.selectedIndex = int(item.SState);
			
			var type:int = int(item.SType);
			var arr:Array = STypeCb.dataProvider;
			if(arr != null){
				for each(var item2:Object in arr)
				{
					if(item2.value == type){
						STypeCb.selectedItem = item2;
					}
				}
				if(STypeCb.selectedItem == null){
					STypeCb.selectedIndex = 0;
				}
			}
		}
		
		private function dataGridMediator():GdpsProductManagerDataGridMediator
		{
			return retrieveMediator(GdpsProductManagerDataGridMediator.NAME + confItem.menuId) as GdpsProductManagerDataGridMediator;
		}
	}
}
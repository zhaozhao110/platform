package com.editor.module_gdps.pop.userManageAdd
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.view.userManage.mediator.GdpsUserManagerDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.events.MouseEvent;

	public class GdpsUserManageAddPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsUserManageAddPopupwinMediator";
		
		public function GdpsUserManageAddPopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get userWin():GdpsUserManageAddPopupwin
		{
			return viewComponent as GdpsUserManageAddPopupwin;
		}
		public function get loginCodeTxt():UITextInput
		{
			return userWin.loginCodeTxt;
		}
		public function get passwdTxt():UITextInput
		{
			return userWin.passwdTxt;
		}
		public function get sexCb():UICombobox
		{
			return userWin.sexCb;
		}
		public function get statusCb():UICombobox
		{
			return userWin.statusCb;
		}
		public function get restrictedTime1():UITextInput
		{
			return userWin.restrictedTime1;
		}
		public function get restrictedTime2():UITextInput
		{
			return userWin.restrictedTime2;
		}
		public function get departmentTxt():UITextInput
		{
			return userWin.departmentTxt;
		}
		public function get issuerIdTxt():UITextInput
		{
			return userWin.issuerIdTxt;
		}
		public function get realNameTxt():UITextInput
		{
			return userWin.realNameTxt;
		}
		public function get surePasswdTxt():UITextInput
		{
			return userWin.surePasswdTxt;
		}
		public function get telTxt():UITextInput
		{
			return userWin.telTxt;
		}
		public function get emailTxt():UITextInput
		{
			return userWin.emailTxt;
		}
		public function get descTxt():UITextArea
		{
			return userWin.descTxt;
		}
		public function get saveBtn():UIButton
		{
			return userWin.saveBtn;
		}
		public function get resetBtn():UIButton
		{
			return userWin.resetBtn;
		}
		public function get closeBtn():UIButton
		{
			return userWin.closeBtn;
		}
		
		private var popType:String;
		private var confItem:AppModuleConfItem;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var data:Object = OpenPopwinData(userWin.item).data;
			popType = data.btnName;
			confItem = data.confItem;
			
			initView();
		}
		
		private function initView():void
		{
			if(popType == "add"){
				
				loginCodeTxt.enabled = true;
				userWin.title = "添加用户";
				resetView();
				
			}else if(popType == "modify"){
				
				loginCodeTxt.enabled = false;
				userWin.title = "修改用户信息";
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
			if(loginCodeTxt.text == ""){
				showError("请填写登陆帐号！");
				return;
			}
			if(realNameTxt.text == ""){
				showError("请填写真实姓名！");
				return;
			}
			if(passwdTxt.text == ""){
				showError("请填写登陆密码！");
				return;
			}
			if(surePasswdTxt.text == ""){
				showError("请确认登陆密码！");
				return;
			}
			if(passwdTxt.text != surePasswdTxt.text){
				showError("两次输入的密码不一致！");
				return;
			}
			
			var formValues:Object = {};
			formValues.menuId = confItem.menuId;
			formValues.SLoginCode = loginCodeTxt.text;
			formValues.SPasswd = passwdTxt.text;
			formValues.SDepartment = departmentTxt.text;
			formValues.NIssuerId = issuerIdTxt.text;
			formValues.SRealName = realNameTxt.text;
			formValues.STel = telTxt.text;
			formValues.SEmail = emailTxt.text;
			formValues.SDesc = descTxt.text;
			formValues.SSex = sexCb.selectedItem.value;
			formValues.SStatus = statusCb.selectedItem.value;
			formValues.SRestrictedTime = restrictedTime1.text + "-" + restrictedTime2.text;
			if(popType == "modify"){
				var dg:SandyDataGrid = dataGridMediator().list;
				formValues.NId = dg.selectedItem.NId;
			}
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formValues;
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.getUserMamangeSave_url, "POST");
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
			restrictedTime1.text = "";
			restrictedTime2.text = "";
			passwdTxt.text = "";
			departmentTxt.text = "";
			issuerIdTxt.text = "";
			realNameTxt.text = "";
			surePasswdTxt.text = "";
			telTxt.text = "";
			emailTxt.text = "";
			descTxt.text = "";
		}
		
		private function reflashView():void
		{
			var dg:SandyDataGrid = dataGridMediator().list;
			var item:Object = dg.selectedItem;
			loginCodeTxt.text = item.SLoginCode;
			passwdTxt.text = item.SPasswd;
			departmentTxt.text = item.SDepartment;
			issuerIdTxt.text = item.NIssuerId;
			realNameTxt.text = item.SRealName;
			surePasswdTxt.text = item.SPasswd;
			telTxt.text = item.STel;
			emailTxt.text = item.SEmail;
			descTxt.text = item.SDesc;
			
			var a:Array = String(item.SRestrictedTime).split("-");
			restrictedTime1.text = a[0] || "";
			restrictedTime2.text = a[1] || "";
			
			sexCb.selectedIndex = int(item.SSex);
			statusCb.selectedIndex = int(item.SStatus);
		}
		
		private function dataGridMediator():GdpsUserManagerDataGridMediator
		{
			return retrieveMediator(GdpsUserManagerDataGridMediator.NAME + confItem.menuId) as GdpsUserManagerDataGridMediator;
		}
	}
}
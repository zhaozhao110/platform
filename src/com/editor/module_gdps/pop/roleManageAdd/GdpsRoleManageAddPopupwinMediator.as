package com.editor.module_gdps.pop.roleManageAdd
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.view.roleManage.mediator.GdpsRoleManagerDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.events.MouseEvent;

	public class GdpsRoleManageAddPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsRoleManageAddPopupwinMediator";
		
		public function GdpsRoleManageAddPopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get roleWin():GdpsRoleManageAddPopupwin
		{
			return viewComponent as GdpsRoleManageAddPopupwin;
		}
		public function get nameTxt():UITextInput
		{
			return roleWin.nameTxt;
		}
		public function get descTxt():UITextArea
		{
			return roleWin.descTxt;
		}
		public function get saveBtn():UIButton
		{
			return roleWin.saveBtn;
		}
		public function get closeBtn():UIButton
		{
			return roleWin.closeBtn;
		}
		public function get resetBtn():UIButton
		{
			return roleWin.resetBtn;
		}
		
		private var popType:String;
		private var confItem:AppModuleConfItem;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var data:Object = OpenPopwinData(roleWin.item).data;
			popType = data.btnName;
			confItem = data.confItem;
			
			initView();
		}
		
		private function initView():void
		{
			if(popType == "add"){
				
				roleWin.title = "添加角色";
				resetView();
				
			}else if(popType == "modify"){
				
				roleWin.title = "修改角色信息";
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
			if(nameTxt.text == ""){
				showError("请填写角色名称！");
				return;
			}
			
			var formValues:Object = {};
			formValues.menuId = confItem.menuId;
			formValues.SName = nameTxt.text;
			formValues.SDesc = descTxt.text;
			if(popType == "modify"){
				var dg:SandyDataGrid = dataGridMediator().list;
				formValues.NId = dg.selectedItem.NId;
			}
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formValues;
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.getRoleMamangeSave_url, "POST");
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
			nameTxt.text = "";
			descTxt.text = "";
		}
		
		private function reflashView():void
		{
			var dg:SandyDataGrid = dataGridMediator().list;
			var item:Object = dg.selectedItem;
			nameTxt.text = item.SName;
			descTxt.text = item.SDesc;
		}
		
		private function dataGridMediator():GdpsRoleManagerDataGridMediator
		{
			return retrieveMediator(GdpsRoleManagerDataGridMediator.NAME + confItem.menuId) as GdpsRoleManagerDataGridMediator;
		}
	}
}
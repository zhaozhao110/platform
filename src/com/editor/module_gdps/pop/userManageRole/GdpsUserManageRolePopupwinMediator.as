package com.editor.module_gdps.pop.userManageRole
{
	import com.editor.component.containers.UITile;
	import com.editor.component.controls.UIButton;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.view.userManage.mediator.GdpsUserManagerDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.common.lang.ObjectUtils;
	
	import flash.events.MouseEvent;

	public class GdpsUserManageRolePopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsUserManageRolePopupwinMediator";
		
		public function GdpsUserManageRolePopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get userWin():GdpsUserManageRolePopupwin
		{
			return viewComponent as GdpsUserManageRolePopupwin;
		}
		public function get tile():UITile
		{
			return userWin.tile;
		}
		public function get saveBtn():UIButton
		{
			return userWin.saveBtn;
		}
		public function get cancelBtn():UIButton
		{
			return userWin.cancelBtn;
		}
		
		private function dataGridMediator():GdpsUserManagerDataGridMediator
		{
			return retrieveMediator(GdpsUserManagerDataGridMediator.NAME + confItem.menuId) as GdpsUserManagerDataGridMediator;
		}
		
		private var confItem:AppModuleConfItem;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var vo:Object = OpenPopwinData(userWin.item).data;
			confItem = vo.confItem;
			
			queryList();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			oldData = null;
			tile.dataProvider = null;
		}
		
		private function queryList():void
		{
			var vo:Object = dataGridMediator().list.selectedItem;
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = {NId:vo.NId};
			http.sucResult_f = showRoleList;
			http.conn(GDPSServices.getUserMamangeRoles_url, "POST");
		}
		
		private var oldData:Array;
		
		private function showRoleList(a:*):void
		{
			var value:Array = a.data;
			oldData = ObjectUtils.clone(value);
			tile.dataProvider = value;
		}
		
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			var list:Array = getSelectList();
			var del:Array = [];
			var addData:Array = [];
			
			for(var i:int = 0 , len:int = oldData.length; i < len; i++)
			{
				var obj:Object = oldData[i];
				if(obj.checked && list.indexOf(obj.NId) == -1){
					del.push(obj.NId);
				}
				else if(!obj.checked && list.indexOf(obj.NId) != -1){
					addData.push(obj.NId);
				}
			}
			
			if(del.length == 0 && addData.length == 0){
				showError("请选择要绑定的角色!");
				return;
			}
			
			var vo:Object = dataGridMediator().list.selectedItem;
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = {"NId":vo.NId , "del":del.join(","), "add":addData.join(",")};
			http.sucResult_f = saveSuccess;
			http.conn(GDPSServices.getUserManageSaveRole_url, "POST");
		}
		
		private function saveSuccess(a:*):void
		{
			showMessage("保存成功");
			closeWin();
		}
		
		private function getSelectList():Array
		{
			var out:Array = [];
			var len:int = tile.numChildren;
			for(var i:int = 0 ;i < len ;i++)
			{
				var render:GdpsUserManageRoleRenderer = tile.getChildAt(i) as GdpsUserManageRoleRenderer;
				var obj:Object = render.getData();
				if(obj.checked){
					out.push(obj.NId);
				}
			}
			return out;
		}
		
		public function reactToCancelBtnClick(e:MouseEvent):void
		{
			closeWin();
		}
	}
}
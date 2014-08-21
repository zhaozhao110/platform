package com.editor.module_gdps.pop.roleManageUser
{
	import com.editor.component.controls.UILinkButton;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.view.roleManage.mediator.GdpsRoleManagerDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.events.MouseEvent;

	public class GdpsRoleManageUserPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsRoleManageUserPopupwinMediator";
		
		public function GdpsRoleManageUserPopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get roleWin():GdpsRoleManageUserPopupwin
		{
			return viewComponent as GdpsRoleManageUserPopupwin;
		}
		public function get reflashBtn():UILinkButton
		{
			return roleWin.reflashBtn;
		}
		public function get list():SandyDataGrid
		{
			return roleWin.list;
		}
		
		private function dataGridMedi():GdpsRoleManagerDataGridMediator
		{
			return retrieveMediator(GdpsRoleManagerDataGridMediator.NAME + confItem.menuId ) as GdpsRoleManagerDataGridMediator;
		}
		
		private var confItem:AppModuleConfItem;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var data:Object = OpenPopwinData(roleWin.item).data;
			confItem = data.confItem;
			
			showDataGridColumn();
		}
		
		public function reactToReflashBtnClick(e:MouseEvent):void
		{
			findTableSpaceDataByPage();
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn():void
		{
			var cols:Array = list.columns || [];
			var dg:ASDataGridColumn = new ASDataGridColumn();
			dg.headerText = "Row#";
			dg.columnWidth = 40;
			dg.labelFunction = lfRowNum;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "NId";
			dg.headerText = "用户ID";
			dg.columnWidth = 80;
			dg.sortable = true;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SLoginCode";
			dg.headerText = "登陆帐号";
			dg.columnWidth = 120;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SRealName";
			dg.headerText = "真实姓名";
			dg.columnWidth = 120;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SSex";
			dg.headerText = "性别";
			dg.columnWidth = 60;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "STel";
			dg.headerText = "联系电话";
			dg.columnWidth = 100;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SEmail";
			dg.headerText = "邮箱";
			dg.columnWidth = 120;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SDepartment";
			dg.headerText = "所在部门";
			dg.columnWidth = 120;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SStatus";
			dg.headerText = "状态";
			dg.columnWidth = 80;
			cols.push(dg);
			
			list.columns = cols;
			
			findTableSpaceDataByPage();
		}
		
		/**
		 * 创建行索引
		 *
		 * @param oItem
		 * @param iCol
		 * @return
		 */
		private function lfRowNum(oItem:Object, iCol:int = 0):String
		{
			var len:int = list.dataProvider.length;
			var index:int = 0;
			for(var i:int = 0 ;i < len ;i++)
			{
				var obj:Object = list.dataProvider[i] as Object;
				if(obj == oItem){
					index = i;
					break;
				}
			}
			var iIndex:int = index + 1;
			return iIndex.toString();
		}
		
		/**
		 * 从服务器端加载表数据
		 */
		public function findTableSpaceDataByPage():void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = {"NRoleId":dataGridMedi().list.selectedItem.NId};
			http.sucResult_f = showTableSpaceData;
			
			var url:String = GDPSServices.getRoleMamangeGet_url ;
			http.conn(url, "POST");
		}
		
		private function showTableSpaceData(a:*):void
		{
			var value:* = a;
			list.dataProvider = value.data;
		}
	}
}
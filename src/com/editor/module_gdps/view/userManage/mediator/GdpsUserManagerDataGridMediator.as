package com.editor.module_gdps.view.userManage.mediator
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;

	public class GdpsUserManagerDataGridMediator extends AppMediator
	{
		public static const NAME:String = "GdpsUserManagerDataGridMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsUserManagerDataGridMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME+ _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get dataGridContainer():GdpsModuleDataGrid
		{
			return viewComponent as GdpsModuleDataGrid;
		}
		public function get list():SandyDataGrid
		{
			return dataGridContainer.tableSpace_grid;
		}
		public function get pageBar():GdpsPageBar
		{
			return dataGridContainer.tableSpace_page_bar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			pageBar.pageNoChangeFun = onPageChange;
			showDataGridColumn();
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
			dg.dataField = "SPasswd";
			dg.headerText = "登陆密码";
			dg.columnWidth = 100;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SRealName";
			dg.headerText = "真实姓名";
			dg.columnWidth = 120;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SSex";
			dg.headerText = "性别";
			dg.columnWidth = 80;
			dg.labelFunction = sexLabel;
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
			dg.columnWidth = 100;
			dg.labelFunction = statusLabel;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "DCreate";
			dg.headerText = "创建时间";
			dg.columnWidth = 140;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "DModify";
			dg.headerText = "最后修改时间";
			dg.columnWidth = 140;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SDesc";
			dg.headerText = "其他描述";
			dg.columnWidth = 80;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "NIssuerId";
			dg.headerText = "隶属运营商ID";
			dg.columnWidth = 100;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SRestrictedTime";
			dg.headerText = "限制登陆时间";
			dg.columnWidth = 120;
			cols.push(dg);
			
			list.columns = cols;
			
			findTableSpaceDataByPage(1, 20,null);
		}
		
		private function sexLabel(oItem:Object, iCol:int = 0):String
		{
			var list:Array = GDPSDataManager.sexList;
			for each(var vo:Object in list){
				
				if(vo.value == oItem.SSex){
					return vo.label;
				}
			}
			
			return oItem.SSex || "";
		}
		
		private function statusLabel(oItem:Object, iCol:int = 0):String
		{
			var list:Array = GDPSDataManager.statusList;
			for each(var vo:Object in list){
				
				if(vo.value == oItem.SStatus){
					return vo.label;
				}
			}
			
			return oItem.SStatus;
		}
		
		/**
		 * 创建行索引
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
		public function findTableSpaceDataByPage(pageNo:int, pageLimit:int, params:*):void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			
			http.args2 = { "pageNo": pageNo, "pageLimit": pageLimit };
			http.sucResult_f = showTableSpaceData;
			
			var url:String = GDPSServices.getUserMamangeList_url ;
			http.conn(url, "POST");
		}
		
		private function showTableSpaceData(a:*):void
		{
			var value:* = a;
			list.dataProvider = value.data;
			
			//设置分页参数
			pageBar.pageData = value.data.length;
			pageBar.totalCount = value.page.totalRowCount;
			pageBar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findTableSpaceDataByPage(pageNo, pageLimit, null);
		}
	}
}
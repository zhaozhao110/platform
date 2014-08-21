package com.editor.module_gdps.view.serverManage.mediator
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
	
	public class GdpsServerManagerDataGridMediator extends AppMediator
	{
		public static const NAME:String = "GdpsServerManagerDataGridMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsServerManagerDataGridMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
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
			dg.dataField = "NSid";
			dg.headerText = "服务器ID";
			dg.columnWidth = 80;
			dg.sortable = true;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SSname";
			dg.headerText = "服务器名称";
			dg.columnWidth = 150;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SGsname";
			dg.headerText = "游戏内显示名称";
			dg.columnWidth = 150;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SType";
			dg.headerText = "服务器类型";
			dg.columnWidth = 100;
			dg.labelFunction = serverName;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SState";
			dg.headerText = "服务器状态";
			dg.columnWidth = 100;
			dg.labelFunction = serverState;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "NGameid";
			dg.headerText = "所属游戏ID";
			dg.columnWidth = 80;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "NAreaId";
			dg.headerText = "所属项目ID";
			dg.columnWidth = 80;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "NNid";
			dg.headerText = "所属节点ID";
			dg.columnWidth = 80;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "NOprid";
			dg.headerText = "主运营商ID";
			dg.columnWidth = 80;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SNetline";
			dg.headerText = "网络线路";
			dg.columnWidth = 100;
			dg.labelFunction = netLine;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "DStart";
			dg.headerText = "开服时间";
			dg.columnWidth = 140;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "DCreate";
			dg.headerText = "创建时间";
			dg.columnWidth = 140;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SDomain";
			dg.headerText = "服务器域名";
			dg.columnWidth = 150;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SWebUrl";
			dg.headerText = "游戏WEB接口地址";
			dg.columnWidth = 150;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SWebKey";
			dg.headerText = "游戏WEB接口密钥";
			dg.columnWidth = 150;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SLoginUrl";
			dg.headerText = "游戏登陆接口地址";
			dg.columnWidth = 150;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "STicketUrl";
			dg.headerText = "游戏登陆票据接口";
			dg.columnWidth = 150;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SDesc";
			dg.headerText = "描述";
			dg.columnWidth = 120;
			cols.push(dg);
			
			list.columns = cols;
			
			findTableSpaceDataByPage(1, 20,null);
		}
		
		private function serverState(oItem:Object, iCol:int = 0):String
		{
			var list:Array = GDPSDataManager.serverStates;
			for each(var vo:Object in list){
				
				if(vo.value == oItem.SState){
					return vo.label;
				}
			}
			
			return oItem.SState;
		}
		
		private function netLine(oItem:Object, iCol:int = 0):String
		{
			var list:Array = GDPSDataManager.netLines;
			for each(var vo:Object in list){
				
				if(vo.value == oItem.SNetline){
					return vo.label;
				}
			}
			
			return oItem.SNetline;
		}
		
		private function serverName(oItem:Object, iCol:int = 0):String
		{
			var list:Array = GDPSDataManager.serverNames;
			for each(var vo:Object in list){
				
				if(vo.value == oItem.SType){
					return vo.label;
				}
			}
			
			return oItem.SType;
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
			
			var url:String = GDPSServices.getServerMamangeList_url ;
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
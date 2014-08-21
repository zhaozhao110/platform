package com.editor.module_gdps.pop.dataManagePreview
{
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.math.HashMap;

	public class GdpsDataManagePreviewPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsDataManagePreviewPopupwinMediator";
		
		public function GdpsDataManagePreviewPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get previewWin():GdpsDataManagePreviewPopupwin
		{
			return viewComponent as GdpsDataManagePreviewPopupwin;
		}
		public function get previewList():GdpsModuleDataGrid
		{
			return previewWin.previewList;
		}
		public function get tip_version_info():UILabel
		{
			return previewWin.tip_version_info;
		}
		public function get listPreview_datagrid():SandyDataGrid
		{
			return previewList.tableSpace_grid;
		}
		public function get listPreview_page_bar():GdpsPageBar
		{
			return previewList.tableSpace_page_bar;
		}
		
		private var confItem:AppModuleConfItem;
		private var versionNo:String = null;
		private var _url:String = "";
		
		override public function onRegister():void
		{
			super.onRegister();
			
			listPreview_page_bar.pageLimit = 15;
			listPreview_page_bar.pageNoChangeFun = onPageChange;
			
			initView();
		}
		
		private function initView():void
		{
			var dat:OpenPopwinData = OpenPopwinData(previewWin.item); //获取上层窗口的传值对象
			confItem = dat.data.confItem;
			if (confItem == null || confItem.extend == "")
			{
				showError("缺少必要传值参数");
				return;
			}
			versionNo = dat.data.vno;
			
			var versionTableId:int = confItem.extend.versionTableId;
			var msg:String = "版本编号：";
			_url = GDPSServices.getVersionTableData_url;
			if (versionNo === '' || versionNo.length === 0)
			{
				msg += "公网正式数据";
				versionTableId = confItem.extend.queryTableId;//(公网)正式数据表id
			}
			else
			{
				msg += versionNo;
			}
			tip_version_info.htmlText = msg;
			findDataGridColumn(versionTableId);
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn(previewTableId:int):void
		{
			if (previewTableId <= 0)
			{
				showError("获取预览表id失败");
				return;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "queryTableId": previewTableId };
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url, "POST");
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			
			var cols:Array = listPreview_datagrid.columns || [];
			for (var i:int = 0; i < columns.length; i++)
			{
				var dg:ASDataGridColumn = new ASDataGridColumn();
				dg.dataField = columns[i].SField;
				dg.headerText = columns[i].SName;
				dg.columnWidth = columns[i].NWidth;
				dg.sortable = true;
				cols.push(dg);
			}
			listPreview_datagrid.columns = cols;
			
			findPreviewDataByPage(1, listPreview_page_bar.pageLimit, versionNo, _url);
		}
		
		/**
		 * 加载道具表公网-历史版本数据
		 */
		private function findPreviewDataByPage(pageNo:int, pageLimit:int, vno:String, _url:String):void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			var map:HashMap = new HashMap();
			map.put("pageNo", pageNo);
			map.put("pageLimit", pageLimit);
			map.put("tableId", confItem.extend.versionTableId);
			map.put("vno", vno);//查询公网数据时，版本号为空
			http.args2 = map.getContent();
			http.sucResult_f = showPreviewDataByPage;
			http.conn(_url, "POST");
		}
		
		private function showPreviewDataByPage(a:*):void
		{
			var value:* = a;
			listPreview_datagrid.dataProvider = value.data;
			//设置分页参数
			listPreview_page_bar.pageData = value.data.length;
			listPreview_page_bar.totalCount = value.page.totalRowCount;
			listPreview_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findPreviewDataByPage(pageNo, pageLimit, versionNo, _url);
		}
	}
}
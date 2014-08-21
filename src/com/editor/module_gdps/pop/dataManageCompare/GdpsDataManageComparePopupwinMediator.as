package com.editor.module_gdps.pop.dataManageCompare
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class GdpsDataManageComparePopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsDataManageComparePopupwinMediator";
		
		public function GdpsDataManageComparePopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get comparisonWin():GdpsDataManageComparePopupwin
		{
			return viewComponent as GdpsDataManageComparePopupwin;
		}
		public function get left_label():UILabel
		{
			return comparisonWin.left_label;
		}
		public function get right_label():UILabel
		{
			return comparisonWin.right_label;
		}
		public function get left_comp_dataGrid():SandyDataGrid
		{
			return comparisonWin.left_comp_dataGrid;
		}
		public function get right_comp_dataGrid():SandyDataGrid
		{
			return comparisonWin.right_comp_dataGrid;
		}
		public function get comparisionSubmitBtn():UIButton
		{
			return comparisonWin.comparisionSubmitBtn;
		}
		
		private var confItem:AppModuleConfItem = null;
		private var cboxArray:Array = [];
		private var comparisonTableId:int = -1;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			comparisionSubmitBtn.visible = false;
			initData();
			findDataGridColumn();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			left_comp_dataGrid.dispose();
			right_comp_dataGrid.dispose();
		}
		
		/**
		 * 对上层传递的数据进行初始化
		 */
		private function initData():void
		{
			var dat:OpenPopwinData = comparisonWin.item as OpenPopwinData;
			cboxArray = [];
			cboxArray = dat.data.compVno as Array;
			confItem = dat.data.confItem as AppModuleConfItem;
			comparisonTableId = confItem.extend.queryTableId; 
		}
		
		private function initView():void
		{
			var arr:Array = cboxArray;
			var left:String = null;
			var right:String = null;
			
			//将编辑版本放置在右侧
			if (arr[0] === '0')
			{
				right = arr[0];
				left = arr[1];
			}
			else if (arr[1] === '0')
			{
				right = arr[1];
				left = arr[0];
			}
			else //将公网版本放置在右侧
			{
				if (arr[0] === '1')
				{
					right = arr[0];
					left = arr[1];
				}
				else if (arr[1] === '1')
				{
					right = arr[1];
					left = arr[0];
				}
				else
				{
					if (Number(arr[0]) > Number(arr[1]))
					{
						left = arr[1];
						right = arr[0];
					}
					else
					{
						left = arr[0];
						right = arr[1];
					}
				}
			}
			
			loadComparisonData(left, right);
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn():void
		{
			if (cboxArray.length == 0)
			{
				showError("传递的版本ID获取失败");
				return;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "queryTableId": comparisonTableId };
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url);
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			
			var left_cols:Array = left_comp_dataGrid.columns || [];
			for (var i:int = 0; i < columns.length; i++)
			{
				var dg:ASDataGridColumn = new ASDataGridColumn();
				dg.dataField = columns[i].SField;
				dg.headerText = columns[i].SName;
				dg.columnWidth = columns[i].NWidth;
				dg.textAlign = "left";
				left_cols.push(dg);
			}
			left_comp_dataGrid.columns = left_cols;
			
			var right_cols:Array = right_comp_dataGrid.columns || [];
			for (var j:int = 0; j < columns.length; j++)
			{
				var dgc:ASDataGridColumn = new ASDataGridColumn();
				dgc.dataField = columns[j].SField;
				dgc.headerText = columns[j].SName;
				dgc.columnWidth = columns[j].NWidth;
				dgc.textAlign = "left";
				if(j == 0){
					dgc.renderer = GdpsDataManageCompareRenderer;
				}else{
					dgc.renderer = GdpsDataManageCompareRenderer2;
				}
				right_cols.push(dgc);
			}
			right_comp_dataGrid.columns = right_cols;
			
			initView();
		}
		
		/**
		 * 加载数据表 公网-历史版本数据
		 */
		private function loadComparisonData(left:String, right:String):void
		{
			comparisionSubmitBtn.visible = false;
			if (right === '0' && left === '1') //如果左侧是公网版本-1且右侧是编辑版本-0，则显示提交按钮
			{
				comparisionSubmitBtn.visible = true;
			} 
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.sucResult_f = showComparisonData;
			http.args2 = { "leftvno": left, "rightvno": right, "preTableId":confItem.extend.queryTableId, 
				"verTableId":confItem.extend.versionTableId };
			
			var _url:String = GDPSServices.getComparisonTableData_url;
			http.conn(_url);
		}
		
		private var committer:String = null;
		
		private function showComparisonData(a:*):void
		{
			var value:* = a;
			var l_vmsg:* = value.leftMsg;
			var r_vmsg:* = value.rightMsg;
			//设置标题栏版本记录信息
			if (l_vmsg != '')
			{
				left_label.text = "版本：" + (l_vmsg.SVid === "1" ? "公网版本" : l_vmsg.SVid) + " (" + l_vmsg.SCommitter + ", " + l_vmsg.DCreate + ")";
			}
			else
			{
				left_label.text = "版本： 公网版本";
			}
			if (r_vmsg != '')
			{
				right_label.text = "版本：" + (r_vmsg.SVid === "0" ? "编辑版" : r_vmsg.SVid) + " (" + r_vmsg.SCommitter + ", " + r_vmsg.DCreate + ")";
				if (r_vmsg.SVid === "0")
				{ //编辑版
					committer = r_vmsg.SCommitter;
				}
			}
			
			//设置datagrid
			left_comp_dataGrid.dataProvider = value.leftdata;
			right_comp_dataGrid.dataProvider = value.rightdata;
		}
		
		/**
		 * 编辑版道具提交窗口
		 */
		public function reactToComparisionSubmitBtnClick(e:MouseEvent):void
		{
			var submitUrl:String = GDPSServices.submitTableData_url;
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = GDPSPopupwinSign.GdpsDataManageSubmitPopupwin_sign;
			dat.data = { 'committer': (committer != null ? committer : CacheDataUtil.getUserId()), 
				'submitUrl': submitUrl, "preTableId":confItem.extend.queryTableId, 
					"verTableId":confItem.extend.versionTableId };
			dat.openByAirData = new OpenPopByAirOptions();
			openPopupwin(dat);
		}
		
		
	}
}
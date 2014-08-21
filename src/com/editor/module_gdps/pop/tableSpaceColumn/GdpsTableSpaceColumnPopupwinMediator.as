package com.editor.module_gdps.pop.tableSpaceColumn
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.view.tableSpace.mediator.GdpsTabSpaceDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.math.HashMap;
	
	import flash.events.MouseEvent;

	public class GdpsTableSpaceColumnPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsTableSpaceColumnPopupwinMediator";
		
		public function GdpsTableSpaceColumnPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		public function get columnWin():GdpsTableSpaceColumnPopupwin
		{
			return viewComponent as GdpsTableSpaceColumnPopupwin;
		}
		public function get saveTableBtn():UIButton
		{
			return columnWin.saveTableBtn;
		}
		public function get resetTableBtn():UIButton
		{
			return columnWin.resetTableBtn;
		}
		
		public function get SType_combobox():UICombobox
		{
			return columnWin.SType;
		}
		
		private var menuId:Number;
		private var btnName:String;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			resetForm();
			var dat:Object = OpenPopwinData(columnWin.item).data;
			var confItem:AppModuleConfItem = dat.confItem;
			btnName = dat.btnName;
			menuId = confItem.menuId;
			if (menuId < 0)
			{
				showError("缺少必要参数menuId");
			}
			
			CacheDataUtil.getDict(1, getDictCallback);
		}
		
		private function getDictCallback(a:*):void
		{
			SType_combobox.dataProvider = a as Array;
			
			initForm(btnName);
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
				columnWin.title = "修改表字段对象";
				columnWin.NId.visible = true;
				columnWin.NId.includeInLayout = true;
				
				var grid:SandyDataGrid = dataGridMediator.tableSpace_grid
				var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
				http.args2 = { "menuId": menuId, "NId": grid.selectedItem.NId };
				http.sucResult_f = showColumnDataCallBack;
				http.conn(GDPSServices.getColumnData_url, "POSt");
			}
			else
			{
				columnWin.title = "添加表字段对象";
				columnWin.NId.visible = false;
				columnWin.NId.includeInLayout = false;
			}
		}
		
		/**
		 * 修改按钮 显示表单数据回调方法
		 */
		private function showColumnDataCallBack(a:*):void
		{
			var columns:Array = a.data;
			columnWin.NId.text = columns[0].NId;
			columnWin.SField.text = columns[0].SField;
			columnWin.SName.text = columns[0].SName;
			columnWin.NTableId.text = columns[0].NTableId;
			columnWin.SExtend.text = columns[0].SExtend;
			columnWin.SDesc.text = columns[0].SDesc;
			
			//设置combobox值
			var dataProvider:Object = SType_combobox.dataProvider;
			if(dataProvider != null)
			{
				var type:String = columns[0].SType;
				for each (var obj:Object in dataProvider)
				{
					if (obj.value == type)
					{
						SType_combobox.selectedItem = obj;
					}
				}
				
				if(SType_combobox.selectedItem == null){
					SType_combobox.selectedIndex = 0;
				}
			}
			else
			{
				showError("加载表字段类型失败");
			}
		}
		
		public function reactToSaveTableBtnClick(evt:MouseEvent):void
		{
			if(columnWin.NId.visible && columnWin.NId.text == ""){
				showError("字段ID不能为空！");
				return;
			}
			if(columnWin.SField.text == ""){
				showError("字段英文名不能为空！");
				return;
			}
			if(columnWin.SName.text == ""){
				showError("字段中文名不能为空！");
				return;
			}
			if(SType_combobox.selectedItem == null){
				showError("请先选择字段类型！");
				return;
			}
			
			//添加表单参数
			var formMap:HashMap = new HashMap();
			formMap.put("menuId", menuId);
			formMap.put("NId", columnWin.NId.text);
			formMap.put("SField", columnWin.SField.text);
			formMap.put("SName", columnWin.SName.text);
			formMap.put("SType", SType_combobox.selectedItem.value);
			formMap.put("NTableId", columnWin.NTableId.text);
			formMap.put("SExtend", columnWin.SExtend.text);
			formMap.put("SDesc", columnWin.SDesc.text);
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formMap.getContent();
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.getSaveColumnData_url, "POST");
		}
		
		private function faultHandlerCallBack(a:*):void
		{
			showError("保存失败|" + a.msg);
		}
		
		private function saveHandlerCallBack(a:*):void
		{
			showMessage("保存成功!");
			dataGridMediator.findTableSpaceDataByPage(dataGridMediator.tableSpace_page_bar.pageNo, 20, null);
			closeWin();
		}
		
		public function reactToResetTableBtnClick(evt:MouseEvent):void
		{
			resetForm();
		}
		
		private function resetForm():void
		{
			columnWin.NId.text = "";
			columnWin.SField.text = "";
			columnWin.SName.text = "";
			columnWin.NTableId.text = "";
			columnWin.SExtend.text = "";
			columnWin.SDesc.text = "";
		}
		
		private function get dataGridMediator():GdpsTabSpaceDataGridMediator
		{
			return retrieveMediator(GdpsTabSpaceDataGridMediator.NAME + menuId) as GdpsTabSpaceDataGridMediator;
		}
	}
}
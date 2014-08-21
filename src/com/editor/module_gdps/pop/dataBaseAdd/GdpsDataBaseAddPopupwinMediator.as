package com.editor.module_gdps.pop.dataBaseAdd
{
	import com.air.component.SandyTextInputWithLabelWithSelectFile;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.view.dataBase.mediator.GdpsDataBaseDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.net.json.SandyJSON;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class GdpsDataBaseAddPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsDataBaseAddPopupwinMediator";
		
		public function GdpsDataBaseAddPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get addWin():GdpsDataBaseAddPopupwin
		{
			return viewComponent as GdpsDataBaseAddPopupwin;
		}
		public function get sqlFile():SandyTextInputWithLabelWithSelectFile
		{
			return addWin.sqlFile;
		}
		public function get saveBtn():UIButton
		{
			return addWin.saveBtn;
		}
		public function get resetBtn():UIButton
		{
			return addWin.resetBtn;
		}
		public function get form():UIForm
		{
			return addWin.form;
		}
		public function get SType_combobox():UICombobox
		{
			return addWin.SType;
		}
		public function get truncate_checkbox():UICheckBox
		{
			return addWin.truncateCbox;
		}
		
		private var _file:File;
		private var menuId:Number;
		private var btnName:String;
		private var confItem:AppModuleConfItem;
		
		private function get dataGridMediator():GdpsDataBaseDataGridMediator
		{
			return retrieveMediator(GdpsDataBaseDataGridMediator.NAME + menuId) as GdpsDataBaseDataGridMediator;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			resetForm();
			
			sqlFile.addEventListener(ASEvent.CHANGE , selectFileCallback);
			
			var dat:OpenPopwinData = addWin.item as OpenPopwinData;
			confItem = dat.data.confItem;
			btnName = dat.data.btnName;
			menuId = confItem.menuId;
			if (menuId < 0)
			{
				showError("缺少必要参数menuId");
			}
			
			CacheDataUtil.getDict(3, getDictCallback);
		}
		
		
		private function selectFileCallback(evt:ASEvent):void
		{
			_file  = evt.data as File;
		}
		
		private function getDictCallback(a:*):void
		{
			SType_combobox.dataProvider = a as Array;
			SType_combobox.selectedIndex = 0;
			
			initForm(btnName);
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			clearFileEvent();
			resetForm();
		}
		
		private function clearFileEvent():void
		{
			if (_file)
			{
				_file.removeEventListener(Event.COMPLETE, importCompleteHandler);
				_file.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA , importCompleteHandler);
				_file.removeEventListener(Event.OPEN , onOpenHandler);
				_file = null;
				sqlFile.text = "";
			}
		}
		
		private function importCompleteHandler(evt:DataEvent):void
		{
			sendNotification(GDPSAppEvent.hideLoadingProgressBarGdps_event);
			
			var dat:* = SandyJSON.decode(evt.data);
			if (dat != null && dat.code > '0')
			{
				showError(dat.msg);
			}
			else
			{
				showError("上传成功");
				dataGridMediator.findDatabaseFileDataByPage(dataGridMediator.databaseFile_page_bar.pageNo, 20, null);
				closeWin();
			}
			clearFileEvent();
		}
		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			showError("HTTP连接错误");
			
			sendNotification(GDPSAppEvent.hideLoadingProgressBarGdps_event);
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
				addWin.title = "修改文件脚本";
				addWin.NRid.visible = true;
				addWin.NRid.includeInLayout = true;
				
				var grid:SandyDataGrid = dataGridMediator.databaseFile_grid
				var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
				http.args2 = { "menuId": menuId, "NRid": grid.selectedItem.NRid };
				http.sucResult_f = showColumnDataCallBack;
				http.conn(GDPSServices.getPrepareSqlData_url, "POSt");
			}
			else
			{
				addWin.title = "添加文件脚本";
				addWin.NRid.visible = false;
				addWin.NRid.includeInLayout = false;
			}
		}
		
		/**
		 * 修改按钮 显示表单数据回调方法
		 */
		private function showColumnDataCallBack(a:*):void
		{
			var columns:Array = a.data;//服务端的ColumnNameDefine对象
			addWin.NRid.text = columns[0].NRid;
			addWin.SName.text = columns[0].SName;
			addWin.SDesc.text = columns[0].SDesc;
			
			//设置combobox值
			var dataProvider:Object = SType_combobox.dataProvider;
			if (dataProvider != null)
			{
				var type:String = columns[0].SType;
				for each (var obj:Object in dataProvider)
				{
					if (obj.code == type)
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
		
		public function reactToSaveBtnClick(evt:MouseEvent):void
		{
			if (_file == null)
			{
				showError("文件未选择");
				return;
			}
			var name:String = _file.name;
			if (name.substring(name.length - 3, name.length).toLowerCase() != "sql")
			{
				showError("只能上传sql文件");
				return;
			}
			
			_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, importCompleteHandler);
			_file.addEventListener(ProgressEvent.PROGRESS, progress);
			_file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_file.addEventListener(Event.OPEN , onOpenHandler);
			
			if(addWin.SName.text == ""){
				showError("请填写文件名称");
				return;
			}
			if(SType_combobox.selectedItem == null){
				showError("请选择文件类型");
				return;
			}
			
			//添加表单参数
			var _url:String = GDPSServices.uploadSqlData2Prepare_url;
			_url = _url + "&srt=2&truncate=" + truncate_checkbox.selected.toString() + "&menuId=" + menuId + "&tableId=" + confItem.extend.queryTableId 
				+ "&NRid=" + addWin.NRid.text + "&SType=" + SType_combobox.selectedItem.code + "&SName=" + encodeURIComponent(addWin.SName.text) + "&SDesc=" 
				+ encodeURIComponent(addWin.SDesc.text) + "&projectId=" + CacheDataUtil.getProjectId() + "&jsessionid=" + CacheDataUtil.getSessionId();
			var req:URLRequest = new URLRequest(_url);
			req.method = URLRequestMethod.POST;
			_file.upload(req);
			
			sendNotification(GDPSAppEvent.showLoadingProgressBarGdps_event);
		}
		
		private function onOpenHandler(e:Event):void
		{
			closeWin();
		}
		
		private function progress(evt:ProgressEvent):void
		{
			var str:String = "上传处理中，请稍等...";
			sendNotification(GDPSAppEvent.showLoadingProgressBarGdps_event, str);
		}
		
		public function reactToResetBtnClick(evt:MouseEvent):void
		{
			resetForm();
		}
		
		private function resetForm():void
		{
			addWin.NRid.text = "";
			addWin.SName.text = "";
			addWin.SDesc.text = "";
			sqlFile.text = "";
			_file = null;
			truncate_checkbox.selected = false;
		}
	}
}
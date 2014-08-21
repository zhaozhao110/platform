package com.editor.module_gdps.pop.dataManageImport
{
	import com.air.component.SandyTextInputWithLabelWithSelectFile;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.view.dataManage.mediator.GdpsDataManagerDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.net.json.SandyJSON;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class GdpsDataManageImportPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsDataManageImportPopupwinMediator";
		
		public function GdpsDataManageImportPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get importsWin():GdpsDataManageImportPopupwin
		{
			return viewComponent as GdpsDataManageImportPopupwin;
		}
		public function get truncateCbox():UICheckBox
		{
			return  importsWin.truncateCbox;
		}
		public function get truncateTestdbCbox():UICheckBox
		{
			return  importsWin.truncateTestdbCbox;
		}
		public function get selectFileBtn():SandyTextInputWithLabelWithSelectFile
		{
			return importsWin.selectFileBtn;
		}
		public function get saveFileBtn():UIButton
		{
			return importsWin.saveFileBtn;
		}
		public function get cancelBtn():UIButton
		{
			return importsWin.cancelBtn;
		}
		
		private var confItem:AppModuleConfItem;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			selectFileBtn.addEventListener(ASEvent.CHANGE , selectFile);
			
			var dat:OpenPopwinData = OpenPopwinData(importsWin.item); //获取上层窗口的传值对象
			confItem = dat.data.confItem;
			if (confItem == null || confItem.extend == "")
			{
				showError("缺少必要传值参数");
				return;
			}
			resetView();
			//testTableHasCommit();
		}
		
		/**
		 * 测试当前编辑表中数据是否已经被提交至版本库
		 * --暂时未用
		 */
		private function testTableHasCommit():void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.sucResult_f = testTableHasCommitCallback;
			var _url:String = GDPSServices.testTableData_url;
			http.conn(_url, "POSt");
		}
		
		private function testTableHasCommitCallback(a:*):void
		{
			trace("当前编辑表数据已提交过版本库表，可以清除");
		}
		
		private function resetView():void
		{
			truncateCbox.selected = true;
			truncateTestdbCbox.selected = false;
			
			if (_file)
			{
				_file.removeEventListener(Event.COMPLETE, importCompleteHandler);
				_file.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_file.removeEventListener(ProgressEvent.PROGRESS,progress);
				_file.removeEventListener(Event.OPEN,openHandler);
				_file = null;
				selectFileBtn.text = "";
			}
		}
		
		private var _file:File;
		
		private function selectFile(evt:ASEvent):void
		{
			_file  = evt.data as File;
		}
		
		public function reactToCancelBtnClick(e:MouseEvent):void
		{
			closeWin();
		}
		
		public function reactToSaveFileBtnClick(evt:MouseEvent):void
		{
			if (_file == null)
			{
				showError("文件未选择");
				return;
			}
			
			sendNotification(GDPSAppEvent.showLoadingProgressBarGdps_event);
			
			_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, importCompleteHandler);
			_file.addEventListener(ProgressEvent.PROGRESS, progress);
			_file.addEventListener(Event.OPEN , openHandler);
			_file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var _url:String = GDPSServices.importTableData_url;
			_url = _url + "&srt=2&truncate=" + truncateCbox.selected.toString() 
				+ "&truncateTable=" + truncateTestdbCbox.selected.toString()
				+ "&menuId=" + confItem.menuId + "&tableId=" + confItem.extend.queryTableId + "&projectId=" 
				+ CacheDataUtil.getProjectId() + "&jsessionid=" + CacheDataUtil.getSessionId();
			var req:URLRequest = new URLRequest(_url);
			req.method = URLRequestMethod.POST;
			/*var url_dat:URLVariables = new URLVariables();
			url_dat["srt"] = "2";
			url_dat["menuId"] = menuId;
			url_dat["tableId"] = confItem.extend.queryTableId;
			url_dat["projectId"] = CacheDataUtil.getProjectId();
			url_dat["jsessionid"] = CacheDataUtil.getSessionId();
			req.data = url_dat;*/
			
			_file.upload(req);
		}
		
		private function openHandler(e:Event):void
		{
			closeWin();
		}
		
		private function progress(evt:ProgressEvent):void
		{
			var str:String = "上传处理中，请稍等...";
			sendNotification(GDPSAppEvent.showLoadingProgressBarGdps_event, str);
		}
		
		private function importCompleteHandler(evt:DataEvent):void
		{
			var dat:* = SandyJSON.decode(evt.data);
			if (dat != null && Number(dat.code) > 0)
			{
				showError(dat.msg);
			}
			else
			{
				showMessage("上传成功");
				closeWin();
				dataGridMediator.findDataManageDataByPage(dataGridMediator.dataManage_page_bar.pageNo, 20, null);
			}
			sendNotification(GDPSAppEvent.hideLoadingProgressBarGdps_event);
			
			resetView();
		}
		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			showError("HTTP连接错误");
			sendNotification(GDPSAppEvent.hideLoadingProgressBarGdps_event);
		}
		
		private function get dataGridMediator():GdpsDataManagerDataGridMediator
		{
			return retrieveMediator(GdpsDataManagerDataGridMediator.NAME + confItem.menuId) as GdpsDataManagerDataGridMediator;
		}
	}
}
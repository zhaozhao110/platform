package com.editor.module_gdps.pop.svnLog
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.pop.clientSave.GdpsClientSavePopupwinMediator;
	import com.editor.module_gdps.pop.publishTest.GdpsPublishTestPopupwinMediator;
	import com.editor.module_gdps.pop.resSave.GdpsResSavePopupwinMediator;
	import com.editor.module_gdps.pop.serverSave.GdpsServerSavePopupwinMediator;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.events.MouseEvent;

	public class GdpsPublishSvnLogPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsPublishSvnLogPopupwinMediator";
		
		private var logType:String = ""; //查询svn日志类型
		private var source:String = ""; //来源类型
		private var oprid:String = "0";
		
		public function GdpsPublishSvnLogPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get svnlogPopwin():GdpsPublishSvnLogPopupwin
		{
			return viewComponent as GdpsPublishSvnLogPopupwin;
		}
		public function get svnlogDatagrid():SandyDataGrid
		{
			return svnlogPopwin.svnlog_datagrid;
		}
		public function get svnlogDatagridDetail():SandyDataGrid
		{
			return svnlogPopwin.svnlog_datagrid_detail;
		}
		public function get confirmBtn():UIButton
		{
			return svnlogPopwin.confirmBtn;
		}
		public function get cancelBtn():UIButton
		{
			return svnlogPopwin.cancelBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			initView();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			cache_grid_data = null;
			svnlogDatagrid.dataProvider = null;
			svnlogDatagridDetail.dataProvider = null;
			svnlogDatagrid.removeEventListener(ASEvent.CHANGE, svnlogDatagridHandle);
		}
		
		/**
		 * 初始化
		 */
		private function initView():void
		{
			initColumns();
			
			var dat:* = OpenPopwinData(svnlogPopwin.item).data;
			logType = dat.type;
			source = dat.source;
			if (dat.oprid != null) {
				oprid = dat.oprid;
			}
			if(logType === "")
			{
				showError("缺少参数日志类型");
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "logType": logType, "oprid" : oprid};
			http.sucResult_f = showSvnlog;
			http.conn(GDPSServices.getShowSvnlog_url, "POST");
			
			svnlogDatagrid.addEventListener(ASEvent.CHANGE, svnlogDatagridHandle);
		}
		
		private function initColumns():void
		{
			var out:Array = [];
			var vo:ASDataGridColumn = new ASDataGridColumn();
			vo.headerText = "版本";
			vo.dataField = "revision";
			vo.columnWidth = 80;
			out.push(vo);
			
			vo = new ASDataGridColumn();
			vo.headerText = "作者";
			vo.dataField = "author";
			vo.columnWidth = 100;
			out.push(vo);
			
			vo = new ASDataGridColumn();
			vo.headerText = "日期";
			vo.dataField = "date";
			vo.columnWidth = 160;
			out.push(vo);
			
			vo = new ASDataGridColumn();
			vo.headerText = "信息";
			vo.dataField = "message";
			vo.columnWidth = 540;
			out.push(vo);
			
			svnlogDatagrid.columns = out;
			
			out = null;
			out = [];
			
			vo = new ASDataGridColumn();
			vo.headerText = "操作";
			vo.dataField = "type";
			vo.columnWidth = 80;
			out.push(vo);
			
			vo = new ASDataGridColumn();
			vo.headerText = "路径";
			vo.dataField = "path";
			vo.columnWidth = 800;
			vo.textAlign = "left";
			out.push(vo);
			svnlogDatagridDetail.columns = out;
		}
		
		private function get testPopwinMediator():GdpsPublishTestPopupwinMediator
		{
			return retrieveMediator(GdpsPublishTestPopupwinMediator.NAME) as GdpsPublishTestPopupwinMediator;
		}
		
		private function get publishClientSavePopwinMediator():GdpsClientSavePopupwinMediator
		{
			return retrieveMediator(GdpsClientSavePopupwinMediator.NAME) as GdpsClientSavePopupwinMediator;
		}
		
		private function get publishResSavePopwinMediator():GdpsResSavePopupwinMediator
		{
			return retrieveMediator(GdpsResSavePopupwinMediator.NAME) as GdpsResSavePopupwinMediator;
		}
		
		private function get publishServerSavePopwinMediator():GdpsServerSavePopupwinMediator
		{
			return retrieveMediator(GdpsServerSavePopupwinMediator.NAME) as GdpsServerSavePopupwinMediator;
		}
		
		private var cache_grid_data:Object = [];
		
		private function showSvnlog(a:*):void
		{
			var value:* = a;
			cache_grid_data = value.data;
			svnlogDatagrid.dataProvider = value.data;
		}
		
		private function svnlogDatagridHandle(event:ASEvent):void
		{
			svnlogDatagridDetail.dataProvider = [];
			
			var selected:Object = svnlogDatagrid.selectedItem;
			if(selected != null && selected.revision != null)
			{
				for(var i:int = 0; i < cache_grid_data.length; i++)
				{
					var item:Object = Object(cache_grid_data[i]);
					if(item.revision === selected.revision)
					{
						svnlogDatagridDetail.dataProvider = item.detail;
						return;
					}
				}
			}
		}
		
		public function reactToConfirmBtnClick(evt:MouseEvent):void
		{
			var selected:Object = svnlogDatagrid.selectedItem;
			if(selected != null && selected.revision != null)
			{
				if(logType === "C")
				{
					if(source === GDPSDataManager.client_data_type){
						publishClientSavePopwinMediator.saveWin.client_svn_version.text = selected.revision;
					}else{
						testPopwinMediator.publishTestPopwin.client_version_text.text = selected.revision;
						testPopwinMediator.publishTestPopwin.client_version_rb2.selected = true;
					}
				}
				else if(logType === "S")
				{
					if(source === GDPSDataManager.server_data_type){
						publishServerSavePopwinMediator.saveWin.server_svn_version.text = selected.revision;
					}else{
						testPopwinMediator.publishTestPopwin.server_version_text.text = selected.revision;
						testPopwinMediator.publishTestPopwin.server_version_rb2.selected = true;
					}
				}
				else if(logType === "R")
				{
					if(source === GDPSDataManager.res_data_type){
						publishResSavePopwinMediator.saveWin.res_svn_version.text = selected.revision;
					}else{
						testPopwinMediator.publishTestPopwin.res_version_text.text = selected.revision;
						testPopwinMediator.publishTestPopwin.res_version_rb2.selected = true;
					}
				}
				closeWin();
			}
			else
			{
				showError("请先选择一个更新版本");
			}
		}
		
		public function reactToCancelBtnClick(evt:MouseEvent):void
		{
			closeWin();
		}
	}
}
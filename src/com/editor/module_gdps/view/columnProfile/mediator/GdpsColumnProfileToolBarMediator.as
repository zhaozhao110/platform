package com.editor.module_gdps.view.columnProfile.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsColunmProfileToolBar;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;

	public class GdpsColumnProfileToolBarMediator extends AppMediator
	{
		public static const NAME:String = "GdpsColumnProfileToolBarMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsColumnProfileToolBarMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get toolBar():GdpsColunmProfileToolBar
		{
			return viewComponent as GdpsColunmProfileToolBar;
		}
		public function get propertyBtn():UIButton
		{
			return toolBar.propertyBtn;
		}
		public function get annotationBtn():UIButton
		{
			return toolBar.annotationBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function reactToPropertyBtnClick(e:MouseEvent):void
		{
			menuHandler(propertyBtn.name);
		}
		
		public function reactToAnnotationBtnClick(e:MouseEvent):void
		{
			menuHandler(annotationBtn.name);
		}
		
		/**
		 * 点击菜单
		 */
		private function menuHandler(s:String):void
		{
			var btnName:String = s;
			
			var dat:OpenPopwinData = new OpenPopwinData();
			var grid:SandyDataGrid = dataGridMediator.columnProfile_grid;
			
			if (btnName == "property")
			{
				
				if (grid.selectedItem == null || grid.selectedItem.tableId == null)
				{
					showError("请先选择一条需要调整的数据记录！");
					return;
				}
				dat.data = {"tableId" : grid.selectedItem.tableId, "tableName" : grid.selectedItem.tableName, "confItem" : confItem};
				dat.popupwinSign = GDPSPopupwinSign.GdpsColumnProfilePopwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if (btnName == "annotation") 
			{
				if (grid.selectedItem == null || grid.selectedItem.tableId == null)
				{
					showError("请先选择一条需要下载的数据记录！");
					return;
				}
				
				var url:String = GDPSServices.profileGenerateDoc_url + "&srt=2&projectId=" + CacheDataUtil.getProjectId() 
					+ "&jsessionid=" + CacheDataUtil.getSessionId() + "&tableId=" + grid.selectedItem.tableId;
				var request:URLRequest = new URLRequest(url);
				request.method = URLRequestMethod.POST;
				navigateToURL(request, "_blank");
			}
		}
		
		
		private function get dataGridMediator():GdpsColunmProfileDataGridMediator
		{
			return retrieveMediator(GdpsColunmProfileDataGridMediator.NAME + confItem.menuId) as GdpsColunmProfileDataGridMediator;
		}
	}
}
package com.editor.module_gdps.view.publish.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsPublishToolBar;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class GdpsPublishTooBarMediator extends AppMediator
	{
		public static const NAME:String = "GdpsPublishTooBarMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsPublishTooBarMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get toolBar():GdpsPublishToolBar
		{
			return viewComponent as GdpsPublishToolBar;
		}
		public function get uploadTestBtn():UIButton
		{
			return toolBar.uploadTestBtn;
		}
		public function get uploadTiyanBtn():UIButton
		{
			return toolBar.uploadTiyanBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function reactToUploadTestBtnClick(e:MouseEvent):void
		{
			menuHandler(uploadTestBtn.name);
		}
		
		public function reactToUploadTiyanBtnClick(e:MouseEvent):void
		{
			menuHandler(uploadTiyanBtn.name);
		}
		
		private function menuHandler(s:String):void
		{
			var btnName:String = s;
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = {"btnName": btnName, "confItem": confItem };
			
			
			if (btnName == "uploadTest")
			{
				if(showMsg("3"))//3.已打包状态
				{
					return;
				}
				dat.popupwinSign = GDPSPopupwinSign.GdpsPublishTestPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if(btnName == "uploadTiyan"){
				if(showMsg("4"))//4.已更新发布测试服状态
				{
					return;
				}
				dat.popupwinSign = GDPSPopupwinSign.GdpsPublishTiyanPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
//			else if(btnName == "publish")
//			{
//				if(showMsg("5,6"))//4.已更新发布测试服状态
//				{
//					return;
//				}
//				dat.popupwinSign = GDPSPopupwinSign.PublishModulePublishPopwin_sign;
//				dat.openByAirData = new OpenPopByAirOptions();
//				openPopupwin(dat);
//			}
		}
		
		private function showMsg(state:String=""):Boolean
		{
			var grid:SandyDataGrid = dataGridMediator().publish_grid;
			if (grid.selectedItem == null || grid.selectedItem.SBid == null)
			{
				showError("请先选择一条记录！");
				return true;
			}
			
			/*if(state != "" && state != grid.selectedItem.SState)
			{
			Alert.show("当前状态下不可进行此操作！", "提示");
			return true;
			}*/
			
			return false;
		}
		
		private function dataGridMediator():GdpsPublishDataGridMediator
		{
			return retrieveMediator(GdpsPublishDataGridMediator.NAME + confItem.menuId) as GdpsPublishDataGridMediator;
		}
	}
}
package com.editor.module_gdps.view.tableSpace.mediator
{
	import com.editor.component.controls.UIText;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsLoadingProgressBar;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsTableSpaceToolBar;
	import com.editor.module_gdps.view.tableSpace.GdpsTableSpaceContaier;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class GdpsTableSpaceContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsTableSpaceContainerMediator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsTableSpaceContainerMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsTableSpaceContaier
		{
			return viewComponent as GdpsTableSpaceContaier;
		}
		public function get toolBar():GdpsTableSpaceToolBar
		{
			return content.toolBar;
		}
		public function get infoText():UIText
		{
			return content.infoText;
		}
		public function get tableSpaceDataGridContainer():GdpsModuleDataGrid
		{
			return content.tableSpaceDataGridContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new GdpsTableSpaceToolBarMediator(toolBar, confItem));
			
			registerMediator(new GdpsTabSpaceDataGridMediator(tableSpaceDataGridContainer,confItem));
		}
	}
}
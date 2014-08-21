package com.editor.module_gdps.view.dataManage.mediator
{
	import com.editor.component.controls.UIText;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsDataManagerToolBar;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.view.dataManage.GdpsDataManagerContainer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;

	public class GdpsDataManagerContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsDataManagerContainerMediator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsDataManagerContainerMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsDataManagerContainer
		{
			return viewComponent as GdpsDataManagerContainer;
		}
		public function get toolBar():GdpsDataManagerToolBar
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
			
			registerMediator(new GdpsDataManagerToolBarMediator(toolBar, confItem));
			
			registerMediator(new GdpsDataManagerDataGridMediator(tableSpaceDataGridContainer,confItem));
		}
	}
}
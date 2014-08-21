package com.editor.module_gdps.view.dataBase.mediator
{
	import com.editor.component.controls.UIText;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsDataBaseToolBar;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.view.dataBase.GdpsDataBaseContainer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;

	public class GdpsDataBaseContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsDataBaseContainerMediator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsDataBaseContainerMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsDataBaseContainer
		{
			return viewComponent as GdpsDataBaseContainer;
		}
		public function get toolBar():GdpsDataBaseToolBar
		{
			return content.toolBar;
		}
		public function get infoText():UIText
		{
			return content.infoText;
		}
		public function get databaseFileDataGridContainer():GdpsModuleDataGrid
		{
			return content.databaseFileDataGridContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new GdpsDataBaseToolBarMediator(toolBar, confItem));
			
			registerMediator(new GdpsDataBaseDataGridMediator(databaseFileDataGridContainer,confItem));
		}
	}
}
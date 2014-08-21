package com.editor.module_gdps.view.fileData.mediator
{
	import com.editor.component.controls.UIText;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsFileManagerToolBar;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.view.fileData.GdpsFileDataManagerContainer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;

	public class GdpsFileDataManagerContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsFileDataManagerContainerMediator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsFileDataManagerContainerMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsFileDataManagerContainer
		{
			return viewComponent as GdpsFileDataManagerContainer;
		}
		public function get toolBar():GdpsFileManagerToolBar
		{
			return content.toolBar;
		}
		public function get infoText():UIText
		{
			return content.infoText;
		}
		public function get dataManageDataGridContainer():GdpsModuleDataGrid
		{
			return content.dataManageDataGridContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new GdpsFileDataManagerToolBarMediator(toolBar, confItem));
			
			registerMediator(new GdpsFileDataManagerDataGridMediator(dataManageDataGridContainer,confItem));
		}
	}
}
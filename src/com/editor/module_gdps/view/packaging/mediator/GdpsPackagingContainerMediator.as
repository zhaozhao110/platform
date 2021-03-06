package com.editor.module_gdps.view.packaging.mediator
{
	import com.editor.component.controls.UILabel;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPackagingToolBar;
	import com.editor.module_gdps.view.packaging.GdpsPackagingContainer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;

	public class GdpsPackagingContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsPackagingContainerMediator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsPackagingContainerMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsPackagingContainer
		{
			return viewComponent as GdpsPackagingContainer;
		}
		public function get toolBar():GdpsPackagingToolBar
		{
			return content.toolBar;
		}
		public function get infoText():UILabel
		{
			return content.infoText;
		}
		public function get dataGridContainer():GdpsModuleDataGrid
		{
			return content.dataGridContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new GdpsPackagingToolBarMediator(toolBar, confItem));
			
			registerMediator(new GdpsPackagingDataGridMediator(dataGridContainer,confItem));
		}
	}
}
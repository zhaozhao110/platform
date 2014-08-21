package com.editor.module_gdps.view.serverManage.mediator
{
	import com.editor.component.controls.UIText;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsServerManagerToolBar;
	import com.editor.module_gdps.view.serverManage.GdpsServerManagerContainer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;

	public class GdpsServerManagerContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsServerManagerContainerMediator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsServerManagerContainerMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsServerManagerContainer
		{
			return viewComponent as GdpsServerManagerContainer;
		}

		public function get toolBar():GdpsServerManagerToolBar
		{
			return content.toolBar;
		}
		public function get infoText():UIText
		{
			return content.infoText;
		}
		public function get list():GdpsModuleDataGrid
		{
			return content.list;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new GdpsServerManagerToolBarMediator(toolBar, confItem));
			
			registerMediator(new GdpsServerManagerDataGridMediator(list,confItem));
		}
	}
}
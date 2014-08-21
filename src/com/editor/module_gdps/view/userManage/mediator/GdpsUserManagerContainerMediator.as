package com.editor.module_gdps.view.userManage.mediator
{
	import com.editor.component.controls.UIText;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsUserManagerToolBar;
	import com.editor.module_gdps.view.userManage.GdpsUserManagerContainer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;

	public class GdpsUserManagerContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsUserManagerContainerMediator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsUserManagerContainerMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsUserManagerContainer
		{
			return viewComponent as GdpsUserManagerContainer;
		}
		public function get toolBar():GdpsUserManagerToolBar
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
			
			registerMediator(new GdpsUserManagerToolBarMediator(toolBar, confItem));
			
			registerMediator(new GdpsUserManagerDataGridMediator(list,confItem));
		}
	}
}
package com.editor.module_gdps.view.productManage.mediator
{
	import com.editor.component.controls.UIText;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsProductManagerToolBar;
	import com.editor.module_gdps.view.productManage.GdpsProductManagerContainer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;

	public class GdpsProductManagerContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsProductManagerContainerMediator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsProductManagerContainerMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsProductManagerContainer
		{
			return viewComponent as GdpsProductManagerContainer;
		}
		
		public function get toolBar():GdpsProductManagerToolBar
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
			
			registerMediator(new GdpsProductManagerToolBarMediator(toolBar, confItem));
			
			registerMediator(new GdpsProductManagerDataGridMediator(list,confItem));
		}
	}
}
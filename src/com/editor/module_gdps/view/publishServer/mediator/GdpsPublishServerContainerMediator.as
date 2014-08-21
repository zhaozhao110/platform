package com.editor.module_gdps.view.publishServer.mediator
{
	import com.editor.component.controls.UILabel;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPublishServerToolBar;
	import com.editor.module_gdps.view.publishServer.GdpsPublishServerContainer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	
	public class GdpsPublishServerContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsPublishServerContainerMediator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsPublishServerContainerMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsPublishServerContainer
		{
			return viewComponent as GdpsPublishServerContainer;
		}
		public function get toolBar():GdpsPublishServerToolBar
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
			
			registerMediator(new GdpsPublishServerToolBarMediator(toolBar, confItem));
			
			registerMediator(new GdpsPublishServerDataGridMediator(dataGridContainer,confItem));
		}
	}
}
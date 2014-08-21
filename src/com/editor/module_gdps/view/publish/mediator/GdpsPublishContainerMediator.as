package com.editor.module_gdps.view.publish.mediator
{
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPublishToolBar;
	import com.editor.module_gdps.view.publish.GdpsPublishContainer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;

	public class GdpsPublishContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsPublishContainerMediator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsPublishContainerMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsPublishContainer
		{
			return viewComponent as GdpsPublishContainer;
		}
		public function get toolBar():GdpsPublishToolBar
		{
			return content.toolBar;
		}
		public function get infoText():UILabel
		{
			return content.infoText;
		}
		public function get publishDataGridContainer():GdpsModuleDataGrid
		{
			return content.publishDataGridContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new GdpsPublishTooBarMediator(toolBar, confItem));
			
			registerMediator(new GdpsPublishDataGridMediator(publishDataGridContainer,confItem));
		}
	}
}
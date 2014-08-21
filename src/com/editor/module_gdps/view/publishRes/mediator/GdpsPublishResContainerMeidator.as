package com.editor.module_gdps.view.publishRes.mediator
{
	import com.editor.component.controls.UILabel;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPublishResToolBar;
	import com.editor.module_gdps.view.publishRes.GdpsPublishResContainer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;

	public class GdpsPublishResContainerMeidator extends AppMediator
	{
		public static const NAME:String = "GdpsPublishResContainerMeidator";
		
		//左侧菜单节点的传值数据对象
		private var confItem:AppModuleConfItem;
		
		/**
		 * 数据表对象管理module的主界面构造方法 <br/>
		 *
		 * 增加一个传值参数AppModuleConfItem[用于获取左侧菜单节点的传值数据对象]
		 */
		public function GdpsPublishResContainerMeidator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get content():GdpsPublishResContainer
		{
			return viewComponent as GdpsPublishResContainer;
		}
		public function get toolBar():GdpsPublishResToolBar
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
			
			registerMediator(new GdpsPublishResToolBarMeidator(toolBar, confItem));
			
			registerMediator(new GdpsPublishResDataGridMediator(dataGridContainer,confItem));
		}
	}
}
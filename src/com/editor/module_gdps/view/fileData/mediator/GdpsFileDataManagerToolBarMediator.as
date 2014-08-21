package com.editor.module_gdps.view.fileData.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsFileManagerToolBar;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	
	import flash.events.MouseEvent;

	public class GdpsFileDataManagerToolBarMediator extends AppMediator
	{
		public static const NAME:String = "GdpsFileDataManagerToolBarMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsFileDataManagerToolBarMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get toolBar():GdpsFileManagerToolBar
		{
			return viewComponent as GdpsFileManagerToolBar;
		}
		public function get addBtn():UIButton
		{
			return toolBar.addBtn;
		}
		public function get motifyBtn():UIButton
		{
			return toolBar.motifyBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function reactToAddBtnClick(e:MouseEvent):void
		{
			menuHandler(addBtn.name);
		}
		
		public function reactToMotifyBtnClick(e:MouseEvent):void
		{
			menuHandler(motifyBtn.name);
		}
		
		
		/**
		 * 点击菜单
		 *
		 * @param btnName
		 * @param btnId
		 */
		private function menuHandler(s:String):void
		{
			var btnName:String = s;
			
		}
	}
}
package com.editor.module_ui.app.css
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UITabBar;
	import com.editor.mediator.AppMediator;
	import com.editor.module_ui.css.CSSShowContainer;
	import com.editor.module_ui.css.CSSShowContainerMediator;
	import com.editor.module_ui.vo.CSSComponentData;
	
	public class CSSEditorMediator extends AppMediator
	{
		public static const NAME:String = "CSSEditorMediator"
		public function CSSEditorMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get css():CSSEditor
		{
			return viewComponent as CSSEditor;
		}
		public function get toolBar():CSSEditorTopBar
		{
			return css.toolBar;
		}
		public function get content():UICanvas
		{
			return css.content;
		}
		public function get showContainer():CSSShowContainer
		{
			return css.showContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new CSSEditorTopBarMediator(toolBar));
			registerMediator(new CSSShowContainerMediator(showContainer));
		}
		
		
		
		
	}
}
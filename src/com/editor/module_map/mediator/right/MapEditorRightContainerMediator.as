package com.editor.module_map.mediator.right
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.manager.MapEditorManager;
	import com.editor.module_map.mediator.right.layout.MapEditorLayoutContainerMediator;
	import com.editor.module_map.view.right.MapEditorRightContainer;
	import com.editor.module_map.view.right.layout.MapEditorLayoutContainer;
	import com.editor.module_map.vo.map.MapSceneItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	import com.sandy.resource.interfac.ILoadSourceData;
	
	import flash.display.Loader;

	public class MapEditorRightContainerMediator extends AppMediator
	{	
		public static const NAME:String = "MapEditorRightContainerMediator";
		
		public function MapEditorRightContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():MapEditorRightContainer
		{
			return viewComponent as MapEditorRightContainer;
		}
		public function get layoutContainer():MapEditorLayoutContainer
		{
			return mainUI.layoutContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			registerMediator(new MapEditorLayoutContainerMediator(layoutContainer));
			
		}
		
		
		
		
		
	}
}
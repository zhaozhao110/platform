package com.editor.d3.app.manager
{
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.app.scene.grid.D3GridScene;
	import com.editor.d3.app.view.ui.bottom.App3DBottomContainerMediator;
	import com.editor.d3.app.view.ui.left.App3DLeftContainerMediator;
	import com.editor.d3.app.view.ui.right.App3DRightContainerMediator;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.event.D3Event;
	import com.editor.event.App3DEvent;
	import com.editor.manager.DataManager;
	import com.sandy.manager.SandyManagerBase;

	public class Stack3DManager extends SandyManagerBase
	{
		private static var instance:Stack3DManager ;
		public static function getInstance():Stack3DManager{
			if(instance == null){
				instance =  new Stack3DManager();
			}
			return instance;
		}
		
		public var currStack:int;
		public static var isParticleStack:Boolean;
		
		public function changeStack(type:int):Boolean
		{
			if(currStack == type) return false;
			currStack = type;
			
			if(currStack == D3ComponentConst.stack3d_scene)
			{
				get_App3DMainUIContainerMediator().container.mainVS.selectedIndex = 0;
				isParticleStack = false;
				get_App3DLeftContainerMediator().leftContainer.visible = true;
				get_App3DBottomContainerMediator().bottomContainer.visible = true;
				
				View3DManager.getInstance().closeView(DataManager.pop3d_particle);
				
				View3DManager.getInstance().open3DViews();
				get_App3DBottomContainerMediator().bottomContainer.visible = true
				
				var scene:D3GridScene = D3SceneManager.getInstance().createScene(type);
				scene.resetData();
				
			}
			else if(currStack == D3ComponentConst.stack3d_particle)
			{
				get_App3DMainUIContainerMediator().container.mainVS.selectedIndex = 0;
				isParticleStack = true;
				get_App3DLeftContainerMediator().leftContainer.visible = false
				//get_App3DBottomContainerMediator().bottomContainer.visible = false
					
				View3DManager.getInstance().closeView(DataManager.pop3d_project);
				View3DManager.getInstance().closeView(DataManager.pop3d_attri);
				View3DManager.getInstance().closeView(DataManager.pop3d_source);
				get_App3DBottomContainerMediator().bottomContainer.visible = false;
				
				View3DManager.getInstance().openView(DataManager.pop3d_particle);
				
				scene = D3SceneManager.getInstance().createScene(type);
				scene.resetData();
				
			}
			/*else if(currStack == D3ComponentConst.stack3d_particle2)
			{
				isParticleStack = false;
				get_App3DMainUIContainerMediator().container.mainVS.selectedIndex = 1;
				
			}*/
			
			sendAppNotification(D3Event.change_stackMode3d_event,null,type.toString());
			
			return true;
		}
		
		private function get_App3DRightContainerMediator():App3DRightContainerMediator
		{
			return iManager.retrieveMediator(App3DRightContainerMediator.NAME) as App3DRightContainerMediator;
		}
		
		private function get_App3DLeftContainerMediator():App3DLeftContainerMediator
		{
			return iManager.retrieveMediator(App3DLeftContainerMediator.NAME) as App3DLeftContainerMediator;
		}
		
		private function get_App3DBottomContainerMediator():App3DBottomContainerMediator
		{
			return iManager.retrieveMediator(App3DBottomContainerMediator.NAME) as App3DBottomContainerMediator;
		}
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
	}
}
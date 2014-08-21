package com.editor.d3.manager
{
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.manager.View3DManager;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.view.attri.group.D3AttriGroup2View;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.manager.data.KeyStringCodeConst;

	public class D3KeybroadManager
	{
		private static var instance:D3KeybroadManager ;
		public static function getInstance():D3KeybroadManager{
			if(instance == null){
				instance =  new D3KeybroadManager();
			}
			return instance;
		}
		
		public function init():void
		{
			addEditKeybroad();
			
			var d:Object = {label:"坐标系",data:"T"};keyBroad_ls.push(d);
			d = {label:"网格",data:"G"};keyBroad_ls.push(d);
			d = {label:"物体显示/隐藏",data:"V"};keyBroad_ls.push(d);
			d = {label:"聚焦物体",data:"H"};keyBroad_ls.push(d);
			d = {label:"移动",data:"W"};keyBroad_ls.push(d);
			d = {label:"缩放",data:"E"};keyBroad_ls.push(d);
			d = {label:"旋转",data:"R"};keyBroad_ls.push(d);
			d = {label:"选中全局",data:"Q"};keyBroad_ls.push(d);
		}
		
		public var keyBroad_ls:Array = [];
		
		//////////////////////////////////// edit //////////////////////////////////
		
		private function addEditKeybroad():void
		{
			removeEditKeybroad();
			iManager.iKeybroad.addKeyDownListener(KeyStringCodeConst.T,onTrident);
			iManager.iKeybroad.addKeyDownListener(KeyStringCodeConst.G,onGrid);
			iManager.iKeybroad.addKeyDownListener(KeyStringCodeConst.V,onMapItemVisible);
			iManager.iKeybroad.addKeyDownListener(KeyStringCodeConst.H,focusInTarget);
			iManager.iKeybroad.addKeyDownListener(KeyStringCodeConst.Q,selectSystem);
		}
		
		private function removeEditKeybroad():void
		{
			iManager.iKeybroad.removeKeyDownListener(KeyStringCodeConst.T,onTrident);
			iManager.iKeybroad.removeKeyDownListener(KeyStringCodeConst.G,onGrid);
			iManager.iKeybroad.removeKeyDownListener(KeyStringCodeConst.V,onMapItemVisible);
			iManager.iKeybroad.removeKeyDownListener(KeyStringCodeConst.Q,selectSystem);
		}
		
		private function selectSystem(e:*=null):void
		{
			iManager.sendAppNotification(D3Event.select3DComp_event);
		}
		
		public static var parseObject:*;
		public static var parseNode:D3TreeNode;
		public static var isCut:Boolean;
		
		private function onTrident(e:*=null):void
		{
			D3AttriGroup2View.instance.onTrident();
		}
		
		private function onGrid(e:*=null):void
		{
			D3AttriGroup2View.instance.onGrid();
		}
		
		private function onMapItemVisible(e:*=null):void
		{
			if(D3SceneManager.getInstance().displayList.selectedComp == null)return ;
			if(D3SceneManager.getInstance().displayList.selectedComp.proccess == null)return ;
			if(D3SceneManager.getInstance().displayList.selectedComp.proccess.mapItem == null)return ;
			D3SceneManager.getInstance().displayList.selectedComp.proccess.mapItem.setMapItemVisible();
		}
		
		private function focusInTarget(e:*=null):void
		{
			if(D3SceneManager.getInstance().displayList.selectedComp == null)return ;
			if(D3SceneManager.getInstance().displayList.selectedComp.proccess == null)return ;
			if(D3SceneManager.getInstance().displayList.selectedComp.proccess.mapItem == null)return ;
			D3SceneManager.getInstance().cameraMM.focusTarget(D3SceneManager.getInstance().displayList.selectedComp.proccess.mapItem.getObject());
		}
		
		
		
		//////////////////////////////////// preview //////////////////////////////////
		
		
		
		
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
		protected static function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
	}
}
package com.editor.module_skill.battle
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_skill.battle.control.MapRenderControl;
	import com.editor.module_skill.battle.data.CreateMapItemData;
	import com.editor.module_skill.battle.view.BattleBackground;
	import com.editor.module_skill.battle.view.BattleItemContainer;
	import com.editor.module_skill.mediator.SkillSeqModuleMediator;
	import com.editor.module_skill.mediator.SkillSeqRightContainerMediator;
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.render2D.map.SandyMap;
	import com.sandy.render2D.map.data.SandyMapData;
	import com.sandy.render2D.map2.SandyMap2;
	import com.sandy.render2D.map2.data.SandyMapData2;
	import com.sandy.render2D.mapBase.loader.SandyMapLoaderManager;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.DisplayObject;
	

	public class BattleContainer extends SandyMap2
	{
		public function BattleContainer()
		{
			super("battleMap");
			instace = this;
			CreateMapItemData.battle = this;
			create_init();
			mouseChildren = false;
			mouseEnabled = false;
			alpha = 1;
		}
		
		public static var instace:BattleContainer;
		
		public var mediator:SkillSeqRightContainerMediator;
		public var battleItemContainer:BattleItemContainer;
		
		override protected function __map_init__():void
		{
			super.__map_init__();
			
			//渲染初始化
			renderControl = new MapRenderControl(this);
			
			SandyMapLoaderManager.enabled_showQueue = false;
			
			//地图数据
			mapData = new SandyMapData2();
			mapData.stageOffsetX = 0;
			mapData.stageOffsetY = 0;
		}
		
		private function create_init():void
		{
			ground = new BattleBackground(this);
			addChild(ground as DisplayObject);
			
			roleScene = new BattleItemContainer(this);
			addChild(roleScene as DisplayObject);
			battleItemContainer = roleScene as BattleItemContainer;
			
			startEnterFrame()
			renderComplete();
		}
		
		override public function renderComplete():void
		{
			super.renderComplete();
			mapShow();
		}
				
		override public function reset():void
		{
			battleItemContainer.dispose();
		}
		
		override protected function callFrame(delta:*=null):void
		{
			super.callFrame(delta);
			renderControl.update(delta);
			visible = true;
		}
				
		public function get_EditSkillProxy():EditSkillProxy
		{
			return mediator.retrieveProxy(EditSkillProxy.NAME) as EditSkillProxy
		}
		
		public function get_SkillSeqModuleMediator():SkillSeqModuleMediator
		{
			return mediator.retrieveMediator(SkillSeqModuleMediator.NAME) as SkillSeqModuleMediator;
		}
		
		public function stopEnterFrame():void
		{
			stopTimer();
		}
		
		override protected function startTimer():void{}
		
		public function startEnterFrame():void
		{
			super.startTimer();
		}
		
		override public function get sceneType():int
		{
			return 1;
		}
		
	}
}
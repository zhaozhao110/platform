package com.editor.moudule_drama.battle
{
	import com.editor.component.containers.UICanvas;
	import com.editor.moudule_drama.battle.control.MapRenderControl;
	import com.editor.moudule_drama.battle.data.CreateMapItemData;
	import com.editor.moudule_drama.battle.view.BattleBackground;
	import com.editor.moudule_drama.battle.view.BattleItemContainer;
	import com.editor.module_skill.mediator.SkillSeqModuleMediator;
	import com.editor.module_skill.mediator.SkillSeqRightContainerMediator;
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.render2D.map.SandyMap;
	import com.sandy.render2D.map.data.SandyMapData;
	import com.sandy.render2D.map2.SandyMap2;
	import com.sandy.render2D.map2.data.SandyMapData2;
	
	import flash.display.DisplayObject;
	

	public class BattleContainer extends SandyMap2
	{
		public function BattleContainer()
		{
			super("battleMap");
			instace = this;
			CreateMapItemData.battle = this;
			create_init();
		}
		
		public static var instace:BattleContainer;
		
		public var mediator:SkillSeqRightContainerMediator;
		
		
		override protected function __map_init__():void
		{
			super.__map_init__();
			
			//渲染初始化
			renderControl = new MapRenderControl(this);
			
			//地图数据
			mapData = new SandyMapData2(this);
			mapData.stageOffsetX = 0;
			mapData.stageOffsetY = 0;
		}
		
		private function create_init():void
		{
			percentHeight 	= 100;
			percentWidth 	= 100;
						
			ground = new BattleBackground(this);
			addChild(ground as DisplayObject);
			
			roleScene = new BattleItemContainer(this);
			addChild(roleScene as DisplayObject);
			battleItemContainer = roleScene as BattleItemContainer;
			
			//startEnterFrame()
			renderComplete();
		}
		
		public var battleItemContainer:BattleItemContainer;
		
		override public function reset():void
		{
			battleItemContainer.dispose();
		}
		
		public function get_EditSkillProxy():EditSkillProxy
		{
			return mediator.retrieveProxy(EditSkillProxy.NAME) as EditSkillProxy
		}
		
		public function get_SkillSeqModuleMediator():SkillSeqModuleMediator
		{
			return mediator.retrieveMediator(SkillSeqModuleMediator.NAME) as SkillSeqModuleMediator;
		}
		
	}
}
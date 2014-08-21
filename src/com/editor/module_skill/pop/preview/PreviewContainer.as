package com.editor.module_skill.pop.preview
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.preview.PreviewBattle;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;

	public class PreviewContainer extends UIVBox
	{
		public function PreviewContainer()
		{
			super();
			create_init();
		}
		
		public var battle:PreviewBattle;
		public var closeBtn:UIButton;
		public var againBtn:UIButton;
		
		private function create_init():void
		{
			backgroundColor = ColorUtils.black;
			visible = false;
			horizontalCenter = 0;
			verticalCenter = 0;
			this.width = 1200;
			this.height = 700;
			
			styleName = "uicanvas"
			
			var c:UICanvas = new UICanvas();
			c.percentWidth = 100;
			c.height = 650;
			c.clipContent = true;
			addChild(c);
			
			battle = new PreviewBattle();
			c.addChild(battle);
			
			var h:UIHBox = new UIHBox();
			h.percentWidth = 100;
			h.horizontalGap = 10;
			h.horizontalAlign = ASComponentConst.horizontalAlign_center;
			h.height = 50;
			addChild(h);
			
			againBtn = new UIButton();
			againBtn.label = "重新预览"
			h.addChild(againBtn);
			
			closeBtn = new UIButton();
			closeBtn.label = "关闭预览";
			h.addChild(closeBtn);
		}
		
		
	}
}
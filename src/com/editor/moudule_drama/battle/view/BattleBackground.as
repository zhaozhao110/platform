package com.editor.moudule_drama.battle.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIImage;
	import com.editor.moudule_drama.battle.BattleContainer;
	import com.editor.services.Services;
	import com.sandy.component.core.SandySprite;
	import com.sandy.render2D.map.SandyMapGround;
	import com.sandy.render2D.map.SandyMapSprite;
	import com.sandy.render2D.map2.SandyMapGround2;
	import com.sandy.render2D.map2.interfac.ISandyMap2;

	public class BattleBackground extends SandyMapGround2
	{
		public function BattleBackground(_imap:ISandyMap2=null)
		{
			super(_imap);
			create_init();
		}
		
	/*	[Embed(source="assets/img/mapBackground.jpg")]
		public var backCls:Class;*/
		
		private var img:UIImage;
		
		private function create_init():void
		{
			this.width = 2432;
			this.height = 700;
			
			img = new UIImage();
			img.source = Services.editSkill_background;
			addChild(img);
		}
	}
}
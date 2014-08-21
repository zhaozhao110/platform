package com.editor.module_skill.pop.preview
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.module_skill.preview.PreviewBattle;
	
	import flash.events.MouseEvent;

	public class PreviewContainerMediator extends AppMediator
	{
		public static const NAME:String = "PreviewContainerMediator";
		public function PreviewContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get previewWin():PreviewContainer
		{
			return viewComponent as PreviewContainer;
		}
		public function get closeBtn():UIButton
		{
			return previewWin.closeBtn;
		}
		public function get battle():PreviewBattle
		{
			return previewWin.battle;
		}
		public function get againBtn():UIButton
		{
			return previewWin.againBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function start():void
		{
			if(previewWin.visible) return ;
			previewWin.visible = true;
			battle.start();
		}
		
		public function reactToCloseBtnClick(e:MouseEvent):void
		{
			stop();
		}
		
		public function reactToAgainBtnClick(e:MouseEvent):void
		{
			battle.playAgain();
		}
		
		public function stop():void
		{
			previewWin.visible = false
			battle.stop();
		}
		
	}
}
package com.editor.module_skill.battle.role
{
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.data.EffectData;
	import com.sandy.math.SandyPoint;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.utils.LoadContextUtils;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;

	public class EffectItem extends MapItem
	{
		public function EffectItem(_map:ISandyMap2=null)
		{
			super(_map);
		}
		
		public var content:MovieClip;
		
		private function removeContent():void
		{
			UIComponentUtil.removeMovieClipChild(child_container,content);
			content = null
		}
				
		override public function render(ida:*):void
		{
			super.render(ida);	
			
			removeContent();
			var pngURL:String = (data as EffectData).getActionSign(actionType,imap);
			startSwfLoad(pngURL);
		}
		
		override protected function loadSwfComplete(value:*=null):void
		{
			super.loadSwfComplete();
			
			content = iManager.iResource.getDisplayObject("e"+(data as EffectData).resInfoItem.id,getLoadApplicationDomain()) as MovieClip;
			$addChild(content);
			
			content.addFrameScript(content.totalFrames-1,playEndHandle);
			stop()
		}
		
		private function playEndHandle():void
		{
			stop()
		}
		
		public function play(pixel:SandyPoint=null):void
		{
			if(content == null) return ;
			if(pixel!=null){
				pixelLoc = pixel;
			}
			content.play();
			visible = true;
		}
		
		public function stop():void
		{
			if(content == null) return ;
			content.stop();
			visible = false;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeContent();
		}
		
		override public function gotoActionForward(_action:String="", _forward:int=0):void{};
		override public function startParserAnimation(url:String,_act:String):void{};
		
	}
}
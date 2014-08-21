package com.editor.module_map.view.right.layout.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_map.vo.map.MapSceneResItemVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class LayoutSpriteContainer extends LayoutDisplayObject
	{
		public function LayoutSpriteContainer()
		{
			super();
			create_init();
		}
		
		public var spriteContainer:UICanvas;
		private function create_init():void
		{			
			spriteContainer = new UICanvas();
			addChild(spriteContainer);
						
		}
		
		public function addSprite(sprite:LayoutSprite):void
		{
			spriteContainer.addChild(sprite);
			sprite.parentContainer = this;
		}
		public function removeSprite(sprite:LayoutSprite):void
		{
			spriteContainer.removeChild(sprite);
			sprite.parentContainer = null;
		}
		public function setSpriteIndex(sprite:LayoutSprite, index:int):void
		{
			if(spriteContainer.contains(sprite) && index < spriteContainer.numChildren)
			{
				spriteContainer.setChildIndex(sprite, index);		
			}
				
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			var len:int = spriteContainer.numChildren;
			for(var i:int=len-1;i>=0;i--)
			{
				var sprite:LayoutSprite = spriteContainer.getChildAt(i) as LayoutSprite;
				if(sprite)
				{
					spriteContainer.removeChild(sprite);
					sprite.dispose();
					sprite = null;
				}
				
			}
			
			spriteContainer.dispose();
			spriteContainer = null;
			
		}

		
		
		
	}
}
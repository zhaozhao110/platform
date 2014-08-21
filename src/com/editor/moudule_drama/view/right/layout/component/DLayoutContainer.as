package com.editor.moudule_drama.view.right.layout.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_map.vo.map.MapSceneResItemVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class DLayoutContainer extends DLayoutDisplayObject
	{
		public function DLayoutContainer()
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
		
		public function addSprite(sprite:DLayoutSprite):void
		{
			spriteContainer.addChild(sprite);
			sprite.parentContainer = this;
		}
		public function removeSprite(sprite:DLayoutSprite):void
		{
			if(spriteContainer.contains(sprite))
			{
				spriteContainer.removeChild(sprite);
			}
			
		}
		public function setSpriteIndex(sprite:DLayoutSprite, index:int):void
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
				var sprite:DLayoutSprite = spriteContainer.getChildAt(i) as DLayoutSprite;
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
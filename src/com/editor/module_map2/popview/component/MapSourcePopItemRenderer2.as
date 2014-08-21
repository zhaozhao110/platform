package com.editor.module_map2.popview.component
{
	import com.editor.module_map2.manager.MapEditor2Manager;
	import com.editor.module_map2.popview.MapSourceInfoPopView2;
	import com.editor.module_map2.view.items.Building2;
	import com.sandy.component.itemRenderer.SandyHListItemRenderer;
	
	import flash.events.MouseEvent;
	
	public class MapSourcePopItemRenderer2 extends SandyHListItemRenderer
	{
		public function MapSourcePopItemRenderer2()
		{
			super();
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			mouseEnabled = true;
			mouseChildren = true;
			
			toolTip = Building2(data).getVBoxId+"<br>cell:"+
				Building2(data).getCellPoint().toString()+
				"<br>pixel:(x:"+Building2(data).x+",y:"+Building2(data).y+")"
			
			addIcon();
			icon.addEventListener(MouseEvent.CLICK,onClick)
				
			this.addEventListener(MouseEvent.CLICK , onClick2);
		}
		
		private function onClick(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			MapEditor2Manager.bottomContainerMediator.removeBuild(Building2(data));
		}
		
		override protected function getIconSource():String
		{
			return "close2_a";
		}
		
		override protected function getIconWidth():int
		{
			return 16
		}
		
		override protected function getIconHeight():int
		{
			return 16
		}
		
		private function onClick2(e:MouseEvent):void
		{
			MapSourceInfoPopView2.instance.showUI(Building2(data));
		}
		
	}
}
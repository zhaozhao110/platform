package com.editor.module_mapIso.popview.component
{
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_mapIso.popview.MapSourceInfoPopView;
	import com.editor.module_mapIso.view.items.Building;
	import com.sandy.component.itemRenderer.SandyHListItemRenderer;
	
	import flash.events.MouseEvent;
	
	public class MapSourcePopItemRenderer extends SandyHListItemRenderer
	{
		public function MapSourcePopItemRenderer()
		{
			super();
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			mouseEnabled = true;
			mouseChildren = true;
			
			toolTip = Building(data).getVBoxId+"<br>cell:"+
				Building(data).getCellPoint().toString()+
				"<br>pixel:(x:"+Building(data).x+",y:"+Building(data).y+")"
			
			addIcon();
			icon.addEventListener(MouseEvent.CLICK,onClick)
				
			this.addEventListener(MouseEvent.CLICK , onClick2);
		}
		
		private function onClick(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			MapEditorIsoManager.bottomContainerMediator.removeBuild(Building(data));
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
			MapSourceInfoPopView.instance.showUI(Building(data));
		}
		
	}
}
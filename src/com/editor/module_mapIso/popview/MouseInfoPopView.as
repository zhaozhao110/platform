package com.editor.module_mapIso.popview
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;

	public class MouseInfoPopView extends MapIsoPopViewBase
	{
		public function MouseInfoPopView()
		{
			super();
			if(instance == null){
				instance = this;
			}
		}
		
		override protected function get titles():String
		{
			return "鼠标信息";	
		}
		
		public static var instance:MouseInfoPopView;
		
		private var xTI:UILabel;
		private var yTI:UILabel;
		private var xTile:UILabel;
		private var yTile:UILabel;
		
		override protected function create_init():void
		{
			width = 225;
			height = 167;
			super.create_init();
			
			xTI = new UILabel();
			xTI.height = 25;
			addContent(xTI);
			
			yTI = new UILabel();
			yTI.height = 25;
			addContent(yTI);
			
			xTile = new UILabel();
			xTile.height = 25;
			addContent(xTile);
			
			yTile = new UILabel();
			yTile.height = 25;
			addContent(yTile);
		}
		
		public function reflashMouse(obj:Object):void
		{
			if(!visible) return ;
			xTI.text = "像素坐标X：" + obj.px;
			yTI.text = "像素坐标Y：" + obj.py;
			xTile.text = "网格索引X：" + obj.ix;
			yTile.text = "网格索引Y：" + obj.iy;
		}
		
	}
}
package com.editor.module_roleEdit.pop.preview
{
	import com.editor.component.containers.UICanvas;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.utils.setTimeout;

	public class PeopleImagePreviewImageContainer extends UICanvas
	{
		public function PeopleImagePreviewImageContainer()
		{
			super();
			
			this.width = 500;
			this.height = 500;
			verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			
			img = new PeopleImagePreviewImage();
			addChild(img);
			
			setTimeout(scrollToMiddle,1000);
		}
		
		private function scrollToMiddle():void
		{
			if(vscrollbar!=null){
				vscrollbar.scrollToMiddle();
			}
			if(hscrollbar!=null){
				hscrollbar.scrollToMiddle();
			}
		}
		
		public var img:PeopleImagePreviewImage;
		
		/**
		 * 当前方向
		 */ 
		private var _forward:int;
		public function get forward():int
		{
			return _forward;
		}
		public function set forward(value:int):void
		{
			_forward = value;
			img.forward = _forward;
		}
		
		
	}
}
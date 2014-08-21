package com.editor.module_roleEdit.pop.preview2
{
	import com.editor.component.containers.UICanvas;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.utils.setTimeout;

	public class PeopleImagePreviewImageContainer2 extends UICanvas
	{
		public function PeopleImagePreviewImageContainer2()
		{
			super();
			
			this.width = 1000;
			this.height = 530;
			verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			
			img = new PeopleImagePreviewImage2();
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
		
		public var img:PeopleImagePreviewImage2;
		
		
	}
}
package com.editor.module_api.view
{
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.containers.SandyVBox;
	import com.sandy.component.controls.SandyVList;

	public class ApiModuleLeftCont extends SandyVBox
	{
		public function ApiModuleLeftCont()
		{
			super();
			create_init();
		}
		
		public var pack_box:SandyVList;
		public var cls_box:SandyVList;
		
		private function create_init():void
		{
			percentHeight =100;
			width = 300
			styleName = "uicanvas"
			verticalGap = 10;
			
			pack_box = new SandyVList();
			pack_box.percentWidth = 100;
			pack_box.percentHeight = 50;
			pack_box.enabeldSelect = true;
			pack_box.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(pack_box);
			
			cls_box = new SandyVList();
			cls_box.percentWidth = 100;
			cls_box.percentHeight = 50;
			cls_box.enabeldSelect = true
			cls_box.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(cls_box);
			
		}
	}
}
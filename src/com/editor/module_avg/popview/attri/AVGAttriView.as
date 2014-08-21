package com.editor.module_avg.popview.attri
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.manager.DataManager;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.vo.AVGResData;
	import com.sandy.math.HashMap;

	public class AVGAttriView extends UICanvas
	{
		public function AVGAttriView()
		{
			super();
			instance = this;
			create_init();
		}
		
		public static var instance:AVGAttriView;
		
		private function create_init():void
		{
			//visible = false;
			width = 300;
			height = 650;
			y = 50 
		}
		
		private var attri_ls:HashMap = new HashMap();
		
		public function setAttri(d:AVGResData):void
		{
			if(d == null) return ;
			setAllChildVisible(false);
			
			var cell:AVGAttriCell
			if(attri_ls.find(d.getResType().toString()) == null){
				cell = new AVGAttriCell();
				attri_ls.put(d.getResType().toString(),cell);
				addChild(cell);
			}else{
				cell = attri_ls.find(d.getResType().toString());
			}
			cell.create(d);
			AVGManager.currAttriView = cell;
		}
		
	}
}
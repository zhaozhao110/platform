package com.editor.module_skill.timeline
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.manager.DataManager;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.manager.data.SandyData;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class TimelineContainer extends UIVBox
	{
		public function TimelineContainer()
		{
			super();
			instance = this;
			create_init()
		}
		
		public static var instance:TimelineContainer;
		
		public var head:TimelineHead;
		public var bottomC:TimelineBottom;
		public var rowLeftBox:UIVBox;
		public var rowRightBox:UICanvas;
		
		private var later_n:int;
		private var interval_n:uint;
		
		public var row_ls:Array = [];
		
		private function create_init():void
		{
			name = "TimelineContainer"
			styleName = "uicanvas";
			backgroundColor = DataManager.def_col;
			x = 5;
			y = 2;
			percentWidth =100;
			height = 250;
					
			var hb1:UICanvas = new UICanvas();
			hb1.height = 200
			hb1.percentWidth = 100;
			addChild(hb1);
			
			rowLeftBox = new UIVBox();
			rowLeftBox.width = 100;
			rowLeftBox.height = 180
			hb1.addChild(rowLeftBox);
			rowLeftBox.y = 20;
			
			var vb2:UIVBox = new UIVBox();
			vb2.percentWidth = 100;
			vb2.height = 200
			vb2.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			hb1.addChild(vb2);
			vb2.x = 100;
			
			head = new TimelineHead();
			vb2.addChild(head);
						
			rowRightBox = new UICanvas();
			rowRightBox.width = EditSkillManager.timeline_w;
			rowRightBox.height = 200;
			vb2.addChild(rowRightBox);
			
			interval_n = setInterval(later_createRow,500);
		}
				
		private function later_createRow():void
		{
			createRow(EditSkillManager.row_ls[later_n],later_n);
			later_n += 1;
			
			if(later_n == (EditSkillManager.row_ls.length)){
				clearInterval(interval_n);
				
				if(bottomC==null){
					
					var sp:ASSpace = new ASSpace();
					sp.height = 5;
					addChild(sp);
					
					bottomC = new TimelineBottom();
					addChild(bottomC);
				}
			}
		}
		
		public function getTimeRect(row:int,frame:int):TimelineRect
		{
			if(row_ls[row.toString()] == null) return null;
			return TimelineRow(row_ls[row.toString()]).getTimeRect(frame);
		}
		
		private function createRow(d:SandyData,i:int):void
		{
			var rowl:TimelineRowLeft = new TimelineRowLeft();
			rowl.data = d;
			rowLeftBox.addChild(rowl);
			rowl.reflash();
			 
			var row:TimelineRow = new TimelineRow();
			row.data = d;
			row.leftRow = rowl;
			rowRightBox.addChild(row);
			row.reflash();
			row.y = 20*i
		}
		
		override public function reset():void
		{
			var a:Array = EditSkillManager.row_ls;
			for(var i:int=0;i<a.length;i++)
			{
				var d:SandyData = a[i] as SandyData;
				TimelineRow(row_ls[int(d.getKey())]).reset();
			}
			bottomC.reset();
		}
	}
}
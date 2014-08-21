package com.editor.module_ui.view.uiAttri.itemRenderer
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.view.uiAttri.ComToolAttriCell;
	import com.editor.module_ui.vo.UITreeNode;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class BoxCell extends UIVBox
	{
		public function BoxCell()
		{
			super();
			
			enabledPercentSize = true;
			
			lb = new UILabel();
			lb.height = 22;
			lb.text = "所有子组件：";
			addChild(lb);
			
			compList = new UIVBox();
			compList.styleName = "list"
			compList.width = 280;
			compList.height = 200;
			compList.variableRowHeight = true;
			compList.itemRenderer = ComToolCompItemRenderer;
			compList.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			compList.addEventListener(ASEvent.CHILDADD,onChildHandle)
			addChild(compList);
		}
		
		private var lb:UILabel;
		private var compList:UIVBox;
		public var cell:ComToolAttriCell;
		
		private function onChildHandle(e:ASEvent):void
		{
			var rend:ComToolCompItemRenderer = e.data as ComToolCompItemRenderer;
			if(rend!=null){
				rend.toolCell = this;
			}
		}
		
		public function reflash():void
		{
			var a:Array = UIEditManager.currEditShowContainer.selectedUI.node.getList();
			var out:Array = []
			for(var i:int=0;i<a.length;i++){
				var n:UITreeNode = a[i] as UITreeNode;
				out.push({name:UIShowCompProxy(n.obj).name,index:UIShowCompProxy(n.obj).index,data:UIShowCompProxy(n.obj)})
			}
			out = out.sortOn("index",Array.NUMERIC);
			compList.dataProvider = out;
		}
		
		
	}
}
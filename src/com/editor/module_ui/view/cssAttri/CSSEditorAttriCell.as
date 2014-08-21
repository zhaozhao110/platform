package com.editor.module_ui.view.cssAttri
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;

	public class CSSEditorAttriCell extends UIVBox
	{
		public function CSSEditorAttriCell()
		{
			super();
		}
		
		override protected function __init__():void
		{
			super.__init__();
			enabledPercentSize = true;
			
			/*var lb:UILabel = new UILabel();
			lb.color = ColorUtils.blue;
			lb.text = " -- 基本属性 --"
			lb.height = 22;
			addChild(lb);*/
			
			/*baseAttriVBox = new UIVBox();
			baseAttriVBox.padding = 3;
			baseAttriVBox.percentWidth = 100;
			baseAttriVBox.height = 330
			baseAttriVBox.styleName = "uicanvas"
			baseAttriVBox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			baseAttriVBox.itemRenderer = CSSEditorAttriCellItemRenderer;
			addChild(baseAttriVBox);*/
			
			var lb:UILabel = new UILabel();
			lb.color = ColorUtils.blue;
			lb.text = "-- 样式属性 --"
			lb.height = 22;
			addChild(lb);
			
			styleAttriVBox = new UIVBox();
			styleAttriVBox.padding = 3;
			styleAttriVBox.percentWidth = 100;
			styleAttriVBox.height = 600
			styleAttriVBox.styleName = "uicanvas"
			styleAttriVBox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			styleAttriVBox.itemRenderer = CSSEditorStyleCellItemRenderer;
			addChild(styleAttriVBox);
		}
		
		private var baseAttriVBox:UIVBox;
		private var styleAttriVBox:UIVBox;
		public var selectIndex:int;
		private var comp_data:CSSComponentData;
		
		public function setComp(d:CSSComponentData):void
		{
			comp_data = d;
			renderStyle();
		}
		
		private function renderStyle():void
		{
			if(styleAttriVBox.numChildren == 0){
				styleAttriVBox.dataProvider = comp_data.item.styleList;
			}
			
			var len:int = styleAttriVBox.numChildren;
			for(var i:int=0;i<len;i++)
			{
				var cell:CSSEditorStyleCellItemRenderer = styleAttriVBox.getChildAt(i) as CSSEditorStyleCellItemRenderer;
				if(cell.comp!=null&&comp_data.paser.getValue(cell.comp.item.key)!=null){
					cell.setCompValue(comp_data.paser.getValue(cell.comp.item.key).getVO())
				}
			}
		}
		
		public function getAllList():Array
		{
			return getStyleList();
		}
		
		private function getStyleList():Array
		{
			var out:Array = [];
			var ui:IComBase;
			var len:int = styleAttriVBox.numChildren;
			for(var i:int=0;i<len;i++){
				ui = (styleAttriVBox.getChildAt(i) as CSSEditorAttriCellItemRenderer).comp;
				out.push(ui);
			}
			return out;
		}
		
		public function getAllDataList():Array
		{
			var a:Array = getAllList();
			var data_ls:Array = [];
			for(var i:int=0;i<a.length;i++){
				var ui:IComBase = a[i] as IComBase;
				if(ui!=null){
					var vo:IComBaseVO = ui.getValue();
					if(vo!=null){
						data_ls[vo.key] = vo;
					}
				}
			}
			return data_ls;
		}
		
	}
}
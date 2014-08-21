package com.editor.module_ui.view.uiAttri
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.view.uiAttri.com.ComBoolean;
	import com.editor.module_ui.view.uiAttri.com.ComButton;
	import com.editor.module_ui.view.uiAttri.com.ComCombobox;
	import com.editor.module_ui.view.uiAttri.com.ComInput;
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.ComComboboxVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.module_ui.vo.component.ComItemVO;
	import com.editor.module_ui.vo.component.ComListVO;
	import com.sandy.asComponent.layout.IASBoxLayoutTarget;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.display.DisplayObject;

	public class ComInvertedGroupAttriCell extends UIVBox
	{
		public function ComInvertedGroupAttriCell()
		{
			super();
			create_init()	
		}
		
		public var index:int;
		
		private var typeCB:ComCombobox;
		private var verticalGapTI:ComInput;
		private var horizontalGapTI:ComInput;
		private var compVB:UIVBox;
		private var xTi:ComInput;
		private var yTi:ComInput;
		private var widthTi:ComInput;
		private var heightTi:ComInput;
		private var verticalAlignCB:ComCombobox;
		private var horizontalAlignCB:ComCombobox;
		private var visibleBool:ComBoolean;
		
		private function create_init():void
		{
			var btn:ComButton = new ComButton();
			btn.reflashFun = delLayout;
			d = new ComAttriItemVO();
			d.key = "删除布局";
			btn.item = d;
			addChild(btn as DisplayObject);
			var dd:ComBaseVO = new ComBaseVO();
			dd.key = "delLayout";
			dd.value = "删除布局"
			btn.setValue(dd);
			
			typeCB = new ComCombobox();
			typeCB.reflashFun=changeDirection
			var d:ComAttriItemVO = new ComAttriItemVO();
			d.key = "布局类型";
			typeCB.item = d;
			addChild(typeCB as DisplayObject);
			
			verticalAlignCB = new ComCombobox();
			verticalAlignCB.reflashFun=changeVerticalAlign
			d = new ComAttriItemVO();
			d.key = "verticalAlign";
			verticalAlignCB.item = d;
			addChild(verticalAlignCB as DisplayObject);
			
			horizontalAlignCB = new ComCombobox();
			horizontalAlignCB.reflashFun=changeHorizontalAlign
			d = new ComAttriItemVO();
			d.key = "horizontalAlign";
			horizontalAlignCB.item = d;
			addChild(horizontalAlignCB as DisplayObject);
			
			verticalGapTI = new ComInput();
			verticalGapTI.reflashFun = changeVerticalGap;
			d = new ComAttriItemVO();
			d.key = "verticalGap";
			verticalGapTI.item = d;
			addChild(verticalGapTI as DisplayObject);
						
			horizontalGapTI = new ComInput();
			horizontalGapTI.reflashFun = changeHorizontalGap
			d = new ComAttriItemVO();
			d.key = "horizontalGap";
			horizontalGapTI.item = d;
			addChild(horizontalGapTI as DisplayObject);
			
			xTi = new ComInput();
			xTi.reflashFun = changeX
			d = new ComAttriItemVO();
			d.key = "x";
			xTi.item = d;
			addChild(xTi as DisplayObject);
			xTi.toolTip = "根据添加的第一个容器的位置来确定group的位置"
			
			yTi = new ComInput();
			yTi.reflashFun = changeY
			d = new ComAttriItemVO();
			d.key = "y";
			yTi.item = d;
			addChild(yTi as DisplayObject);
			yTi.toolTip = "根据添加的第一个容器的位置来确定group的位置"
			
			widthTi = new ComInput();
			widthTi.reflashFun = changeWidth
			d = new ComAttriItemVO();
			d.key = "width";
			widthTi.item = d;
			addChild(widthTi as DisplayObject);
			
			heightTi = new ComInput();
			heightTi.reflashFun = changeHeight
			d = new ComAttriItemVO();
			d.key = "height";
			heightTi.item = d;
			addChild(heightTi as DisplayObject);
			
			visibleBool = new ComBoolean();
			visibleBool.reflashFun = changeVisible;
			d = new ComAttriItemVO();
			d.key = "visible";
			visibleBool.item = d;
			addChild(visibleBool as DisplayObject);
			
			btn = new ComButton();
			btn.reflashFun = reflashLayout;
			d = new ComAttriItemVO();
			d.key = "刷新布局";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "reflashLayout";
			dd.value = "刷新布局"
			btn.setValue(dd);
			
			var lb:UILabel = new UILabel();
			lb.text = "管理的所有组件："
			addChild(lb);
			
			compVB = new UIVBox();
			compVB.labelField = "id";
			compVB.styleName = "list";
			compVB.percentWidth = 100;
			compVB.height = 200;
			addChild(compVB);
		}
		
		public var compData:ComponentData;
		
		public function reflash(d:ComponentData):void
		{
			compData = d;
			
			typeCB.compItem = d;
			var cov:ComComboboxVO = new ComComboboxVO();
			cov.key = "changeDirection";
			cov.value = d.invertedGroup.boxGroup.direction;
			cov.combobox_dataProvider = [ASComponentConst.EMPTY,ASComponentConst.VERTICAL,ASComponentConst.HORIZONTAL,ASComponentConst.TILE];
			typeCB.setValue(cov);
			
			verticalAlignCB.compItem = d;
			cov = new ComComboboxVO();
			cov.key = "changeVerticalAlign";
			cov.value = d.invertedGroup.boxGroup.verticalAlign;
			cov.combobox_dataProvider = [ASComponentConst.verticalAlign_top,ASComponentConst.verticalAlign_middle,ASComponentConst.verticalAlign_bottom];
			verticalAlignCB.setValue(cov);
			
			horizontalAlignCB.compItem = d;
			cov = new ComComboboxVO();
			cov.key = "changeHorizontalAlign";
			cov.value = d.invertedGroup.boxGroup.horizontalAlign;
			cov.combobox_dataProvider = [ASComponentConst.horizontalAlign_left,ASComponentConst.horizontalAlign_center,ASComponentConst.horizontalAlign_right];
			horizontalAlignCB.setValue(cov);
			
			verticalGapTI.compItem = d;
			var dd:ComBaseVO = new ComBaseVO();
			dd.key = "verticalGap";
			dd.value = IASBoxLayoutTarget(d.invertedGroup.boxGroup).verticalGap
			verticalGapTI.setValue(dd);
			
			horizontalGapTI.compItem = d;
			dd = new ComBaseVO();
			dd.key = "horizontalGap";
			dd.value = IASBoxLayoutTarget(d.invertedGroup.boxGroup).horizontalGap
			horizontalGapTI.setValue(dd);
			
			xTi.compItem = d;
			dd = new ComBaseVO();
			dd.key = "x";
			dd.value = IASBoxLayoutTarget(d.invertedGroup.boxGroup).x;
			xTi.setValue(dd);
			
			yTi.compItem = d;
			dd = new ComBaseVO();
			dd.key = "y";
			dd.value = IASBoxLayoutTarget(d.invertedGroup.boxGroup).y;
			yTi.setValue(dd);
			
			widthTi.compItem = d;
			dd = new ComBaseVO();
			dd.key = "width";
			dd.value = IASBoxLayoutTarget(d.invertedGroup.boxGroup).width;
			widthTi.setValue(dd);
			
			heightTi.compItem = d;
			dd = new ComBaseVO();
			dd.key = "height";
			dd.value = IASBoxLayoutTarget(d.invertedGroup.boxGroup).height;
			heightTi.setValue(dd);
			
			visibleBool.compItem = d;
			dd = new ComBaseVO();
			dd.key = "visible";
			dd.value = d.invertedGroup.boxGroup.visible;
			visibleBool.setValue(dd);
			
			compVB.dataProvider = compData.invertedGroup.boxGroup.getChildren();
		}
		
		private function changeDirection(d:IComBase):void
		{
			var g:IComBaseVO = typeCB.getValue();
			compData.invertedGroup.boxGroup.direction = g.value;
		}
		
		private function changeX(d:IComBase):void
		{
			var g:IComBaseVO = xTi.getValue();
			compData.invertedGroup.boxGroup.x = g.value;
		}
		
		private function changeY(d:IComBase):void
		{
			var g:IComBaseVO = yTi.getValue();
			compData.invertedGroup.boxGroup.y = g.value;
		}
		
		private function changeWidth(d:IComBase):void
		{
			var g:IComBaseVO = widthTi.getValue();
			compData.invertedGroup.boxGroup.width = g.value;
		}
		
		private function changeHeight(d:IComBase):void
		{
			var g:IComBaseVO = heightTi.getValue();
			compData.invertedGroup.boxGroup.height = g.value;
		}
		
		private function changeVerticalGap(d:IComBase):void
		{
			var g:IComBaseVO = verticalGapTI.getValue();
			compData.invertedGroup.boxGroup.verticalGap = g.value;
		}
		
		private function changeHorizontalGap(d:IComBase):void
		{
			var g:IComBaseVO = horizontalGapTI.getValue();
			compData.invertedGroup.boxGroup.horizontalGap = g.value;
		}
		
		private function changeVerticalAlign(d:IComBase):void
		{
			var g:IComBaseVO = verticalAlignCB.getValue();
			compData.invertedGroup.boxGroup.verticalAlign = g.value;
		}
		
		private function changeHorizontalAlign(d:IComBase):void
		{
			var g:IComBaseVO = horizontalAlignCB.getValue();
			compData.invertedGroup.boxGroup.horizontalAlign = g.value;
		}
		
		private function changeVisible(d:IComBase):void
		{
			var g:IComBaseVO = visibleBool.getValue();
			if(g.value == "true"){
				compData.invertedGroup.boxGroup.visible = true
			}else{
				compData.invertedGroup.boxGroup.visible = false
			}
		}
		
		private function delLayout(d:IComBase):void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "确定删除"+compData.invertedGroup.id+"布局组件？"
			m.okFunction = confirm_del;
			m.okFunArgs = d;
			iManager.iPopupwin.showConfirm(m);
		}
		
		private function confirm_del(d:IComBase):Boolean
		{
			UIEditManager.currEditShowContainer.cache.removeInvertedGroup(compData.invertedGroup)
			UIEditManager.currEditShowContainer.dispatchTarget(null);
			return true;
		}
		
		private function reflashLayout(d:IComBase):void
		{
			compData.invertedGroup.boxGroup.invalidate_layout = true;
		}
		
	}
}
package com.editor.module_ui.view.uiAttri
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UILabel;
	import com.editor.manager.DataManager;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.ui.UIEditCache;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.view.uiAttri.com.ComBoolean;
	import com.editor.module_ui.view.uiAttri.com.ComButton;
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.view.uiAttri.itemRenderer.BoxCell;
	import com.editor.module_ui.view.uiAttri.itemRenderer.ComToolCompItemRenderer;
	import com.editor.module_ui.view.uiAttri.itemRenderer.TabNavCell;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.sandy.asComponent.controls.ASTabNavigator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.core.interfac.IASContainer;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.common.bind.bind.bind;
	
	import flash.display.DisplayObject;

	public class ComToolAttriCell extends UIVBox
	{
		public function ComToolAttriCell()
		{
			super();
			name = "ComToolAttriCell"
			
			var btn:ComButton = new ComButton();
			btn.reflashFun = toParentLevel;
			var d:ComAttriItemVO = new ComAttriItemVO();
			d.key = "上移一层";
			btn.item = d;
			addChild(btn as DisplayObject);
			var dd:ComBaseVO = new ComBaseVO();
			dd.key = "toParentLevel";
			dd.value = "上移一层"
			btn.setValue(dd);
			
			var btn1:ComButton = new ComButton();
			btn1.reflashFun = toDownLevel;
			d = new ComAttriItemVO();
			d.key = "下移一层";
			btn1.item = d;
			addChild(btn1 as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "toDownLevel";
			dd.value = "下移一层"
			btn1.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = toTopLevel;
			d = new ComAttriItemVO();
			d.key = "最上层";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "toTopLevel";
			dd.value = "最上层"
			btn.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = toBottomLevel;
			d = new ComAttriItemVO();
			d.key = "最下层";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "toBottomLevel";
			dd.value = "最下层"
			btn.setValue(dd);
			
			var ds:ComBoolean = new ComBoolean();
			ds.reflashFun = showInventedBorder;
			d = new ComAttriItemVO();
			d.key = "显示/隐藏虚拟边框";
			ds.item = d;
			addChild(ds as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "showInventedBorder";
			dd.value = false
			ds.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = showTarget;
			d = new ComAttriItemVO();
			d.key = "显示该组件";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "showTarget";
			dd.value = "显示该组件";
			btn.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = hideThis;
			d = new ComAttriItemVO();
			d.key = "隐藏该组件";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "hideThis";
			dd.value = "隐藏该组件"
			btn.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = delThis
			d = new ComAttriItemVO();
			d.key = "删除该组件";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "delThis";
			dd.value = "删除该组件"
			btn.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = showThis;
			d = new ComAttriItemVO();
			d.key = "只显示该组件";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "showThis";
			dd.value = "只显示该组件"
			btn.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = showAll;
			d = new ComAttriItemVO();
			d.key = "显示全部组件";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "showAll";
			dd.value = "显示全部组件";
			btn.setValue(dd);
			
			copyBtn = new ComButton();
			copyBtn.reflashFun = copyUI;
			d = new ComAttriItemVO();
			d.key = "复制组件";
			copyBtn.item = d;
			addChild(copyBtn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "copyUI";
			dd.value = "复制组件";
			copyBtn.setValue(dd);
			
			vs = new UIViewStack();
			vs.enabledPercentSize = true;
			addChild(vs);
			
			box = new BoxCell();
			vs.addChild(box);
			
			tabNav = new TabNavCell();
			vs.addChild(tabNav);
		}
		
		private var box:BoxCell;
		private var tabNav:TabNavCell
		private var vs:UIViewStack;
		public var cell:ComAttriCell;
		private var copyBtn:ComButton;
				
		public function reflash():void
		{
			box.cell = this;
			tabNav.cell = this;
			
			if(cell.item.proxy.checkIsMultView()){
				vs.selectedIndex = 1;
				tabNav.reflash();
			}else if(cell.item.proxy.target is IASContainer){
				vs.selectedIndex = 0
				box.reflash();
			}else{
				vs.selectedIndex = -1
			}
			
			if(UIEditManager.getInstance().checkShowCopy(cell.item.proxy.target)){
				copyBtn.visible = true;
			}else{
				copyBtn.visible = false;
			}
		}
		
		private function copyUI(d:IComBase):void
		{
			UIEditManager.getInstance().copyUI(cell.item.proxy)
		}
		
		private function showInventedBorder(d:IComBase):void
		{
			var v:* = d.getValue().value;
			if(v == "true" || v == true){
				UIEditManager.currEditShowContainer.selectedUI.target.showBorderInUIEdit(true);
			}else{
				UIEditManager.currEditShowContainer.selectedUI.target.showBorderInUIEdit(false);
			}
		}
				
		private function showAll(d:IComBase):void
		{
			UIEditManager.currEditShowContainer.cache.showAllComp();
		}
		
		private function showThis(d:IComBase):void
		{
			UIEditManager.currEditShowContainer.cache.hideAllComp(UIEditManager.currEditShowContainer.selectedUI);
		}
		
		private function toParentLevel(d:IComBase=null):void
		{
			UIEditManager.currEditShowContainer.selectedUI.target.swapToUpLevel();
			reflashCompAttri()
		}
		
		private function toDownLevel(d:IComBase=null):void
		{
			UIEditManager.currEditShowContainer.selectedUI.target.swapToDownLevel()
			reflashCompAttri()
		}
		
		private function toBottomLevel(d:IComBase):void
		{
			UIEditManager.currEditShowContainer.selectedUI.target.swapToBottom()
			reflashCompAttri()
		}
		
		private function toTopLevel(d:IComBase):void
		{
			UIEditManager.currEditShowContainer.selectedUI.target.swapToTop()
			reflashCompAttri()
		}
		
		private function delThis(d:IComBase):void
		{
			UIEditCache.enabled_reflashCompOutline = false;
			UIEditManager.getInstance().delComp(UIEditManager.currEditShowContainer.selectedUI);
			UIEditCache.enabled_reflashCompOutline = true
		}
		
		private function hideThis(d:IComBase):void
		{
			UIEditManager.currEditShowContainer.selectedUI.target.visible=false
		}
		
		private function showTarget(d:IComBase):void
		{
			UIEditManager.currEditShowContainer.selectedUI.target.visible=true
		}
		
		private function reflashCompAttri():void
		{
			if(UIEditManager.currEditShowContainer.selectedUI == null) return ;
			UIEditManager.currEditShowContainer.cache.reflashTreeNodeInitAttri();
			//刷新组件大纲
			UIEditCache.reflashCompOutline();
		}
		
	}
}
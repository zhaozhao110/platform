package com.editor.module_ui.view.uiAttri
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.manager.DataManager;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.pop.filterExplorer.FilterExplorerMediator;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.view.uiAttri.com.ComBase;
	import com.editor.module_ui.view.uiAttri.com.ComBoolean;
	import com.editor.module_ui.view.uiAttri.com.ComColor;
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.module_ui.vo.component.ComItemVO;
	import com.editor.proxy.AppComponentProxy;
	import com.editor.services.Services;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class ComAttriCell extends UIVBox
	{
		public function ComAttriCell(d:ComponentData,_isFilterExplorer:Boolean=false)
		{
			isFilterExplorer = _isFilterExplorer;
			item = d;
			
			super();
		}
		
		public var item:ComponentData;
		public var item1:ComItemVO;
		private var _index:int;		
		public function get index():int
		{
			return _index;
		}
		public function set index(value:int):void
		{
			_index = value;
		}
		public var tabBar:UITabBarNav;
		public var attri_vb:UIVBox;
		public var style_vb:UIVBox;
		public var alignCell:ComAlignCell;
		public var systemAttri:ComSystemAttriCell;
		public var tool_vb:ComToolAttriCell;
		public var inverted_vb:ComInvertedGroupAttriCell;
		//是在filterExplorer 窗口里的
		public var isFilterExplorer:Boolean;
		public var reflashFilter:Function;
		public var addBtn:UIAssetsSymbol;
		public var addBox:ComAddAttriBox;
		
		override protected function __init__():void
		{
			super.__init__();
			
			padding = 3;
			styleName = "uicanvas"
			enabledPercentSize = true;
						
			var cont:UICanvas = new UICanvas();
			cont.enabledPercentSize = true;
			addChild(cont)
						
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.buttonMode = true;
			addBtn.toolTip = "新建属性"
			addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			cont.addChild(addBtn);
			addBtn.x = 230;
			addBtn.y = 2;
			addBtn.visible = false;
			
			tabBar = new UITabBarNav();
			tabBar.enabledPercentSize = true;
			cont.addChild(tabBar);
			
			attri_vb = new UIVBox();
			attri_vb.paddingLeft = 2;
			attri_vb.styleName = "uicanvas"
			attri_vb.label = "属性"
			attri_vb.enabledPercentSize = true;
			attri_vb.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			tabBar.addChild(attri_vb);
					
			if(item!=null){
				if(!isFilterExplorer){
					style_vb = new UIVBox();
					style_vb.label = "样式"
					style_vb.paddingLeft = 2;
					style_vb.styleName = "uicanvas"
					style_vb.enabledPercentSize = true;
					style_vb.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
					tabBar.addChild(style_vb);
				}
				
				if(!isFilterExplorer){
					tool_vb = new ComToolAttriCell();
					tool_vb.label = "工具"
					tool_vb.cell = this;
					tool_vb.paddingLeft = 2;
					tool_vb.styleName = "uicanvas"
					tool_vb.enabledPercentSize = true;
					tool_vb.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
					tabBar.addChild(tool_vb);
				}
				
				item1 = get_AppComponentProxy().com_ls.getItemByName(item.name);
				create_attri();
				
			}else{
				create_system();
			}
			
			addBox = new ComAddAttriBox();
			addBox.percentWidth = 100;
			addBox.y = 30;
			cont.addChild(addBox);
			
			tabBar.selectedIndex = 0;
		}
		
		private function create_system():void
		{
			if(isFilterExplorer) return 
			attri_vb.selectedIndex = 0;
			if(systemAttri!=null) return ;
			systemAttri = new ComSystemAttriCell();
			attri_vb.addChild(systemAttri);		
			
			alignCell = new ComAlignCell();
			alignCell.styleName = "uicanvas"
			alignCell.paddingLeft = 2;
			alignCell.label = "对齐"
			alignCell.cell = this;
			alignCell.enabledPercentSize = true;
			alignCell.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			tabBar.addChild(alignCell);
		}
		
		private var attri_ls:Array = [];
		
		private function create_attri():void
		{
			var a:Array = getAttriList();
			for(var i:int=0;i<a.length;i++)
			{
				var _item:ComAttriItemVO = a[i] as ComAttriItemVO;
				var ds:ComBase = _createItemRenderer(_item);
				if(ds!=null){
					var key:String = ds.item.key;
					var d:ComBaseVO = new ComBaseVO();
					d.key = key;
					if(item.proxy!=null){
						d.value = item.proxy.getAttri(key);
						if(d.value == null){
							if(!StringTWLUtil.isWhitespace(_item.defaultValue)){
								d.value = _item.defaultValue;
							}
						}
					}else{
						d.value = _item.defaultValue;
					}
					ds.setValue(d);
				}
			}
		}
		
		private function _createItemRenderer(_item:ComAttriItemVO):ComBase
		{
			if(!noCreateItemRenderer(_item)) return null;
			if(attri_ls[_item.key] != null) return attri_ls[_item.key] as ComBase;
			var _addTo:Boolean;
			var ds:ComBase = ComTypeManager.getComByType(_item.value);
			if(ds!=null){
				ds.compItem = item;
				ds.item = _item;
				ds.reflashFun = reflashCompAttri;
				if(_item.checkIsAttri() || isFilterExplorer){
					attri_vb.addChild(ds as DisplayObject);
					_addTo = true
				}else if(_item.checkIsStyle()){
					if(style_vb!=null){
						style_vb.addChild(ds as DisplayObject);
						_addTo = true;
					}
				}
			}
			if(_addTo){
				attri_ls[_item.key] = ds;
				return ds;
			}
			return null;
		}
		
		private function noCreateItemRenderer(_item:ComAttriItemVO):Boolean
		{
			if(_item.key == "groupId"){
				return false;
			}
			return true;
		}
			
		public function getCombase(key:String):IComBase
		{
			return attri_ls[key] as IComBase
		}
		
		private function hideAll():void
		{
			for each(var ds:ComBase in attri_ls){
				if(ds!=null){
					ds.visible = false;
					ds.includeInLayout = false;
				}
			}
		}
		
		public function reflash(dd:ComponentData):void
		{
			item = dd;
			hideAll();
			var a:Array = getAttriList();
			for(var i:int=0;i<a.length;i++)
			{
				var _item:ComAttriItemVO = a[i] as ComAttriItemVO;
				var ds:ComBase = attri_ls[_item.key] as ComBase;
				if(ds==null){
					ds = _createItemRenderer(_item);
				}
				if(ds!=null){
					var key:String = ds.item.key;
					var d:ComBaseVO = new ComBaseVO();
					d.key = key;
					if(item.proxy!=null){
						d.value = item.proxy.getAttri(key);
						if(d.value == null){
							if(!StringTWLUtil.isWhitespace(_item.defaultValue)){
								d.value = _item.defaultValue;
							}
						}
					}else{
						d.value = _item.defaultValue;
					}
					if(isFilterExplorer){
						FilterExplorerMediator.filterExplorer.addAttri(dd.name,key,d.value);
					}
					ds.setValue(d);
				}
			}
			if(isFilterExplorer){
				FilterExplorerMediator.filterExplorer.reflashFilter();
			}
			if(tool_vb!=null) tool_vb.reflash();
			
			if(dd.item.groupId == DataManager.comType_6){
				addBtn.visible = true;
			}else{
				addBtn.visible = false;
				addBox.visible = false;
			}
		}
				
		public function getAttriList():Array
		{
			return item.item.attriList;
		}
		
		private function reflashCompAttri(d:ComBase):void
		{
			if(isFilterExplorer){
				reflashFilter(d);
				return ;
			}
			if(UIEditManager.currEditShowContainer.selectedUI == null) return ;
			UIEditManager.currEditShowContainer.selectedUI.reflashRender(d)
			iManager.sendAppNotification(UIEvent.reflash_uiAttri_event,d);
		}
		
		private function get_AppComponentProxy():AppComponentProxy
		{
			return iManager.retrieveProxy(AppComponentProxy.NAME) as AppComponentProxy;
		}
		
		private function onAdd(e:MouseEvent):void
		{
			addBox.visible = true;
		}
	}
}
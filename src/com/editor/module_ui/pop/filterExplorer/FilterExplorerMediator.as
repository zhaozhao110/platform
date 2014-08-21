package com.editor.module_ui.pop.filterExplorer
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UITextArea;
	import com.editor.manager.DataManager;
	import com.editor.module_ui.view.uiAttri.ComAttriCell;
	import com.editor.module_ui.view.uiAttri.com.ComBase;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.component.ComItemVO;
	import com.editor.proxy.AppComponentProxy;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.FilterTool;
	
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	public class FilterExplorerMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "FilterExplorerMediator"
		public function FilterExplorerMediator(viewComponent:*=null)
		{
			super(NAME,viewComponent);
		}
		public function get explorer():FilterExplorer
		{
			return viewComponent as FilterExplorer;
		}
		public function get box():UIVBox
		{
			return explorer.box;
		}
		public function get showCan():UICanvas
		{
			return explorer.showCan;
		}
		public function get txt():UITextArea
		{
			return explorer.txt;
		}
		public function get vs():UIViewStack
		{
			return explorer.vs;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			filterExplorer = this;
			box.addEventListener(ASEvent.CHANGE,onBoxChange)
			box.dataProvider = AppComponentProxy.instance.com_ls.getGroup(DataManager.comType_7).list;
			box.selectedIndex = 0
		}
		
		public static var filterExplorer:FilterExplorerMediator;
		public var selectedItem:ComItemVO;
		public var compData:ComponentData;
		private var comp_ls:Array = [];
		
		private function onBoxChange(e:ASEvent):void
		{
			selectedItem = box.selectedItem as ComItemVO;
			if(comp_ls[selectedItem.name] == null){
				compData = new ComponentData();
				compData.item = selectedItem;
				compData.name = selectedItem.name;
				comp_ls[selectedItem.name] = compData;
			}
			createAttriCell(comp_ls[selectedItem.name] as ComponentData);
		}
		
		private var comAttri_list:Array = [];
		private function createAttriCell(d:ComponentData):void
		{			
			if(comAttri_list[d.name] == null){
				var cell:ComAttriCell = new ComAttriCell(d,true);
				cell.reflashFilter = reflashFilter;
				vs.addChild(cell);
				comAttri_list[d.name] = cell;
				vs.selectedIndex = vs.getChildren().length-1;
				cell.index = vs.selectedIndex;
				(comAttri_list[d.name] as ComAttriCell).reflash(d);
			}else{
				(comAttri_list[d.name] as ComAttriCell).reflash(d);
				vs.selectedIndex = (comAttri_list[d.name] as ComAttriCell).index;
			}
		}
		
		public function addAttri(nm:String,key:String,v:*):void
		{
			(comp_ls[nm] as ComponentData).setAttri(key,v);
		}
		
		public function reflashFilter(d:ComBase=null):void
		{
			var filter:* = createFilter();
			
			if(d != null){
				var vo:IComBaseVO = d.getValue();
				var v:* = vo.value;
				(comp_ls[selectedItem.name] as ComponentData).setAttri(d.key,v);
			}
						
			var a:Array = (comp_ls[selectedItem.name] as ComponentData).attriObj;
			for(var key:String in a){
				filter[key] = a[key];
			}
			showCan.filters = [filter];
			txt.text = FilterTool.createStringByFilter(filter);
		}
		
		private function createFilter():*
		{
			if(selectedItem.name == "BevelFilter"){
				return new BevelFilter();
			}else if(selectedItem.name == "BlurFilter"){
				return new BlurFilter();
			}else if(selectedItem.name == "DropShadowFilter"){
				return new DropShadowFilter();
			}else if(selectedItem.name == "GlowFilter"){
				return new GlowFilter();
			}
			return null;
		}
		
	}
}
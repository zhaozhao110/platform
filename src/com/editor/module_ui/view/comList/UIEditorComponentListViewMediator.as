package com.editor.module_ui.view.comList
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIVlist;
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.component.ComGroupVO;
	import com.editor.module_ui.vo.component.ComItemVO;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.proxy.AppComponentProxy;
	import com.editor.vo.dict.DictGroupVO;
	import com.editor.vo.dict.DictItemVO;
	import com.editor.vo.dict.DictListVO;
	import com.editor.vo.xml.AppXMLGroupVO;
	import com.editor.vo.xml.AppXMLItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.core.SandyEngine;
	import com.sandy.san_internal;
	
	import flash.filesystem.File;
	
	use namespace san_internal;
	
	public class UIEditorComponentListViewMediator extends AppMediator
	{
		public static const NAME:String = "UIEditorComponentListViewMediator"
		public function UIEditorComponentListViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get comListView():UIEditorComponentListView
		{
			return viewComponent as UIEditorComponentListView;
		}
		public function get comType_ls():UICombobox
		{
			return comListView.comType_ls;
		}
		public function get comList():UIVlist
		{
			return comListView.comList;
		}
		 
		override public function onRegister():void
		{
			super.onRegister();
			
			comList.labelField = "name";
			
			comType_ls.labelField = "value";
			var out:Array = [];
			var a:Array = DictListVO.getGroup(DataManager.com_enumType).list;
			for(var i:int=0;i<a.length;i++){
				if(DictItemVO(a[i]).key != 7 && DictItemVO(a[i]).key != 8 && DictItemVO(a[i]).key != 5){
					out.push(a[i]);
				}
			}
			comType_ls.dataProvider = out;
			comType_ls.addEventListener(ASEvent.CHANGE,comTypeChange);
			comType_ls.selectedIndex = 0;
		}
		
		private function comTypeChange(e:ASEvent):void
		{
			var groupId:int = (comType_ls.selectedItem as DictItemVO).key;
			var out:Array = [];
			
			if(groupId == DataManager.comType_6){
				comType_ls.toolTip = "里面包括com/rpg/component/expands下的所有组件";
				//扩展组件
				var a:Array = ProjectCache.getInstance().getExpandComps();
				for(var i:int=0;i<a.length;i++){
					var fl:File = a[i] as File;
					if(fl.extension == "as"){
						
						var obj:ComponentData = new ComponentData();
						obj.name = fl.name.split(".")[0];
						obj.icon = "Canvas_a";
						
						var it:ComItemVO = new ComItemVO();
						it.name = obj.name;
						it.groupId = groupId;
						obj.item = it;
						
						out.push(obj);
					}
				}
				
				obj = new ComponentData();
				obj.name = "ProxyComp";
				obj.icon = "Canvas_a";
				
				it = new ComItemVO();
				it.name = obj.name;
				it.groupId = groupId;
				obj.item = it;
				
				out.push(obj);
				
				comList.dataProvider = out.sortOn("name");
				return ;
			}
			
			
			comType_ls.toolTip = "";
			if(get_AppComponentProxy().com_ls.getGroup(groupId) == null){
				comList.dataProvider = null;
				return ;
			}
			
			a = get_AppComponentProxy().com_ls.getGroup(groupId).list;
			for(i=0;i<a.length;i++){
				var item:ComItemVO = a[i] as ComItemVO;
				if(DataManager.noComp_ls.indexOf(item.id)==-1){
					obj = new ComponentData();
					obj.name = item.name;
					obj.icon = item.name+"_a";
					obj.item = item;
					
					out.push(obj);
				}
			}
			comList.dataProvider = out.sortOn("name");
		}
		
		private function get_AppComponentProxy():AppComponentProxy
		{
			return retrieveProxy(AppComponentProxy.NAME) as AppComponentProxy;
		}
		
	}
}
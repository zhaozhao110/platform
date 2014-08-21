package com.editor.module_map.mediator.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITabBar;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.mediator.left.attributeEditor.MapEditorAttributeEditor_resMediator;
	import com.editor.module_map.mediator.left.attributeEditor.MapEditorAttributeEditor_sceneMediator;
	import com.editor.module_map.mediator.right.layout.MapEditorLayoutContainerMediator;
	import com.editor.module_map.proxy.MapEditorProxy;
	import com.editor.module_map.view.left.MapEditorLeftContainer;
	import com.editor.module_map.view.left.attributeEditor.MapEditorAttributeEditor_res;
	import com.editor.module_map.view.left.attributeEditor.MapEditorAttributeEditor_scene;
	import com.editor.module_map.view.render.SceneListRenderer;
	import com.editor.module_map.vo.map.MapSceneItemVO;
	import com.editor.module_map.vo.map.MapSceneResItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.event.SandyEvent;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MapEditorLeftContainerMediator extends AppMediator
	{	
		public static const NAME:String = "MapEditorLeftContainerMediator";
		
		private var _sceneSelectedVO:MapSceneItemVO;
		
		public function MapEditorLeftContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():MapEditorLeftContainer
		{
			return viewComponent as MapEditorLeftContainer;
		}
		public function get tabBar():UITabBar
		{
			return mainUI.tabBar;
		}
		public function get tabContainer1():UICanvas
		{
			return mainUI.tabContainer1;
		}
		public function get tabContainer2():UICanvas
		{
			return mainUI.tabContainer2;
		}
		public function get addSceneButton():UIButton
		{
			return mainUI.addSceneButton;
		}
		public function get addEmptySceneButton():UIButton
		{
			return mainUI.addEmptySceneButton;
		}
		public function get sceneListContainer():UIVBox
		{
			return mainUI.sceneListContainer;
		}
		public function get viewStack():UIViewStack
		{
			return mainUI.viewStack;
		}
		public function get attriResPanel():MapEditorAttributeEditor_res
		{
			return mainUI.attriResPanel;
		}
		public function get attriScenePanel():MapEditorAttributeEditor_scene
		{
			return mainUI.attriScenePanel;
		}
		public function get sceneToUpButton():UIButton
		{
			return mainUI.sceneToUpButton;
		}
		public function get sceneToDownButton():UIButton
		{
			return mainUI.sceneToDownButton;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			registerMediator(new MapEditorAttributeEditor_resMediator(attriResPanel));
			registerMediator(new MapEditorAttributeEditor_sceneMediator(attriScenePanel));
			
			tabBar.addEventListener(ASEvent.CHANGE, onTabBarChangeHandle);
			tabBar.selectedIndex = 0;
			
			sceneListContainer.addEventListener(ASEvent.CHANGE, onSceneListContainerChangeHandle);
		}
		
		/**tabBar改变事件**/
		private function onTabBarChangeHandle(e:ASEvent):void
		{
			switch(tabBar.selectedIndex)
			{
				case 0:
					tabContainer1.visible = true;
					tabContainer2.visible = false;
					break;
				case 1:
					tabContainer1.visible = false;
					tabContainer2.visible = true;					
					break;
			}
			
			
			
		}
		
		/**场景层次列表选择事件**/
		private function onSceneListContainerChangeHandle(e:ASEvent):void
		{
			_sceneSelectedVO = sceneListContainer.selectedItem as MapSceneItemVO;
			sendNotification(MapEditorEvent.mapEditor_selectSceneList_event, {vo:_sceneSelectedVO});
		}
		
		/**获得当前选中场景层次VO**/
		public function getSceneSelectedVO():MapSceneItemVO
		{
			var vo:MapSceneItemVO;
			if(_sceneSelectedVO)
			{
				if(MapEditorDataManager.getInstance().getScene(_sceneSelectedVO.id))
				{
					vo = _sceneSelectedVO;
				}else
				{
					_sceneSelectedVO = null;
				}
			}
			
			return vo;
		}
		
		/**添加场景层次按钮点击**/
		public function reactToAddSceneButtonClick(e:MouseEvent):void
		{
			if(!MapEditorDataManager.getInstance().currentSelectedSceneItme)
			{
				showMessage("请点击 \"选择要编辑的场景\" 选择场景！");
				return;
			}
			
			var out:Array = [];
			var a:Array = get_MapEditorProxy().resInfo_ls.group_ls;
			for(var i:int=0;i<a.length;i++)
			{
				if(AppResInfoGroupVO(a[i]).type != 9) continue;
				
				if(!StringTWLUtil.isWhitespace(AppResInfoGroupVO(a[i]).type_str))
				{
					out.push(a[i]);
				}
			}
			
			var vo:SelectEditPopWinVO = new SelectEditPopWinVO();
			vo.data = out;
			vo.column2_dataField = "name1"
			vo.select_dataField = "item_ls"
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
			dat.data = vo;
			dat.callBackFun = selectedSceneResCallBack
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		private function selectedSceneResCallBack(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{			
			if(item.type != 9)
			{
				showMessage("请选择  \"场景层\"  分类");
				return;
			}
			
			if(MapEditorDataManager.getInstance().getSceneBySource(item.id + ""))
			{
				showMessage("不可以重复添加相同的场景！");
				return;
			}
			
			get_MapEditorLayoutContainerMediator().loadSourceByItme(item);
		}
		
		/**添加空白场景按钮点击**/
		public function reactToAddEmptySceneButtonClick(e:MouseEvent):void
		{
			var item:AppResInfoItemVO = new AppResInfoItemVO();
			item.id = -(MapEditorDataManager.getInstance().getSceneNewId());
			item.type = 9;
			get_MapEditorLayoutContainerMediator().loadSourceByItme(item);
		}
		
		/**调整场景层次按钮点击**/
		public function reactToSceneToUpButtonClick(e:MouseEvent):void
		{
			swapSceneBySlot(1);
		}
		public function reactToSceneToDownButtonClick(e:MouseEvent):void
		{
			swapSceneBySlot(-1);
		}
		private function swapSceneBySlot(slot:int):void
		{
			if(sceneListContainer.selectedIndex >= 0)
			{
				var vo:MapSceneItemVO = sceneListContainer.selectedItem as MapSceneItemVO;
				if(vo)
				{
					MapEditorDataManager.getInstance().swapSceneIndex(vo, slot);
					_sceneSelectedVO = vo;
					sendAppNotification(MapEditorEvent.mapEditor_updateSceneList_event);
				}
			}
		}
		
		/**更新场景层次列表**/
		private function updateSceneList():void
		{
			var a:Array = MapEditorDataManager.getInstance().getSceneArray();
			var len:int = a.length;
			sceneListContainer.dataProvider = a;
			var selectedIndex:int = 0;
			for(var i:int=0;i<a.length;i++)
			{
				var fvo:MapSceneItemVO = a[i] as MapSceneItemVO;
				if(fvo)
				{
					if(fvo == _sceneSelectedVO)
					{
						selectedIndex = i;
						break;
					}
				}
			}
			sceneListContainer.selectedIndex = selectedIndex;
			
			/**设置列表容器的高**/
			var renderH:int = sceneListContainer.getChildAt(0) ? SceneListRenderer(sceneListContainer.getChildAt(0)).height : 0;
			var containerH:int = (renderH + sceneListContainer.verticalGap)*len + 1;
			if(containerH > 120)
			{
				sceneListContainer.height = containerH;
			}else
			{
				sceneListContainer.height = 120;
			}
			
			
		}
		/**更新场景层次列表事件**/
		public function respondToMapEditorUpdateSceneListEvent(noti:Notification):void
		{
			updateSceneList();
		}
		
		/**编辑属性事件**/
		public function respondToMapEditorEditPripertiesDateEvent(noti:Notification):void
		{
			var data:Object = noti.getBody() as Object;
			if(data && data.vo)
			{
				activatePriperties(data.vo);
				
			}
		}
		/**操作属性控制的对象事件**/
		public function respondToMapEditorEditPripertiesTargetEvent(noti:Notification):void
		{
			var data:Object = noti.getBody() as Object;
			if(data && data.vo)
			{
				activatePriperties(data.vo);
			}
			
		}
		
		/**激活属性**/
		private function activatePriperties(voObj:Object):void
		{
			if(voObj is MapSceneItemVO)
			{
				tabBar.selectedIndex = 1;
				viewStack.selectedIndex = 0;
				if(get_MapEditorAttributeEditor_sceneMediator())
				{
					get_MapEditorAttributeEditor_sceneMediator().setData(voObj as MapSceneItemVO);
				}
			}else if(voObj is MapSceneResItemVO)
			{
				tabBar.selectedIndex = 1;
				viewStack.selectedIndex = 1;
				if(get_MapEditorAttributeEditor_resMediator())
				{
					get_MapEditorAttributeEditor_resMediator().setData(voObj as MapSceneResItemVO);						
				}
			}
		}
		
		
		/** << gets **/
		private function get_MapEditorProxy():MapEditorProxy
		{
			return retrieveProxy(MapEditorProxy.NAME) as MapEditorProxy;
		}
		private function get_MapEditorLayoutContainerMediator():MapEditorLayoutContainerMediator
		{
			return retrieveMediator(MapEditorLayoutContainerMediator.NAME) as MapEditorLayoutContainerMediator;
		}
		private function get_MapEditorAttributeEditor_sceneMediator():MapEditorAttributeEditor_sceneMediator
		{
			return retrieveMediator(MapEditorAttributeEditor_sceneMediator.NAME) as MapEditorAttributeEditor_sceneMediator;
		}
		private function get_MapEditorAttributeEditor_resMediator():MapEditorAttributeEditor_resMediator
		{
			return retrieveMediator(MapEditorAttributeEditor_resMediator.NAME) as MapEditorAttributeEditor_resMediator;
		}
		
		
		
	}
}
package com.editor.module_map.mediator.top
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.manager.MapEditorManager;
	import com.editor.module_map.mediator.MapEditorModuleMediator;
	import com.editor.module_map.mediator.left.MapEditorLeftContainerMediator;
	import com.editor.module_map.mediator.right.layout.MapEditorLayoutContainerMediator;
	import com.editor.module_map.proxy.MapEditorProxy;
	import com.editor.module_map.view.top.MapEditorToolBar;
	import com.editor.module_map.vo.MapEditorConfigVO;
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_map.vo.map.MapResConfigItemVO;
	import com.editor.module_map.vo.map.MapSceneItemVO;
	import com.editor.module_map.vo.map.MapSceneResItemEffVO;
	import com.editor.module_map.vo.map.MapSceneResItemNpcVO;
	import com.editor.module_map.vo.map.MapSceneResItemVO;
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.net.json.SandyJSON;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	import com.sandy.resource.interfac.ILoadSourceData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class MapEditorToolBarMediator extends AppMediator
	{	
		public static const NAME:String = "MapEditorToolBarMediator";
		
		public function MapEditorToolBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():MapEditorToolBar
		{
			return viewComponent as MapEditorToolBar;
		}
		public function get selectSceneButton():UIButton
		{
			return mainUI.selectSceneButton;
		}
		public function get addSceneResButton():UIButton
		{
			return mainUI.addSceneResButton;
		}
		public function get addSceneResButton2():UIButton
		{
			return mainUI.addSceneResButton2;
		}
		public function get previewButton():UIButton
		{
			return mainUI.previewButton;
		}
		public function get saveButton():UIButton
		{
			return mainUI.saveButton;
		}
		public function get visiLogButton():UIButton
		{
			return mainUI.visiLogButton;
		}
		public function get infoTxt():UILabel
		{
			return mainUI.infoTxt;
		}
		public function get infoTxt2():UILabel
		{
			return mainUI.infoTxt2;
		}
		
		
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		/**选择场景按钮点击**/
		public function reactToSelectSceneButtonClick(e:MouseEvent):void
		{
			if(!MapEditorManager.currProject || !MapEditorManager.currProject.data)
			{
				/**先 选择项目**/
				get_MapEditorModuleMediator().openSelectProject();
				return;
			}
			
			if(get_MapEditorProxy().mapDefine == null)
			{
				showError("请等待加载完成");
				return ;
			}
			
			if(MapEditorDataManager.getInstance().currentSelectedSceneItme)
			{
				var confirmData:OpenMessageData = new OpenMessageData();
				confirmData.info = "些操作将覆盖之前编辑的内容，\<br\>是否确定已保存之前编辑的场景？";
				confirmData.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
				confirmData.okFunction = okFunction;
				showConfirm(confirmData);
				
				return;
			}
			
			function okFunction():Boolean
			{
				selectedScene();
				
				return true;
			}
			
			selectedScene();
			
		}
		private function selectedScene():void
		{
			var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
			vo.data = get_MapEditorProxy().mapDefine.getList();
			vo.labelField = "name1";
			vo.label = "选择要编辑的场景: ";
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
			dat.data = vo;
			dat.callBackFun = selectedSceneCallBack;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		
		private var xmlUrl:String = "";
		private function selectedSceneCallBack(item:AppMapDefineItemVO, item1:SelectEditPopWin2VO):void
		{
			get_MapEditorLeftContainerMediator().tabBar.selectedIndex = 0;
			
			infoTxt2.htmlText = "当前编辑的场景：<font color='#00CC00'><b>" + item.name + "</b></font>";
			MapEditorDataManager.getInstance().currentSelectedSceneItme = item;
			
			var xName:String = item.id + ".xml";
			xmlUrl = MapEditorManager.currProject.mapConfigUrl + "map/" + xName;
						
			var request:URLRequest = new URLRequest(xmlUrl);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, oncompleteHand);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHand);
			
			sendAppNotification(MapEditorEvent.mapEditor_loadingStart_event);			
			get_MapEditorModuleMediator().addLog2("开始加载场景XML：" + xmlUrl);
			
			try
			{
				loader.load(request);
			} 
			catch(error:Error) 
			{
				trace("load currentSelectedSceneXmlUrl error:" + error.message);
			}			
			
		}		
		private function oncompleteHand(e:Event):void
		{
			parseSceneXML(XML(e.target.data));
		}
		private function onErrorHand(e:ErrorEvent):void
		{
			sendAppNotification(MapEditorEvent.mapEditor_loadingComplete_event);	
			get_MapEditorModuleMediator().addLog2("加载场景XML失败：" + xmlUrl + "，将生成新的场景XML");
						
			MapEditorDataManager.getInstance().clearScene();
			MapEditorDataManager.getInstance().clearSceneRes();
			sendAppNotification(MapEditorEvent.mapEditor_updateSceneList_event);
			sendAppNotification(MapEditorEvent.mapEditor_updateSceneResList_event);
		}
		/**解析场景XML**/
		private function parseSceneXML(x:XML):void
		{
			get_MapEditorModuleMediator().addLog2("加载场景XML成功：" + xmlUrl + "，开始解析场景XML");
			
			MapEditorDataManager.getInstance().clearScene();
			MapEditorDataManager.getInstance().clearSceneRes();
			
			sendNotification(MapEditorEvent.mapEditor_updateSceneList_event);
			sendNotification(MapEditorEvent.mapEditor_updateSceneResList_event);
			
			var dataStr:String;
			var dataObj:Object;
			
			var item:AppResInfoItemVO;
			
			/**场景层**/
			for each(var sXML:XML in x.s.i)
			{
				var vo1:MapSceneItemVO = new MapSceneItemVO();
				vo1.id = MapEditorDataManager.getInstance().getSceneNewId() + "";
				vo1.sourceId = sXML.@id ? sXML.@id : "";
				vo1.index = sXML.@ix ? sXML.@ix : 0;
				vo1.x = sXML.@x ? sXML.@x : 0;
				vo1.y = sXML.@y ? sXML.@y : 0;
				vo1.width = sXML.@w ? sXML.@w : 0;
				vo1.height = sXML.@h ? sXML.@h : 0;
				vo1.isDefault = sXML.@df ? sXML.@df : 0;
				vo1.range = sXML.@r ? sXML.@r : "";
				vo1.useHDefaultSpeed = sXML.@hd ? sXML.@hd : 1;
				vo1.horizontalSpeed = sXML.@hp ? sXML.@hp : 0;
				vo1.verticalMoveQueue = sXML.@vmq ? sXML.@vmq : "";
				
				dataStr = sXML.@data ? sXML.@data : "";
				dataObj = null;
				try
				{
					dataObj = SandyJSON.decode(dataStr);			
					
				}catch(e:Error)
				{
					trace("JSON Error：" + e.message);
				}
				if(dataObj)
				{
					if(dataObj.spawn)
					{						
						vo1.spawnX = (String(dataObj.spawn).split(",").length > 1) ? int(String(dataObj.spawn).split(",")[0]) : 0;
						vo1.spawnY = (String(dataObj.spawn).split(",").length > 1) ? int(String(dataObj.spawn).split(",")[1]) : 0;
					}
				}
				
				MapEditorDataManager.getInstance().addScene(vo1);
				
				item = get_MapEditorProxy().resInfo_ls.getResInfoItemByID(int(vo1.sourceId));
				if(!item)
				{
					item = new AppResInfoItemVO();
					item.id = -(MapEditorDataManager.getInstance().getSceneNewId());
					item.type = 9;
				}
				vo1.sourceName = item.name1 ? item.name1 : "空层";
				get_MapEditorLayoutContainerMediator().loadSourceByItme(item, vo1);		
				
			}
			
			/**场景资源**/
			for each(var rXML:XML in x.r.i)
			{
				var vo2:MapSceneResItemVO;
								
				var type:int = rXML.@tp ? rXML.@tp : 0;
				
				dataStr = rXML.@data ? rXML.@data : "";
				dataObj = null;
				try
				{
					dataObj = SandyJSON.decode(dataStr);			
					
				}catch(e:Error)
				{
					trace("JSON Error：" + e.message);
				}
				
				if(type == 2)
				{
					vo2 = new MapSceneResItemNpcVO();
					
				}else if(type == 6)
				{					
					vo2 = new MapSceneResItemEffVO();
					if(dataObj)
					{
						if(dataObj.startFrame)
						{
							(vo2 as MapSceneResItemEffVO).startFrame = dataObj.startFrame;
						}
					}

				}else if(type == 9)
				{
					vo2 = new MapSceneResItemVO();
				}
					
				vo2.id = rXML.@id ? rXML.@id : "";
				vo2.sourceId = rXML.@sid ? rXML.@sid : "";
				vo2.sourceType = rXML.@tp ? rXML.@tp : 0;
				vo2.sceneId = rXML.@si ? rXML.@si : "";
				vo2.index = rXML.@ix ? rXML.@ix : 0;
				vo2.x = rXML.@x ? rXML.@x : 0;
				vo2.y = rXML.@y ? rXML.@y : 0;
				vo2.scaleX = rXML.@sx ? rXML.@sx : 1;
				vo2.scaleY = rXML.@sy ? rXML.@sy : 1;
				vo2.rotation = rXML.@r ? rXML.@r : 0;
				vo2.locked = 1;
				
				/**临时改**/
//				if(vo2.sourceId == "")
//				{
//					vo2.sourceId = vo2.id;
//					if(MapEditorDataManager.getInstance().getSceneRes(vo2.id))
//					{
//						vo2.id = "s" + MapEditorDataManager.getInstance().getSceneResNewId();
//					}
//				}
				
				MapEditorDataManager.getInstance().addSceneRes(vo2);
				
				item = get_MapEditorProxy().resInfo_ls.getResInfoItemByID(int(vo2.sourceId));
				if(item)
				{
					vo2.sourceName = item.name1;
					vo2.type = item.type;
					
					get_MapEditorLayoutContainerMediator().loadSourceByItme(item, vo2);
				}else
				{
					get_MapEditorModuleMediator().addLog2("无法获取资源配置信息-资源ID：" + vo2.sourceId);
				}
				
			}
			
			get_MapEditorModuleMediator().addLog2("解析场景XML成功：" + xmlUrl);
			
		}
		
		/**添加场景配置资源按钮点击**/
		public function reactToAddSceneResButtonClick(e:MouseEvent):void
		{
			if(!MapEditorDataManager.getInstance().currentSelectedSceneItme)
			{
				showMessage("请点击 \"选择要编辑的场景\" 选择场景！");
				return;
			}
			if(!get_MapEditorLeftContainerMediator().getSceneSelectedVO())
			{
				showMessage("请到  \"场景层次\" 中选择场景层!");
				return;
			}			
			
			var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
			var mapId:int = MapEditorDataManager.getInstance().currentSelectedSceneItme.id;
			vo.data = get_MapEditorProxy().mapRes.getListByMap(mapId);
			vo.labelField = "name1";
			vo.label = "选择资源: ";
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
			dat.data = vo;
			dat.callBackFun = selectedSceneResCallBack;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
			
		}		
		private function selectedSceneResCallBack(item:MapResConfigItemVO,item1:SelectEditPopWin2VO):void
		{			
			var appResItem:AppResInfoItemVO = get_MapEditorProxy().resInfo_ls.getResInfoItemByID(item.sourceId);
			
			get_MapEditorLayoutContainerMediator().loadSourceByItme(appResItem, null, 1, item);
			
		}
		
		/**添加场景普通资源按钮点击**/
		public function reactToAddSceneResButton2Click(e:MouseEvent):void
		{
			if(!MapEditorDataManager.getInstance().currentSelectedSceneItme)
			{
				showMessage("请点击 \"选择要编辑的场景\" 选择场景！");
				return;
			}
			if(!get_MapEditorLeftContainerMediator().getSceneSelectedVO())
			{
				showMessage("请到  \"场景层次\" 中选择场景层!");
				return;
			}
			
			var out:Array = [];
			var a:Array = get_MapEditorProxy().resInfo_ls.group_ls;
			for(var i:int=0;i<a.length;i++)
			{
				/**2<=NPC、6<=场景动画**/
				if(AppResInfoGroupVO(a[i]).type != 6) continue;
				
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
			dat.callBackFun = selectedSceneResCallBack2;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}		
		private function selectedSceneResCallBack2(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			/**2<=NPC、6<=场景动画**/
			if(item.type != 2 && item.type != 6)
			{
				showMessage("请选择 相当应的 分类");
				return;
			}
			
			get_MapEditorLayoutContainerMediator().loadSourceByItme(item, null, 1);			
		}
		
		
		
		/**预览按钮点击**/
		public function reactToPreviewButtonClick(e:MouseEvent):void
		{
			if(!MapEditorDataManager.getInstance().hasDefaultSceneCount())
			{
				showMessage("还未设置角色层，<br>请到 \“场景层次\” 列表中点击 \“编辑\” \> \“设为角色层\” ！");
				return;
			}
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.MapEditorPreviewPopupwin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		
		/**保存按钮点击**/
		public function reactToSaveButtonClick(e:MouseEvent):void
		{
			if(!MapEditorDataManager.getInstance().currentSelectedSceneItme)
			{
				showMessage("没有选择任何场景，无内容可保存！");
				return;
			}
			
			if(!MapEditorDataManager.getInstance().hasDefaultSceneCount())
			{
				showMessage("还未设置角色层，<br>请到 \“场景层次\” 列表中点击 \“编辑\” \> \“设为角色层\” ！");
				return;
			}
			
			saveButton.enabled = false;
			
			var x:XML = MapEditorDataManager.getInstance().exportXML();
						
			var httpObj:URLVariables = new URLVariables();
			httpObj.mapid = MapEditorDataManager.getInstance().currentSelectedSceneItme.id;
			httpObj.data = x.toString();
			httpObj.srt = "2";
			httpObj.project = MapEditorManager.currProject.data;
			httpObj.savePath = MapEditorManager.currProject.saveFold; //config/map
						
			var http:AS3HTTPServiceLocator = new AS3HTTPServiceLocator();
			http.args = httpObj;
			http.sucResult_f = confirmSuc;
			http.fault_f = confirmFau;
			http.conn(MapEditorConfigVO.instance.serverDomain, SandyEngineConst.HTTP_POST);
		}
		
		private function confirmSuc(dat:*=null):void
		{
			showMessage("保存成功：" + MapEditorDataManager.getInstance().currentSelectedSceneItme.id + ".xml");
			saveButton.enabled = true;
		}
		private function confirmFau(dat:*=null):void
		{
			showMessage("保存失败：" + MapEditorDataManager.getInstance().currentSelectedSceneItme.id + ".xml");
			saveButton.enabled = true;
		}
		
		
		/**显示隐藏LOG**/
		public function reactToVisiLogButtonClick(e:MouseEvent):void
		{
			get_MapEditorModuleMediator().logContainer.visible = !get_MapEditorModuleMediator().logContainer.visible;
			
			if(get_MapEditorModuleMediator().logContainer.visible)
			{
				visiLogButton.label = "隐藏LOG";
			}else
			{
				visiLogButton.label = "显示LOG";
			}
			
		}
		
		
		/** <<gets **/
		private function get_MapEditorModuleMediator():MapEditorModuleMediator
		{
			return retrieveMediator(MapEditorModuleMediator.NAME) as MapEditorModuleMediator;
		}
		private function get_MapEditorLeftContainerMediator():MapEditorLeftContainerMediator
		{
			return retrieveMediator(MapEditorLeftContainerMediator.NAME) as MapEditorLeftContainerMediator;
		}
		private function get_MapEditorLayoutContainerMediator():MapEditorLayoutContainerMediator
		{
			return retrieveMediator(MapEditorLayoutContainerMediator.NAME) as MapEditorLayoutContainerMediator;
		}
		private function get_MapEditorProxy():MapEditorProxy
		{
			return retrieveProxy(MapEditorProxy.NAME) as MapEditorProxy;
		}
		
	}
		
}
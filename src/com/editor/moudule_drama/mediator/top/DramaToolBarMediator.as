package com.editor.moudule_drama.mediator.top
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.DramaModule;
	import com.editor.moudule_drama.data.DramaConfig;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.mediator.DramaModuleMediator;
	import com.editor.moudule_drama.mediator.right.DramaRightContainerMediator;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.proxy.DramaProxy;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.view.top.DramaToolBar;
	import com.editor.moudule_drama.vo.DramaConfigVO;
	import com.editor.moudule_drama.vo.drama.Drama_FrameClipVO;
	import com.editor.moudule_drama.vo.drama.Drama_LoadingLayoutResData;
	import com.editor.moudule_drama.vo.drama.Drama_RowVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameBaseVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameDialogVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameMovieVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameSceneVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewSequenceVO;
	import com.editor.moudule_drama.vo.drama.layout.IDrama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotItemVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotListNodeVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotListVO;
	import com.editor.moudule_drama.vo.project.DramaProjectItemVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.editor.services.Services;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class DramaToolBarMediator extends AppMediator
	{
		public static const NAME:String = "DramaToolBarMediator";
				
		public function DramaToolBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():DramaToolBar
		{
			return viewComponent as DramaToolBar;
		}
		/**选择剧情按钮**/
		public function get selectDramaButton():UIButton
		{
			return mainUI.selectDramaButton;
		}
		/**更新剧情配置按钮**/
		public function get updataDramaConfigButton():UIButton
		{
			return mainUI.updataDramaConfigButton;
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
		/**项目文本**/
		public function get infoTxt():UILabel
		{
			return mainUI.infoTxt;
		}		
		/**当前剧情文本**/
		public function get infoTxt2():UILabel
		{
			return mainUI.infoTxt2;
		}
		/**当前片断文本**/
		public function get infoTxt3():UILabel
		{
			return mainUI.infoTxt3;
		}
		public function get visiTimelineButton():UIButton
		{
			return mainUI.visiTimelineButton;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		/**选择剧情按钮点击**/
		public function reactToSelectDramaButtonClick(e:MouseEvent):void
		{
			/**判断是否允许操作**/
			if(!DramaManager.getInstance().isEnabledToControl())
			{
				return;
			}
			
			if(DramaDataManager.getInstance().currentSelectedDramaItem)
			{
				var confirmData:OpenMessageData = new OpenMessageData();
				confirmData.info = "些操作将覆盖之前编辑的内容，\<br\>是否确定已保存之前编辑的剧情？";
				confirmData.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
				confirmData.okFunction = okFunction;
				showConfirm(confirmData);
				
				return;
			}
			
			function okFunction():Boolean
			{
				selectedDrama();
				
				return true;
			}
			selectedDrama();
		}
		/**选择剧情**/
		public function selectedDrama():void
		{
			var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
			vo.data = DramaManager.getInstance().get_DramaProxy().plot_ls.list;
			vo.labelField = "name1";
			vo.label = "选择要编辑的剧情: ";
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
			dat.data = vo;
			dat.callBackFun = selectedDramaCallBack;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		private function selectedDramaCallBack(item:DramaPlotListNodeVO, item1:SelectEditPopWin2VO):void
		{
			DramaDataManager.getInstance().currentSelectedDramaItem = item;
			infoTxt2.htmlText = "当前剧情：" + "<font color='#00CC00'><b>" + item.name + "</b></font>";
			
			/**清除上一个场景数据**/
			DramaManager.getInstance().selectNewDramaClear();
						
			var fileUrl:String = DramaConfig.currProject.mapConfigUrl + "drama/" + item.id + ".xml";
			
			var request:URLRequest = new URLRequest(fileUrl + "?" + (Math.random()+Math.random()));
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadXMLComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadXMLError);
			try
			{
				loader.load(request);
			}
			catch(error:Error)
			{
				trace("load currentSelectedSceneXmlUrl error:" + error.message);
			}
						
			DramaManager.getInstance().get_DramaModuleMediator().addLog2("开始加载剧情XML：" + fileUrl);
		}
		private function loadXMLComplete(e:Event):void
		{
			var fileUrl:String = DramaConfig.currProject.mapConfigUrl + "drama/" + DramaDataManager.getInstance().currentSelectedDramaItem.id + ".xml";
			DramaManager.getInstance().get_DramaModuleMediator().addLog2("加载剧情XML成功：" + fileUrl);
			
			parseDramaXML(XML(e.target.data));
						
		}		
		private function loadXMLError(e:IOErrorEvent):void
		{
			var fileUrl:String = DramaConfig.currProject.mapConfigUrl + "drama/" + DramaDataManager.getInstance().currentSelectedDramaItem.id + ".xml";
			DramaManager.getInstance().get_DramaModuleMediator().addLog2("加载剧情XML失败：" + fileUrl + "，将生成新的剧情XML");
		}
		
				
		/**解析剧情XML**/
		private function parseDramaXML(x:XML):void
		{			
			/**片段剪辑**/
			for each(var fcX:XML in x.fc.i)
			{
				var fcVO:Drama_FrameClipVO = new Drama_FrameClipVO();
				fcVO.id = fcX.@id;
				fcVO.name = fcX.@n;
				fcVO.index = fcX.@ix;
				fcVO.lastFrame = fcX.@lf;
				DramaDataManager.getInstance().addFrameClip(fcVO);
			}
			DramaManager.getInstance().get_DramaLeftContainerMediator().updataFrameClipList();
			
			/**层**/
			
			
			
			/**显示资源**/
			for each(var vX:XML in x.v.i)
			{
				var vid:String = vX.@id;
				var vRowId:String = vX.@r;
				var vSourceId:int = vX.@sid;
				var vSourceType:int = vX.@st;
				var cName:String = vX.@sn;
				
				if(vid && vRowId != "" && vSourceId && vSourceType)
				{
					var vResInfo:AppResInfoItemVO = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getResInfoItemByID(vSourceId);					
					var layoutVO:IDrama_LayoutViewBaseVO = DramaManager.getInstance().getNewLayoutVO_BySourceType(vSourceType);
										
					/**base**/
					if(layoutVO is Drama_LayoutViewBaseVO)
					{
						var vBaseVO:Drama_LayoutViewBaseVO = layoutVO as Drama_LayoutViewBaseVO;
						vBaseVO.id = vid;
						vBaseVO.rowId = vRowId;
						vBaseVO.sourceId = vSourceId;
						vBaseVO.sourceType = vSourceType;
						vBaseVO.sourceName = vResInfo.name;			
						vBaseVO.customName = cName;
					}
					
					DramaDataManager.getInstance().addLayoutView(layoutVO);
					
					var loadingData:Drama_LoadingLayoutResData = new Drama_LoadingLayoutResData();
					loadingData.loading_layoutViewVO = layoutVO;
					loadingData.loading_resInfoItemVO = vResInfo;
					loadingData.fileType = DramaConst.file_jpg;
					loadingData.loadingType = DramaConst.loading_res;
					DramaManager.getInstance().get_DramaLayoutContainerMediator().loadSourceByItme(loadingData);
					
				}
			}
			
			
			parseDramaXML2(x);
			
		}
		/**解析剧情XML	第二步**/
		private function parseDramaXML2(x:XML):void
		{
			/**关键帧**/
			for each(var fX:XML in x.f.i)
			{
				var fId:String = fX.@id;
				var fType:int = fX.@t;
				var fFrame:int = fX.@f;
				var fRowId:String = fX.@r;
				var fClipId:String = fX.@fc;
				var fClipVO:Drama_FrameClipVO = DramaDataManager.getInstance().getFrameClip(fClipId);
				
				if(fId != "" && fType && fFrame && fRowId != "" && fClipVO)
				{
					var feX:XML = XML(fX.e);
					
					var fVO:ITimelineKeyframe_BaseVO;
					var keyfRowVO:Drama_RowVO = DramaDataManager.getInstance().getRowById(fRowId);
					var keyfRowType:int = keyfRowVO.type;
					if(keyfRowType == 1)
					{
						fVO = new Drama_FrameSceneVO();
						
					}else if(keyfRowType == 2)
					{
						fVO = new Drama_FrameResRecordVO();
						
					}else if(keyfRowType == 3)
					{
						fVO = new Drama_FrameMovieVO();
						
					}else if(keyfRowType == 4)
					{
						fVO = new Drama_FrameDialogVO();
					}
					
					/**帧 基础数据**/
					if(fVO)
					{
						fVO.id = fId;
						fVO.type = fType;
						fVO.rowId = fRowId;
						fVO.frame = fFrame;
						if(fVO is Drama_FrameBaseVO)
						{
							(fVO as Drama_FrameBaseVO).frameClipId = fClipId;
						}
					}
					
					/**帧 扩展数据**/
					if(feX)
					{
						if(fVO is Drama_FrameBaseVO)
						{
							(fVO as Drama_FrameBaseVO).parseExtendXML(feX);
						}
					}
					
					/**计算片断中帧数**/
					var startFrame:int = DramaDataManager.getInstance().getFrameClipStartFrame(fClipId);
					fVO.frame = fVO.frame - startFrame;
					
					fClipVO.keyframeList.put(fVO.id, fVO);
					
				}
			}
			
			DramaDataManager.getInstance().selectedFrame = 1;
			DramaManager.getInstance().get_DramaLeftContainerMediator().frameClipListVbox.selectedIndex = 0;
			
		}
		
		/**更新剧情配置按钮点击**/
		public function reactToUpdataDramaConfigButtonClick(e:MouseEvent):void
		{
			var confirmData:OpenMessageData = new OpenMessageData();
			confirmData.info = "是否确定更新剧情配置？";
			confirmData.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
			confirmData.okFunction = okFunction;
			showConfirm(confirmData);
					
			function okFunction():Boolean
			{
				updataDramaConfig();
				return true;
			}
		}
		/**更新剧情配置**/
		private function updataDramaConfig():void
		{
			/**判断是否允许操作**/
			if(!DramaManager.getInstance().isEnabledToControl())
			{
				return;
			}
			
			var item:DramaProjectItemVO = DramaConfig.currProject;
			var plot_xml_url:String = item.xml_ls.getItemByKey(Services.plot_xml_url).info;
			
			var request:URLRequest = new URLRequest(plot_xml_url + "?" + (Math.random()+Math.random()));
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadDramaConfigXMLComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadDramaConfigXMLError);
			try
			{
				loader.load(request);
				DramaManager.getInstance().get_DramaModuleMediator().addLog2("开始更新剧情配置");
			}
			catch(error:Error)
			{
				trace("load currentSelectedSceneXmlUrl error:" + error.message);
			}
			
		}
		private function loadDramaConfigXMLComplete(e:Event):void
		{
			DramaManager.getInstance().get_DramaModuleMediator().addLog2("更新剧情配置成功");
			
			var configX:XML = XML(e.target.data);
			DramaManager.getInstance().get_DramaProxy().plot_ls = new DramaPlotListVO(configX);
			
		}		
		private function loadDramaConfigXMLError(e:IOErrorEvent):void
		{
			DramaManager.getInstance().get_DramaModuleMediator().addLog2("更新剧情配置失败");
		}
		
		/**预览按钮点击**/
		public function reactToPreviewButtonClick(e:MouseEvent):void
		{
			/**判断是否允许操作**/
			if(!DramaManager.getInstance().isEnabledToControl())
			{
				return;
			}
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.DramaPreviewPopupwin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
			
		}
		
		/**保存按钮点击**/
		public function reactToSaveButtonClick(e:MouseEvent):void
		{
			/**判断是否允许操作**/
			if(!DramaManager.getInstance().isEnabledToControl())
			{
				return;
			}
			saveButton.enabled = false;
			
			var x:XML = DramaDataManager.getInstance().exportXML();
			
			var httpObj:URLVariables = new URLVariables();
			httpObj.mapid = DramaDataManager.getInstance().currentSelectedDramaItem.id;
			httpObj.data = x.toString();
			httpObj.project = DramaConfig.currProject.data;
			httpObj.savePath = DramaConfig.currProject.saveFold; //config/map
			httpObj.srt = "2";
			trace("httpObj.mapid:" + httpObj.mapid + ",		httpObj.data:" + httpObj.data + ",	httpObj.project:" + httpObj.project + ",	httpObj.savePath:" + httpObj.savePath)
			
			var http:AS3HTTPServiceLocator = new AS3HTTPServiceLocator();
			http.args = httpObj;
			http.sucResult_f = confirmSuc;
			http.fault_f = confirmFau;
			http.conn(DramaConfigVO.instance.serverDomain, SandyEngineConst.HTTP_POST);
		}
		
		private function confirmSuc(dat:*=null):void
		{
			showMessage("保存成功：" + DramaDataManager.getInstance().currentSelectedDramaItem.id + ".xml");
			saveButton.enabled = true;
		}
		private function confirmFau(dat:*=null):void
		{
			showMessage("保存失败：" + DramaDataManager.getInstance().currentSelectedDramaItem.id + ".xml");
			saveButton.enabled = true;
		}
		
		/**显示隐藏	时间轴**/
		public function reactToVisiTimelineButtonClick(e:MouseEvent):void
		{
			if(DramaManager.getInstance().get_DramaRightContainerMediator().vbox.contains(DramaManager.getInstance().get_DramaRightContainerMediator().timelinePanel))
			{
				DramaManager.getInstance().get_DramaRightContainerMediator().vbox.removeChild(DramaManager.getInstance().get_DramaRightContainerMediator().timelinePanel);
				visiTimelineButton.label = "显示 时间轴";
			}else
			{
				DramaManager.getInstance().get_DramaRightContainerMediator().vbox.addChildAt(DramaManager.getInstance().get_DramaRightContainerMediator().timelinePanel, 0);
				visiTimelineButton.label = "隐藏 时间轴";
			}
		}
													   
		
		/**显示隐藏LOG**/
		public function reactToVisiLogButtonClick(e:MouseEvent):void
		{
			DramaManager.getInstance().get_DramaModuleMediator().logContainer.visible = !DramaManager.getInstance().get_DramaModuleMediator().logContainer.visible;
			
			if(DramaManager.getInstance().get_DramaModuleMediator().logContainer.visible)
			{
				visiLogButton.label = "隐藏LOG";
			}else
			{
				visiLogButton.label = "显示LOG";
			}			
		}
		
			
		
	}
}
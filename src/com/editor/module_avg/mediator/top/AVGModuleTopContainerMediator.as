package com.editor.module_avg.mediator.top
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILoader;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_avg.event.AVGEvent;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.mediator.AVGModuleMediator;
	import com.editor.module_avg.preview.AVGPreview;
	import com.editor.module_avg.view.top.AVGModuleTopContainer;
	import com.editor.module_avg.vo.AVGConfigVO;
	import com.editor.module_avg.vo.plot.AVGPlotItemVO;
	import com.editor.module_avg.vo.sec.AVGSectionListVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	public class AVGModuleTopContainerMediator extends AppMediator
	{
		public static const NAME:String = "AVGModuleTopContainerMediator";
		public function AVGModuleTopContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():AVGModuleTopContainer
		{
			return viewComponent as AVGModuleTopContainer;
		}
		public function get loadBtn():UIButton
		{
			return mainUI.loadBtn;
		}
		public function get infoTxt():UILabel
		{
			return mainUI.infoLB;
		}
		public function get preBtn():UIButton
		{
			return mainUI.preBtn;
		}
		public function get saveBtn():UIButton
		{
			return mainUI.saveBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function reactToLoadBtnClick(e:MouseEvent):void
		{
			if(AVGManager.currPlot == null){
				confirm();
			}else{
				var mess:OpenMessageData = new OpenMessageData();
				mess.info = "在编辑新的剧情前请确定保存,您确定要选择新的编辑?"
				//mess.okFunArgs = item;
				mess.okFunction = confirm;
				showConfirm(mess);
			}
		}
		
		private function confirm():Boolean
		{
			var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
			vo.data = AVGManager.getInstance().plotList.list;
			vo.labelField = "name1";
			vo.label = "选择要编辑的剧情: ";
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
			dat.data = vo;
			dat.callBackFun = selectedDramaCallBack;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
			return true;
		}
		
		private function selectedDramaCallBack(item:AVGPlotItemVO, item1:SelectEditPopWin2VO):void
		{
			AVGManager.currPlot = item;
			
			var ld:UILoader = new UILoader();
			ld.complete_fun = loadComplete;
			ld.ioError_fun = loadError;
			ld.load(AVGManager.currProject.resFold+"/config/avg/"+item.id+".xml",false,false,false,false,false,true);
		}
		
		private function loadError(e:*=null):void
		{
			loadComplete("");
		}
		
		private function loadComplete(x:String=""):void
		{
			AVGManager.getInstance().sectionList = new AVGSectionListVO();
			if(!StringTWLUtil.isWhitespace(x)){
				AVGManager.getInstance().sectionList.setXML(XML(x));
			}
			reflashTxt()
			AVGManager.getInstance().clear();
			AVGPreview.instance.dispose();
			sendAppNotification(AVGEvent.selectPlot_inavg_event);	
			sendAppNotification(AVGEvent.reflashOutline_inavg_event);
			sendAppNotification(AVGEvent.reflashTimeline_inavg_event);
		}
		
		private function reflashTxt():void
		{
			infoTxt.htmlText = "选中项目： " + ColorUtils.addColorTool(AVGManager.currProject.name,ColorUtils.red); 
			infoTxt.htmlText +=	" / 选中剧情: " + ColorUtils.addColorTool(AVGManager.currPlot.name1,ColorUtils.green);
			if(AVGManager.currSection!=null){
				infoTxt.htmlText += " / 选中分段：" +ColorUtils.addColorTool( AVGManager.currSection.name,ColorUtils.blue);
			}
			if(AVGManager.currFrame!=null){
				infoTxt.htmlText += " / 选中帧：" +ColorUtils.addColorTool( AVGManager.currFrame.index,ColorUtils.yellow);
			}
		}
		
		public function respondToSelectFrameInavgEvent(noti:Notification):void
		{
			reflashTxt()
		}
		
		public function respondToSelectSectionInavgEvent(noti:Notification):void
		{
			reflashTxt();
		}
		
		public function reactToPreBtnClick(e:MouseEvent):void
		{
			get_AVGModuleMediator().openPlayView();
		}
		
		public var http:AS3HTTPServiceLocator;
		
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			//http://192.168.0.9:82/gdps/sub/fileData.do?m=saveConfig&srt=2&project=Palace4_cn_cn&savePath=res/res&fileName=xxx.xml&data=xxx
			if(http == null){
				http = new AS3HTTPServiceLocator();
				http.sucResult_f = confirmSuc;
			}
			
			var httpObj:URLVariables = new URLVariables();
			httpObj.m = "saveConfig"
			httpObj.srt = 2;
			httpObj.project = AVGManager.currProject.data;
			httpObj.savePath = AVGManager.currProject.saveFold;
			httpObj.fileName = AVGManager.currPlot.id + ".xml";
			httpObj.data = AVGManager.getInstance().sectionList.getXML();
			
			//trace("save, " + httpObj.toString());
			http.args = httpObj;
			http.conn(AVGConfigVO.instance.serverDomain, SandyEngineConst.HTTP_POST);
		}
		
		private function confirmSuc(d:*=null):void
		{
			
		}
		
		private function get_AVGModuleMediator():AVGModuleMediator
		{
			return retrieveMediator(AVGModuleMediator.NAME) as AVGModuleMediator;
		}
	}
	
}
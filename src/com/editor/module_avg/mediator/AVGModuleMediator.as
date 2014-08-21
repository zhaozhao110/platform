package com.editor.module_avg.mediator
{
	import com.editor.component.containers.UICanvas;
	import com.editor.event.AppEvent;
	import com.editor.mediator.AppMediator;
	import com.editor.module_avg.AVGModule;
	import com.editor.module_avg.event.AVGEvent;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.manager.AVGProxy;
	import com.editor.module_avg.mediator.left.AVGModuleLeftContainerMediator;
	import com.editor.module_avg.mediator.right.AVGModuleRightContainerMediator;
	import com.editor.module_avg.mediator.top.AVGModuleTopContainerMediator;
	import com.editor.module_avg.pop.options.AVGOptionsPopView;
	import com.editor.module_avg.pop.preview.AVGPlayview;
	import com.editor.module_avg.pop.txt.AVGEditTxtPopView;
	import com.editor.module_avg.view.left.AVGModuleLeftContainer;
	import com.editor.module_avg.view.right.AVGModuleRightContainer;
	import com.editor.module_avg.view.top.AVGModuleTopContainer;
	import com.editor.module_avg.vo.AVGConfigVO;
	import com.editor.module_avg.vo.plot.AVGPlotListVO;
	import com.editor.module_avg.vo.project.AVGProjectItemVO;
	import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
	import com.sandy.component.expand.ModelMaskContainer;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;

	public class AVGModuleMediator extends AppMediator
	{
		public static const NAME:String = "AVGModuleMediator";
		public function AVGModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():AVGModule
		{
			return viewComponent as AVGModule;
		}
		public function get toolBar():AVGModuleTopContainer
		{
			return mainUI.toolBar;
		}
		public function get leftCont():AVGModuleLeftContainer
		{
			return mainUI.leftCont;
		}
		public function get rightCont():AVGModuleRightContainer
		{
			return mainUI.rightCont;
		}
		public function get popCont():UICanvas
		{
			return mainUI.popCont;
		}
		
		public var topMediator:AVGModuleTopContainerMediator;
		public var leftMediator:AVGModuleLeftContainerMediator;
		public var rightMediator:AVGModuleRightContainerMediator;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(topMediator = new AVGModuleTopContainerMediator(toolBar));
			registerMediator(leftMediator = new AVGModuleLeftContainerMediator(leftCont));
			registerMediator(rightMediator = new AVGModuleRightContainerMediator(rightCont));
			new AVGProxy();
			AVGProxy.instance.load();
			openSelectProject();
		}
		
		private function openSelectProject():void
		{
			var obj:SelectProjectPopwinVO = new SelectProjectPopwinVO;
			obj.data = AVGConfigVO.instance.project_ls.list
			obj.labelField = "name";
			obj.callFun = selectProjectCallBackFun
			sendAppNotification(AppEvent.selectProject_event,obj);
		}
		
		private function selectProjectCallBackFun(item:AVGProjectItemVO):void
		{
			AVGManager.currProject = item;
			topMediator.infoTxt.text = "选中项目： " + AVGManager.currProject.name;
			loadXML();
		}
		
		public function loadXML():void
		{
			var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();
			
			var item:AVGProjectItemVO = AVGManager.currProject;
			if(item == null) return ;
			
			var plot_xml_url:String = item.xml_ls.getItemByKey("avgPlot.xml").info;
			if(AVGManager.getInstance().plotList == null){
				trace("load xml: " + plot_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(plot_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			
			var dt:ILoadQueueDataProxy = iResource.getLoadQueueDataProxy();
			dt.multSourceData = mutltLoadData;
			dt.allLoadComplete_f = loadXMLComplete;
			iResource.loadMultResource(dt);
		}
		
		private function loadXMLComplete(e:*=null):void
		{
			var item:AVGProjectItemVO = AVGManager.currProject
			
			var plot_xml_url:String = item.xml_ls.getItemByKey("avgPlot.xml").info;
			if(AVGManager.getInstance().plotList == null){
				AVGManager.getInstance().plotList = new AVGPlotListVO(XML(iCacheManager.getCompleteLoadSource(plot_xml_url)));
			}
			
			sendAppNotification(AVGEvent.selectProject_inavg_event);
		}
		
		private var editTxtPop:AVGEditTxtPopView;
		public function openEditTxt():void
		{
			if(AVGManager.currFrame == null){
				showError("请先选择某一帧");
				return ;
			}
			hideAllPop();
			if(editTxtPop == null){
				editTxtPop = new AVGEditTxtPopView();
				popCont.addChild(editTxtPop);
			}
			editTxtPop.visible = true
			popCont.visible = true
		}
		public function closeEditTxt():void
		{
			if(editTxtPop!=null) editTxtPop.visible = false;
			popCont.visible = false
		}
		
		public function hideAllPop():void
		{
			var n:int = popCont.numChildren
			for(var i:int=0;i<n;i++){
				if(popCont.getChildAt(i) is ModelMaskContainer){
					
				}else{
					popCont.getChildAt(i).visible = false;
				}
			}
		}
		
		private var optionPop:AVGOptionsPopView;
		public function openOptionPop():void
		{
			if(AVGManager.currFrame == null){
				showError("请先选择某一帧");
				return ;
			}
			hideAllPop()
			if(optionPop == null){
				optionPop = new AVGOptionsPopView();
				popCont.addChild(optionPop);
			}
			optionPop.visible = true
			popCont.visible = true
		}
		public function closeOptionPop():void
		{
			if(optionPop!=null) optionPop.visible = false;
			popCont.visible = false
		}
		
		private var playView:AVGPlayview;
		public function openPlayView():void
		{
			hideAllPop();
			if(playView == null){
				playView = new AVGPlayview();
				popCont.addChild(playView);
			}
			popCont.visible = true;
			playView.visible = true
		}
		public function closePlayView():void
		{
			if(playView!=null)playView.visible=false;
			popCont.visible = false;
		}
		
	}
}
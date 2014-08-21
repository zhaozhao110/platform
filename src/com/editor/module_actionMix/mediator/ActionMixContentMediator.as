package com.editor.module_actionMix.mediator
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.manager.DataManager;
	import com.editor.manager.XMLCacheManager;
	import com.editor.mediator.AppMediator;
	import com.editor.module_actionMix.component.ActionMixHidePreviewImage;
	import com.editor.module_actionMix.component.ActionMixPreviewImage;
	import com.editor.module_actionMix.component.ActionMixPreviewImageContainer;
	import com.editor.module_actionMix.component.ActionMixQueueItemRenderer;
	import com.editor.module_actionMix.manager.ActionMixManager;
	import com.editor.module_actionMix.proxy.ActionMixProxy;
	import com.editor.module_actionMix.view.ActionMixContent;
	import com.editor.module_actionMix.view.ActionMixToolBar;
	import com.editor.module_actionMix.vo.ActionMixActionXMLItemVO;
	import com.editor.module_actionMix.vo.ActionMixConfigVO;
	import com.editor.module_actionMix.vo.ActionMixData;
	import com.editor.module_actionMix.vo.mix.ActionMixItemVO;
	import com.editor.module_actionMix.vo.mix.ActionMixTypeVO;
	import com.editor.module_roleEdit.vo.action.ActionData;
	import com.editor.module_roleEdit.vo.motion.AppMotionActionVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.services.Services;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.controls.SandyLoader;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.render2D.map.data.SandyMapSourceData;
	import com.sandy.render2D.map2.SandyMapConst2;
	import com.sandy.render2D.mapBase.animation.AnimActionRect;
	import com.sandy.render2D.mapBase.animation.Animation;
	import com.sandy.render2D.mapBase.animation.AnimationManager;
	import com.sandy.render2D.mapBase.animation.AnimationMixTimeline;
	import com.sandy.render2D.mapBase.animation.EffectPngAnimation;
	import com.sandy.render2D.mapBase.loader.SandyMapLoaderManager;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	public class ActionMixContentMediator extends AppMediator
	{
		public static const NAME:String = "ActionMixContentMediator"
		public function ActionMixContentMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get content():ActionMixContent
		{
			return viewComponent as ActionMixContent;
		}
		public function get infoText():UILabel
		{
			return content.infoText;
		}
		public function get toolBar():ActionMixToolBar
		{
			return content.toolBar;
		}
		public function get previewImg():ActionMixPreviewImageContainer
		{
			return content.previewImg;
		}
		public function get queueBox():UIVBox
		{
			return content.queueBox;
		}
		public function get imgListBox():UIVBox
		{
			return content.imgListBox;
		}
		//预览合成动作
		public function get previewBtn():UIButton
		{
			return content.previewBtn;
		}
		//预览基本动作
		public function get previewBtn2():UIButton
		{
			return content.previewBtn2;
		}
		public function get actionTypeCB():UICombobox
		{
			return content.actionTypeCB;
		}
		public function get logTxt():UITextArea
		{
			return content.logTxt;
		}
		public function get insertBtn():UIButton
		{
			return content.insertBtn;
		}
		public function get insertTypeCB():UICombobox
		{
			return content.insertTypeCB;
		}
		public function get infoTxt():UILabel
		{
			return content.infoTxt;
		}
		
		override public function onRegister():void
		{
			super.onRegister()
				
			actionTypeCB.labelField = "type_str";
			actionTypeCB.addEventListener(ASEvent.CHANGE , actionTypeChange)
			actionTypeCB.dataProvider = ActionMixManager.god_action_ls;
			actionTypeCB.selectedIndex = 0;
				
			registerMediator(new ActionMixToolBarMediator(toolBar));
			
			insertTypeCB.selectedIndex = 0;
		}
		
		
		private var selectRes:AppResInfoItemVO;
		private var actionItem:ActionMixActionXMLItemVO;
		public var mixItem:ActionMixItemVO;
		private var loader:SandyLoader;
		private var hideImage_ls:Array = [];
		public var curr_action:ActionMixData;
		private var mixTimeline:AnimationMixTimeline = new AnimationMixTimeline()
		
		public function editMotion(item:AppResInfoItemVO,item1:ActionMixActionXMLItemVO):void
		{
			reset();
			
			actionItem = item1;
			selectRes = item;
			mixItem = get_ActionMixProxy().mix_ls.getItemByActionGroup(actionItem.actionGruopId,actionItem.id);
			
			if(loader == null){
				loader = new SandyLoader();
				loader.complete_fun = loadCompete;
			}else{
				loader.unload();
			}
			loader.load(item.getSwfURL());
			addLog2("load swf: " + item.getSwfURL());
		}
		
		private function reset():void
		{
			queueBox.removeAllChildren();
			clearHideImage()
			curr_action = null;
			mixTimeline.dispose();
		}
		
		private function loadCompete():void
		{
			SandyMapLoaderManager.getInstance().addLoadQueue2(selectRes.getSwfURL(),loader.getContentLoaderInfo().applicationDomain,null);
			parserImage();
		}
		
		private function clearHideImage():void
		{
			for(var i:int=0;i<hideImage_ls.length;i++){
				ActionMixHidePreviewImage(hideImage_ls[i]).dispose();
			}
			hideImage_ls = null;
			hideImage_ls = [];
		}
		
		private function parserImage():void
		{
			clearHideImage();
			
			var a:Array = ActionMixManager.god_action_ls;
			for(var i:int=0;i<a.length;i++)
			{
				var d:ActionMixData = a[i] as ActionMixData;
				var sign:String = "e" + selectRes.id + "_" + d.type;
				iCacheManager.addCacheBitmapData(SandyMapConst.getURLSign(sign,d.type),iResource.getBitmapData(sign,loader.getContentLoaderInfo().applicationDomain),null);	
				
				var item:AppMotionItemVO = get_ActionMixProxy().motion_ls.getMotionById(selectRes.id);
				var item1:AppMotionActionVO = item.getActionByType(d.type);
				if(item1!=null){
					var hideImage:ActionMixHidePreviewImage = new ActionMixHidePreviewImage();
					hideImage.actionType = d.type;
					hideImage.totalForward = 1;
					hideImage.timeline = item1.timeline;
					hideImage.curr_action = item1;
					hideImage.column = item1.column;
					hideImage.setSize(item.size.width,item.size.height);
					var dt:SandyMapSourceData = new SandyMapSourceData();
					dt.sceneType = 1;
					dt.action = d.type;
					dt.url = sign;
					hideImage.getAnimation().parserSwfChild(dt);
					hideImage_ls.push(hideImage);
				}
			}
			
			actionTypeCB.setSelectIndex(0);
			parser();
		}
		
		private function actionTypeChange(e:ASEvent=null):void
		{
			curr_action = actionTypeCB.selectedItem as ActionMixData;
			if(curr_action != null && selectRes!=null){
				var sign:String = "e" + selectRes.id + "_" + curr_action.type;
				sign = SandyMapConst.getURLSign(sign,curr_action.type)
				var a:Array = AnimationManager.getAnimation(sign);
				if(a == null) return ;
				//cell == AnimActionRect
				imgListBox.dataProvider = a[Animation.forward_sign+SandyMapConst.right] as Array;
			}
		}
		
		private function parser():void
		{
			if(mixItem == null) return ;
			var a:Array = mixItem.list;
			queueBox.disabled_measuredSize = true;
			for(var i:int=0;i<a.length;i++)
			{
				var type:ActionMixTypeVO = mixItem.list[i] as ActionMixTypeVO;
				if(type.checkIsEmptyFrame()){
					for(var j:int=0;j<type.total;j++){
						addAction(null,"");
					}
				}else{
					var sign:String = "e" + selectRes.id + "_" + type.actionType;
					sign = SandyMapConst.getURLSign(sign,type.actionType);
					var rect:AnimActionRect = AnimationManager.getAnimActionRect(sign,SandyMapConst.right,type.frameIndex);
					for(j=0;j<type.total;j++){
						addAction(rect,type.actionType);
					}
				}
			}
			queueBox.disabled_measuredSize = false;
		}
		
		/**
		 * add
		 */ 
		public function addAction(rect:AnimActionRect,actionType:String):void
		{
			//if(rect == null) return ;
			//if(curr_action == null) return ;
			if(selectRes == null) return ;
			
			var index:int = -1;
			
			if(insertTypeCB.selectedIndex == 0){
				if(queueBox.selectedIndex == -1){
					index = -1;
				}else{
					index = queueBox.selectedIndex + 1;
				}
			}else{
				if(queueBox.selectedIndex == -1){
					index = -1;
				}else{
					index = queueBox.selectedIndex ;
				}
			}
			
			var rend:ActionMixQueueItemRenderer = new ActionMixQueueItemRenderer();
			rend.uiowner = queueBox;
			rend.resId = selectRes.id;
			if(rect == null){
				rend.frameIndex = -1
			}else{
				rend.frameIndex = rect.index;
			}
			rend.action = actionType;
			rend.rect = rect;
			rend.reflash();
			if(index == -1){
				queueBox.addChild(rend);
			}else{
				queueBox.addChildAt(rend,index);
			}
			
			infoTxt.text = "总帧数: " + queueBox.numChildren;
		}
		
		public function delAction(rend:ActionMixQueueItemRenderer):void
		{
			UIComponentUtil.removeMovieClipChild(queueBox,rend);	
			infoTxt.text = "总帧数: " + queueBox.numChildren;
		}
		
		//预览基本动作
		public function reactToPreviewBtn2Click(e:MouseEvent):void
		{
			if(curr_action == null) return ;
			if(selectRes == null) return ;
			
			previewImg.img.actionType = curr_action.type;
			previewImg.img.forward = SandyMapConst.right;
			
			var item:AppMotionItemVO = get_ActionMixProxy().motion_ls.getMotionById(selectRes.id);
			var action:AppMotionActionVO = item.getActionByType(curr_action.type);
			var sign:String = "e" + selectRes.id + "_" + curr_action.type;
			previewImg.img.reflash(null,sign,action.timeline,1,action,action.column,0)
			previewImg.img.setSize(item.size.width,item.size.height);
		}
		
		public function respondToChangeStackModeEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			if(type != DataManager.stack_actionMix){
				previewImg.img.stop();
			}
		}
		
		public function reactToInsertBtnClick(e:MouseEvent):void
		{
			addAction(null,curr_action.type)
		}
		
		//预览合成动作
		public function reactToPreviewBtnClick(e:MouseEvent):void
		{
			if(curr_action == null) return ;
			if(selectRes == null) return ;
			
			previewImg.img.stop();
			mixTimeline.dispose();
			
			var out:Array = [];
			for(var i:int=0;i<queueBox.numChildren;i++)
			{
				var rend:ActionMixQueueItemRenderer = queueBox.getChildAt(i) as ActionMixQueueItemRenderer;
				out.push(rend.sign);
				mixTimeline.add(rend.sign,rend.rect);
			}
			mixTimeline.filter();
			if(mixTimeline.size() == 0) return ;
			
			var item:AppMotionItemVO = get_ActionMixProxy().motion_ls.getMotionById(selectRes.id);
			previewImg.img.setSize(item.size.width,item.size.height);
			previewImg.img.play_animationMix(mixTimeline);
		}
		
		
		
		public function save():void
		{
			if(mixTimeline.size() == 0){
				showError("请先点击预览合成动作按钮");
				return ;
			}
						
			var httpObj:URLVariables = new URLVariables();
			httpObj.pid = actionItem.actionGruopId;
			httpObj.cid = actionItem.id;
			httpObj.action = mixTimeline.save().join("#");
			httpObj.lvl = mixTimeline.getTimeline(getLevel)
			
			httpObj.project = ActionMixManager.currProject.data;
			httpObj.savePath = ActionMixManager.currProject.saveFold;
			httpObj.fileName = ActionMixManager.currProject.saveFileName;
			
			var http:AS3HTTPServiceLocator = new AS3HTTPServiceLocator();
			http.args = httpObj;
			http.sucResult_f = confirmSuc;
			http.conn(ActionMixConfigVO.instance.serverDomain, SandyEngineConst.HTTP_POST);
		}
		
		private function confirmSuc(dat:*=null):void
		{
			showError("保存成功,请等待几秒，将重新加载缓存");
			
			XMLCacheManager.getXML(Services.actionMix_xml_url).change();
			get_ActionMixModuleMediator().loadXML();
		}
		
		private function getLevel(act:String,frameindex:int):String
		{
			return get_ActionMixProxy().motionLvl_ls.getGroup(selectRes.monsterVoc).getItemByAction(act).getValue(frameindex)
		}
		
		private function get_ActionMixModuleMediator():ActionMixModuleMediator
		{
			return retrieveMediator(ActionMixModuleMediator.NAME) as ActionMixModuleMediator;
		}
		
		private function get_ActionMixProxy():ActionMixProxy
		{
			return retrieveProxy(ActionMixProxy.NAME) as ActionMixProxy;
		}
		
		
		public function addLog2(m:String):void
		{
			logTxt.htmlText += m + "<br>";
		}
	}
}
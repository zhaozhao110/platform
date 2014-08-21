package com.editor.module_actionMix.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_actionMix.proxy.ActionMixProxy;
	import com.editor.module_actionMix.view.ActionMixToolBar;
	import com.editor.module_actionMix.vo.ActionMixActionXMLItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	public class ActionMixToolBarMediator extends AppMediator
	{
		public static const NAME:String = "ActionMixToolBarMediator"
		public function ActionMixToolBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get toolBar():ActionMixToolBar
		{
			return viewComponent as ActionMixToolBar;
		}
		public function get loadMotionBtn():UIButton
		{
			return toolBar.loadMotionBtn;
		}
		public function get saveBtn():UIButton
		{
			return toolBar.saveBtn;
		}
		public function get infoTxt():UILabel
		{
			return toolBar.infoTxt;
		}
		
		override public function onRegister():void
		{
			super.onRegister()
				
		}
		
		public function reactToLoadMotionBtnClick(e:MouseEvent):void
		{
			if(get_imageProxy_actionMix().resInfo_ls == null){
				showError("资源没加载完成");
				return ;
			}
			var out:Array = [];
			var a:Array = get_imageProxy_actionMix().resInfo_ls.group_ls;
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(AppResInfoGroupVO(a[i]).type_str)){
					out.push(a[i]);
				}
			}
			
			var vo:SelectEditPopWinVO = new SelectEditPopWinVO();
			vo.data = out;
			vo.column2_dataField = "name1"
			vo.select_dataField = "item_ls"
						
			//选择要编辑的资源ID
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
			dat.data = vo;
			dat.callBackFun = selectedMotion;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		
		private function selectedMotion(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			var out:Array = [];
			out = get_imageProxy_actionMix().action_ls.getActionList(item.monsterType);
			if(out == null){
				showError("没有动作组配置");
				return ;
			}
			var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
			vo.data = out;
			vo.label = item.name;
			vo.labelField = "name1";
			vo.addData = item;
			
			//选择要编辑的动作
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
			dat.data = vo
			dat.callBackFun = selectActionId;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		
		private function selectActionId(item:ActionMixActionXMLItemVO,item1:SelectEditPopWin2VO):void
		{
			var res:AppResInfoItemVO = item1.addData as AppResInfoItemVO;
			get_ActionMixContentMediator().infoText.text = " 编辑动画: " + res.id + " / 动作组ID： " + item.actionGruopId + " / 动作ID: " + item.id + " / 动作名: " + item.name
			get_ActionMixContentMediator().editMotion(res,item);
		}
		
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			get_ActionMixContentMediator().save();
		}
		
		private function get_imageProxy_actionMix():ActionMixProxy
		{
			return retrieveProxy(ActionMixProxy.NAME) as ActionMixProxy;
		}
		
		private function get_ActionMixContentMediator():ActionMixContentMediator
		{
			return retrieveMediator(ActionMixContentMediator.NAME) as ActionMixContentMediator;
		}
	}
}
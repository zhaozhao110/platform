package com.editor.module_roleEdit.pop.saveNameLoc
{
	
	import com.editor.component.controls.UIButton;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_roleEdit.mediator.PeopleImageDataGridMediator;
	import com.editor.module_roleEdit.mediator.PeopleImageToolBarMediator;
	import com.editor.module_roleEdit.vo.action.ActionData;
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.services.Services;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.expand.SandyTextInputWidthLabel;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.math.SandyPoint;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	

	public class PeopleImageSaveNameLocPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "PeopleImageSaveNameLocPopwinMediator"
		public function PeopleImageSaveNameLocPopwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}

		public function get saveWin():PeopleImageSaveNameLocPopwin
		{
			return viewComponent as PeopleImageSaveNameLocPopwin
		}

		public function get name_x():SandyTextInputWidthLabel
		{
			return saveWin.name_x;
		}

		public function get saveBtn():UIButton
		{
			return saveWin.saveBtn;
		}

		override public function onRegister():void
		{
			super.onRegister();
			createComplete()
		}

		
		private var resItem:AppResInfoItemVO;
		private var motionItem:AppMotionItemVO;
		private var action_ls:Array;
		
		private function createComplete():void
		{
			var dat:OpenPopwinData = getOpenDataProxy(); //获取上层窗口的传值对象
			resItem = dat.data.resItem;
			motionItem = dat.data.motionItem;
			action_ls = dat.data.action_ls;
			if (resItem == null || motionItem == null || action_ls == null)
			{
				showError("缺少必要传值参数");
				return;
			}
			
			name_x.text = String(motionItem.namePoint);
		}

		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(name_x.text)){
				showError("输入名称的坐标");
				return ;
			}
			motionItem.namePoint = name_x.text;
			
			get_PeopleImageToolBarMediator().saveToServer(name_x.text);
			closeWin();
		}
		
		private function get_PeopleImageDataGridMediator():PeopleImageDataGridMediator
		{
			return retrieveMediator(PeopleImageDataGridMediator.NAME) as PeopleImageDataGridMediator;
		}
		
		private function get_PeopleImageToolBarMediator():PeopleImageToolBarMediator
		{
			return retrieveMediator(PeopleImageToolBarMediator.NAME) as PeopleImageToolBarMediator;
		}
	}
}

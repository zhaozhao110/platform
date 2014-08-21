package com.editor.module_roleEdit.pop.save
{
	import com.editor.component.controls.UIButton;
	import com.editor.manager.DataManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.module_roleEdit.mediator.PeopleImageDataGridMediator;
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.expand.SandyTextInputWidthLabel;
	import com.sandy.math.SandyPoint;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	

	public class PeopleImageSavePopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "PeopleImageSavePopwinMediator"
		public function PeopleImageSavePopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get saveWin():PeopleImageSavePopwin
		{
			return viewComponent as PeopleImageSavePopwin
		}
		public function get originalTI():SandyTextInputWidthLabel
		{
			return saveWin.originalTI;
		}
		/*public function get composeTI():GdpsTextInputWidthLabel
		{
			return saveWin.composeTI;
		}*/
		public function get saveBtn():UIButton
		{
			return saveWin.saveBtn;
		}
		
		
		private var motionItem:AppMotionItemVO;
		private var resItem:AppResInfoItemVO;
		
		override public function onRegister():void
		{
			super.onRegister();
			createComplete();
		}
				
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(originalTI.text)){
				showError("输入原点");
				return ;
			}
			
			var txt:String = originalTI.text;
			if(txt.indexOf(",") == -1){
				showError("原点输入格式有误,应该为x,y");
				return ;
			}
			
			var orginalPoint:SandyPoint = new SandyPoint();
			
			orginalPoint.splitString(originalTI.text);
			
			if(!orginalPoint.check()){
				showError("原点输入格式有误,应该为x,y");
				return ;
			}
			
			motionItem.originalPoint = orginalPoint;
						
			get_PeopleImageDataGridMediator().afterSave();
			closeWin();
		}
		
		private function createComplete():void
		{
			var proxy:OpenPopwinData = saveWin.item as OpenPopwinData;
			motionItem = proxy.data as AppMotionItemVO;
			resItem = proxy.addData as AppResInfoItemVO;
			
			if(motionItem!=null&&motionItem.originalPoint!=null){
				originalTI.text = motionItem.originalPoint.getString();
			}else{
				if(RoleEditManager.currProject.data == DataManager.project_Palace4){
					if(resItem.isBattleMode){
						originalTI.text = "223,306"
					}else{
						originalTI.text = "273,374"
					}
				}else if(RoleEditManager.currProject.data == DataManager.project_king2){
					originalTI.text = "200,236"
				}else{
					if(resItem.isBattleMode){
						originalTI.text = "371,608"
					}else{
						originalTI.text = "225,365"
					}
				} 
			}
		}
				
		private function get_PeopleImageDataGridMediator():PeopleImageDataGridMediator
		{
			return retrieveMediator(PeopleImageDataGridMediator.NAME) as PeopleImageDataGridMediator;
		}
		
		
	}
}
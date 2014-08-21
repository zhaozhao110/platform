package com.editor.command.action
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
	import com.editor.vo.project.AppProjectItemVO;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.interfaces.INotification;

	public class AppSelectProjectCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var winVO:SelectProjectPopwinVO = notification.getBody() as SelectProjectPopwinVO;
			if(AppMainModel.getInstance().selectProject!=null){
				var a:Array = winVO.data as Array;
				var selectedProject:*;
				for(var i:int=0;i<a.length;i++){
					if(AppProjectItemVO(a[i]).data == AppMainModel.getInstance().selectProject.data){
						selectedProject = a[i];
						break;
					}
				}
				if(selectedProject!=null){
					winVO.callFun(selectedProject);
					return ;
				}
			}
			
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.SelectProjectPopwin_sign;
			open.data = winVO;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
	}
}
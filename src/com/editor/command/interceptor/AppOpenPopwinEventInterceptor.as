package com.editor.command.interceptor
{
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_changeLog.pop.changeLog.ChangeLogPopwinMediator;
	import com.sandy.popupwin.interfac.IOpenPopupDataProxy;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class AppOpenPopwinEventInterceptor extends AppAbstractInterceptor
	{
		override public function intercept():void 
		{			
			super.intercept();
			
			var open:IOpenPopupDataProxy = notification.getBody() as IOpenPopupDataProxy;
			if(open.popupwinSign == PopupwinSign.PreImagePopWin_sign){
				var url:String = String(open.data);
				if(!StringTWLUtil.isWhitespace(url)){
					var fl:File = new File(url);
					if(!fl.exists){
						showError("该文件不存在");
						skip();
						return 
					}
				}
			}
			
			if(open.popupwinSign == PopupwinSign.ChangeLogPopwin_sign){
				if(ChangeLogPopwinMediator.open_times > 0) return ;
			}
			
			proceed();
		}
	}
}
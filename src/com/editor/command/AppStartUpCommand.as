package com.editor.command
{
	import com.editor.command.action.AppSaveEditorFileCommand;
	import com.editor.command.action.AppSelectProjectCommand;
	import com.editor.command.action.ChangeProjectCommand;
	import com.editor.command.action.ChangeTo2DSceneInterceptor;
	import com.editor.command.action.ChangeUserCommand;
	import com.editor.command.action.CheckNeedDownloadPlusEventCommand;
	import com.editor.command.action.CloseProjectCommand;
	import com.editor.command.action.DownDBFileCommand;
	import com.editor.command.action.DownToolFileCommand;
	import com.editor.command.action.DownloadApiFileCommand;
	import com.editor.command.action.DownloadChangeLogEventCommand;
	import com.editor.command.action.DownloadTempASFileCommand;
	import com.editor.command.action.ImportProjectEventCommand;
	import com.editor.command.action.OpenSystemRightBotTipCommand;
	import com.editor.command.action.PaserProjectLocaleCommand;
	import com.editor.command.action.PreImageCommand;
	import com.editor.command.d3Action.Change3DProjectInterceptor;
	import com.editor.command.d3Action.Change3DSceneInterceptor;
	import com.editor.command.d3Action.ChangeTo3DSceneInterceptor;
	import com.editor.command.d3Action.D3SceneInitEventInterceptor;
	import com.editor.command.d3Action.EditParticleEventInterceptor;
	import com.editor.command.d3Action.Select3DCompEventInterceptor;
	import com.editor.command.interceptor.AppOpenPopwinEventInterceptor;
	import com.editor.command.interceptor.OpenEditFileEventInterceptor;
	import com.editor.command.interceptor.OpenFileInCSSEditorEventInterceptor;
	import com.editor.command.interceptor.OpenFileInUIEditorEventInterceptor;
	import com.editor.command.interceptor.SendGotoGDPSEventInterceptor;
	import com.editor.command.moduleAction.ParserApiCodeCodeEventCommand;
	import com.editor.command.moduleAction.StartParserApiCommand;
	import com.editor.d3.event.D3Event;
	import com.editor.event.App3DEvent;
	import com.editor.event.AppEvent;
	import com.editor.module_gdps.command.GdpsXMLSocketCommand;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.proxy.AppComponentProxy;
	import com.editor.proxy.AppPlusProxy;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.fabrication.SandyAppStartupCommand;
	import com.sandy.puremvc.interfaces.INotification;

	public class AppStartUpCommand extends SandyAppStartupCommand
	{
		
		override protected function finishExecute():void
		{
			super.finishExecute()
			
			sendAppNotification(AppEvent.app_startLoad_event);
		}
				
		override public function registerAllCommand():void{
			registerCommand(AppEvent.app_startLoad_event				, AppStartLoadCommand);
			registerCommand(AppEvent.selectProject_event				, AppSelectProjectCommand);
			registerCommand(AppEvent.openSystemRightBotTip_event		, OpenSystemRightBotTipCommand);
			registerCommand(AppEvent.parserLocale_event					, PaserProjectLocaleCommand);
			registerCommand(AppEvent.importProject_event				, ImportProjectEventCommand);
			registerCommand(AppEvent.changeUser_event					, ChangeUserCommand);
			registerCommand(AppEvent.changeProject_event				, ChangeProjectCommand);
			registerCommand(AppEvent.download_apifile_event				, DownloadApiFileCommand);
			registerCommand(AppEvent.download_tempAS_event				, DownloadTempASFileCommand);
			registerCommand(AppEvent.download_changeLog_event			, DownloadChangeLogEventCommand);
			registerCommand(AppEvent.download_dbFile_event				, DownDBFileCommand);
			registerCommand(AppEvent.checkNeed_downloadPlus_event		, CheckNeedDownloadPlusEventCommand);
			registerCommand(AppEvent.download_tool_event				, DownToolFileCommand)
			registerCommand(AppModulesEvent.closeProject_event			, CloseProjectCommand);
			registerCommand(AppEvent.preImage_event						, PreImageCommand);
			
			registerCommand("startParserApiEvent",StartParserApiCommand);
			registerCommand("parserApiCodeCodeEvent",ParserApiCodeCodeEventCommand);
		}
		
		override public function registerAllSocketDataCommandMediator():void{
			registerSocketDataCommandMediator(ReceiveSocketDataCommandMediator);
			registerSocketDataCommandMediator(GdpsXMLSocketCommand);
		}
		
		override public function registerAllProxy():void{
			registerProxy(new AppComponentProxy())
			registerProxy(new AppPlusProxy());
		}
		
		override public function registerAllCommandMediator():void{
			registerCommandMediator(BackgroundThreadCommand);
		}
		
		override public function registerAllInterceptor():void{
			registerInterceptor(AppModulesEvent.openFile_inCSSEditor_event		, OpenFileInCSSEditorEventInterceptor);
			registerInterceptor(AppModulesEvent.openFile_inUIEditor_event		, OpenFileInUIEditorEventInterceptor);
			registerInterceptor(AppModulesEvent.openEditFile_event				, OpenEditFileEventInterceptor);
			registerInterceptor(SandyExternalEvent.OPEN_POPUPWIN_EVENT			, AppOpenPopwinEventInterceptor);
			registerInterceptor(App3DEvent.changeTo3DScene_event				, ChangeTo3DSceneInterceptor);
			registerInterceptor(D3Event.change3DProject_event				, Change3DProjectInterceptor);
			registerInterceptor(App3DEvent.changeTo2DScene_event 				, ChangeTo2DSceneInterceptor);
			registerInterceptor(D3Event.select3DComp_event 					, Select3DCompEventInterceptor);
			registerInterceptor(App3DEvent.d3SceneInit_event					, D3SceneInitEventInterceptor);
			registerInterceptor(AppEvent.sendGotoGDPS_event						, SendGotoGDPSEventInterceptor);
			registerInterceptor(D3Event.change3DScene_event					, Change3DSceneInterceptor);
			registerInterceptor(D3Event.editParticle_event						, EditParticleEventInterceptor);
		}
		
	}
}
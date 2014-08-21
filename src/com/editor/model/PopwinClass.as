package com.editor.model
{
	import com.editor.d3.pop.createProject.App3DCreateProjectPopupwin;
	import com.editor.d3Popup.preview3DS.D3Preview3DSpopwin;
	import com.editor.d3Popup.previewATF.D3PreviewATFPopup;
	import com.editor.module_changeLog.pop.changeLog.ChangeLogPopwin;
	import com.editor.module_gdps.pop.tableSpace.GdpsTableSpacePopupwin;
	import com.editor.module_map.popup.preview.MapEditorPreviewPopupwin;
	import com.editor.module_map.popup.screenEditor.SceneEditorPopupwin;
	import com.editor.module_map.popup.screenResEditor.SceneResEditorPopupwin;
	import com.editor.module_map2.createMap.CreateMap2Popwin;
	import com.editor.module_mapIso.pop.createMap.CreateMapPopwin;
	import com.editor.module_pop.serverDirManager.ServerDirManagerPopwin;
	import com.editor.module_roleEdit.pop.preview.PeopleImagePreviewPopwin;
	import com.editor.module_roleEdit.pop.preview2.PeopleImagePreviewPopwin2;
	import com.editor.module_roleEdit.pop.save.PeopleImageSavePopwin;
	import com.editor.module_roleEdit.pop.saveNameLoc.PeopleImageSaveNameLocPopwin;
	import com.editor.module_sea.pop.createMap.SeaMapCreateMapPopwin;
	import com.editor.module_sql.pop.createDB.CreateDBPopWin;
	import com.editor.module_sql.pop.createTable.CreateTablePopWin;
	import com.editor.module_sql.pop.openFile.OpenDBFilePopWin;
	import com.editor.module_ui.pop.filterExplorer.FilterExplorer;
	import com.editor.modules.app.AppMainPopupwinModule;
	import com.editor.modules.pop.createClass.AppCreateClassFilePopwin;
	import com.editor.modules.pop.createProject.AppCreateProjectPopupwin;
	import com.editor.modules.pop.editEvent.AppEditEventPopWin;
	import com.editor.modules.pop.editLocale.EditLocalePopwin;
	import com.editor.modules.pop.editPopwin.EditPopPopwin;
	import com.editor.modules.pop.editServerInterface.EditServerInterfacePopwin;
	import com.editor.modules.pop.importSource.AppImportSourcePopupwin;
	import com.editor.modules.pop.pathList.AppPathListPopwin;
	import com.editor.modules.pop.projectHelp.ProjectHelpPopWin;
	import com.editor.modules.pop.recentOpenProject.AppRecentOpenProjectPopwin;
	import com.editor.modules.pop.rename.AppRenameFilePopwin;
	import com.editor.moudule_drama.popup.preview.DramaPreviewPopupwin;
	import com.editor.popup.about.AboutPopwin;
	import com.editor.popup.binaryFile.ParserBinaryFilePopwin;
	import com.editor.popup.debugWin.DebugPopwin;
	import com.editor.popup.diary.DiaryPopwin;
	import com.editor.popup.editImage.EditImagePopwin;
	import com.editor.popup.editXML.EditXMLPopwin;
	import com.editor.popup.input.InputTextAreaPopwin;
	import com.editor.popup.input.InputTextPopwin;
	import com.editor.popup.log.SysLogPopwin;
	import com.editor.popup.packImage.PackImagePopwin;
	import com.editor.popup.plusWin.PlusPopWin;
	import com.editor.popup.preImage.PreImagePopWin;
	import com.editor.popup.previewSwf.PreviewSwfPopwin;
	import com.editor.popup.readPdf.ReadPdfPopwupin;
	import com.editor.popup.selectEdit.SelectEditPopWin;
	import com.editor.popup.selectEdit2.SelectEditPopWin2;
	import com.editor.popup.systemSet.SystemSetPopwin;
	import com.editor.popup.update.AppUpdateWinPopwin;
	import com.editor.popup.upload.UploadFilePopwin;
	import com.editor.popup2.texturepacker.view.JointModule;
	import com.editor.project_pop.addScout.AddScoutPopwin;
	import com.editor.project_pop.createXMLVO.AppCreateXMLPopwin;
	import com.editor.project_pop.flexToAS3.AppFlexToAS3Win;
	import com.editor.project_pop.getLocale.AppGetLocaleWin;
	import com.editor.project_pop.parserSwf.ParserSwfPopwin;
	import com.editor.project_pop.projectLog.ProjectLogPopwin;
	import com.editor.project_pop.projectRes.ProjectResWin;
	import com.editor.project_pop.projectSearch.ProjectSearchPopwin;
	import com.editor.project_pop.projectSet.ProjectSetPopwin;
	import com.editor.project_pop.publish.ProjectPublishPopwin;
	import com.editor.project_pop.report.ProjectReportPopwin;
	import com.editor.project_pop.selectProject.SelectProjectPopwin;
	import com.editor.project_pop.serverCode.CreateServerCodePopwin;
	import com.editor.project_pop.sharedobject.SharedObjectReaderPopWin;
	import com.editor.project_pop.tweenExplorer.TweenExplorerPopwin;
	import com.sandy.popupwin.SandyPopupwinClass;
	
	/**
	 * 初始话窗口的类
	 */ 
	public class PopwinClass extends SandyPopupwinClass
	{
		
		public function PopwinClass():void
		{
			super();
		}
		
		public var win1:AppCreateProjectPopupwin;
		public var win2:AppImportSourcePopupwin;
		public var win4:AppMainPopupwinModule;
		public var win5:AppRecentOpenProjectPopwin;
		public var win6:AppCreateClassFilePopwin;
		public var win7:AppPathListPopwin;
		public var win8:PeopleImagePreviewPopwin;
		public var win9:SelectEditPopWin;
		public var win10:PeopleImageSaveNameLocPopwin;
		public var win11:PeopleImageSavePopwin;
		public var win12:SelectProjectPopwin;
		public var win13:ParserBinaryFilePopwin;
		public var win14:SelectEditPopWin2;
		public var win116:EditXMLPopwin;
		public var win15:SceneEditorPopupwin;
		public var win16:SceneResEditorPopupwin;
		public var win17:MapEditorPreviewPopupwin;
		public var win202:InputTextAreaPopwin;
		public var win100:AboutPopwin;
		public var win101:UploadFilePopwin;
		public var win103:PackImagePopwin;
		public var win104:ServerDirManagerPopwin;
		public var win105:InputTextPopwin;
		public var win106:ProjectResWin; 
		public var win107:AppFlexToAS3Win;
		public var win108:AppGetLocaleWin;
		public var win109:OpenDBFilePopWin;
		public var win110:CreateDBPopWin;
		public var win111:CreateTablePopWin;
		public var win112:FilterExplorer;
		public var win113:AppRenameFilePopwin;
		public var win114:AppCreateXMLPopwin;
		public var win115:CreateServerCodePopwin;
		public var win117:SystemSetPopwin;
		public var win201:ProjectHelpPopWin;
		public var win18:DramaPreviewPopupwin;
		public var win203:PreImagePopWin;
		public var win204:AppUpdateWinPopwin;
		public var win205:AppEditEventPopWin;
		public var win206:EditServerInterfacePopwin;
		public var win207:EditPopPopwin;
		public var win208:EditLocalePopwin;
		public var win209:ProjectReportPopwin;
		public var win210:ProjectPublishPopwin
		public var win211:ParserSwfPopwin;
		public var projectSet:ProjectSetPopwin;
		public var win212:ProjectSearchPopwin
		public var win214:TweenExplorerPopwin;
		public var win215:SysLogPopwin;
		public var win216:ChangeLogPopwin;
		public var win217:SharedObjectReaderPopWin;
		public var win218:CreateMapPopwin;
		//public var win219:DiaryPopwin;
		public var win230:EditImagePopwin;
		public var win231:CreateMap2Popwin;
		public var win234:AddScoutPopwin;
		public var win235:ProjectLogPopwin;
		public var win237:PreviewSwfPopwin;
		public var win238:PeopleImagePreviewPopwin2;
		public var win239:App3DCreateProjectPopupwin;
		public var win240:DebugPopwin;
		
		/////////////////////////////////////// pop2 //////////////////////////////
		public var win300:JointModule;
		public var win301:ReadPdfPopwupin;
		public var win302:SeaMapCreateMapPopwin;
		
		/////////////////////////////////////// d3 //////////////////////////////
		
		public var win10001:D3PreviewATFPopup;
		public var win10002:D3Preview3DSpopwin;
		
		///////////////////////////////// gdps //////////////////////////////////
		public var gdpsWin1:GdpsTableSpacePopupwin;
	}
}
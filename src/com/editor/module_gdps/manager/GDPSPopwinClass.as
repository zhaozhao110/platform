package com.editor.module_gdps.manager
{
	import com.editor.module_gdps.pop.clientPublish.GdpsClientPubishPopupwin;
	import com.editor.module_gdps.pop.clientSave.GdpsClientSavePopupwin;
	import com.editor.module_gdps.pop.colunmProfile.GdpsColumnProfilePopupwin;
	import com.editor.module_gdps.pop.dataBaseAdd.GdpsDataBaseAddPopupwin;
	import com.editor.module_gdps.pop.dataBaseHistory.GdpsDataBaseHistoryPopupwin;
	import com.editor.module_gdps.pop.dataBaseSubmit.GdpsDataBaseSubmitPopupwin;
	import com.editor.module_gdps.pop.dataManageCompare.GdpsDataManageComparePopupwin;
	import com.editor.module_gdps.pop.dataManageHistory.GdpsDataManageHistoryPopupwin;
	import com.editor.module_gdps.pop.dataManageHistory2.GdpsDataManageHistory2Popupwin;
	import com.editor.module_gdps.pop.dataManageImport.GdpsDataManageImportPopupwin;
	import com.editor.module_gdps.pop.dataManagePreview.GdpsDataManagePreviewPopupwin;
	import com.editor.module_gdps.pop.dataManageSubmit.GdpsDataManageSubmitPopupwin;
	import com.editor.module_gdps.pop.lookOperators.GdpsLookOperatorsPopupwin;
	import com.editor.module_gdps.pop.packageAddDetail.GdpsPackageAddDetailPopwin;
	import com.editor.module_gdps.pop.packageDetail.GdpsPackageDetailPopupwin;
	import com.editor.module_gdps.pop.packageDetect.GdpsPackageDetectPopupwin;
	import com.editor.module_gdps.pop.packageEdit.GdpsPackageEditDetailPopupwin;
	import com.editor.module_gdps.pop.packagePacking.GdpsPackagePackingPopupwin;
	import com.editor.module_gdps.pop.packagePublish.GdpsPackagePublishPopupwin;
	import com.editor.module_gdps.pop.productManageAdd.GdpsProductManagePopupwin;
	import com.editor.module_gdps.pop.publishRecord.GdpsPublishRecordPopupwin;
	import com.editor.module_gdps.pop.publishSave.GdpsPublishSavePopupwin;
	import com.editor.module_gdps.pop.publishTest.GdpsPublishTestPopupwin;
	import com.editor.module_gdps.pop.publishTiyan.GdpsPublishTiyanPopupwin;
	import com.editor.module_gdps.pop.resPublish.GdpsResPublishPopupwin;
	import com.editor.module_gdps.pop.resSave.GdpsResSavePopupwin;
	import com.editor.module_gdps.pop.roleManageAdd.GdpsRoleManageAddPopupwin;
	import com.editor.module_gdps.pop.roleManageUser.GdpsRoleManageUserPopupwin;
	import com.editor.module_gdps.pop.serverList.GdpsServerListPopupwin;
	import com.editor.module_gdps.pop.serverManageAdd.GdpsServerManageAddPopupwin;
	import com.editor.module_gdps.pop.serverPublish.GdpsServerPublishPopupwin;
	import com.editor.module_gdps.pop.serverSave.GdpsServerSavePopupwin;
	import com.editor.module_gdps.pop.serverVersion.GdpsServerVersionPopupwin;
	import com.editor.module_gdps.pop.svnLog.GdpsPublishSvnLogPopupwin;
	import com.editor.module_gdps.pop.tableSpace.GdpsTableSpacePopupwin;
	import com.editor.module_gdps.pop.tableSpaceColumn.GdpsTableSpaceColumnPopupwin;
	import com.editor.module_gdps.pop.tableSpaceCreate.GdpsTableSpaceCreatePopupwin;
	import com.editor.module_gdps.pop.userManageAdd.GdpsUserManageAddPopupwin;
	import com.editor.module_gdps.pop.userManageProduct.GdpsUserManageProductPopwin;
	import com.editor.module_gdps.pop.userManageRole.GdpsUserManageRolePopupwin;
	import com.sandy.popupwin.SandyPopupwinClass;
	
	/**
	 * 初始话窗口的类
	 */ 
	public class GDPSPopwinClass extends SandyPopupwinClass
	{
		
		public function GDPSPopwinClass():void
		{
			super();
		}   
		
		public var win1:GdpsTableSpaceColumnPopupwin;
		public var win2:GdpsTableSpacePopupwin;
		public var win3:GdpsTableSpaceCreatePopupwin;
		
		public var win4:GdpsColumnProfilePopupwin;
		
		public var win5:GdpsDataManageImportPopupwin;
		public var win6:GdpsDataManageHistoryPopupwin;
		public var win7:GdpsDataManagePreviewPopupwin;
		public var win8:GdpsDataManageHistory2Popupwin;
		public var win9:GdpsDataManageComparePopupwin;
		public var win10:GdpsDataManageSubmitPopupwin;
		
		public var win11:GdpsPublishRecordPopupwin;
		public var win12:GdpsDataBaseAddPopupwin; 
		public var win13:GdpsDataBaseHistoryPopupwin;
		public var win14:GdpsDataBaseSubmitPopupwin;

		public var win15:GdpsPublishSavePopupwin;
		public var win16:GdpsPackageDetailPopupwin; 
		public var win17:GdpsPackageAddDetailPopwin;
		public var win18:GdpsPackageEditDetailPopupwin;
		public var win19:GdpsPackageDetectPopupwin;
		public var win20:GdpsPackagePackingPopupwin;
		public var win21:GdpsPackagePublishPopupwin;
		
		public var win22:GdpsPublishTestPopupwin;
		public var win23:GdpsPublishSvnLogPopupwin;
		public var win24:GdpsPublishTiyanPopupwin;
	
		public var win25:GdpsClientSavePopupwin;
		public var win26:GdpsClientPubishPopupwin;
		
		public var win27:GdpsResSavePopupwin;
		public var win28:GdpsResPublishPopupwin;
		
		public var win29:GdpsServerSavePopupwin;
		public var win30:GdpsServerVersionPopupwin;
		public var win31:GdpsServerPublishPopupwin;
		public var win32:GdpsServerListPopupwin;
		
		public var win33:GdpsUserManageAddPopupwin;
		public var win34:GdpsUserManageRolePopupwin;
		public var win35:GdpsUserManageProductPopwin;
		
		public var win36:GdpsRoleManageAddPopupwin;
		public var win37:GdpsRoleManageUserPopupwin;
		
		public var win38:GdpsProductManagePopupwin;
		
		public var win39:GdpsServerManageAddPopupwin;
		
		public var win40:GdpsLookOperatorsPopupwin;
		
	}
}
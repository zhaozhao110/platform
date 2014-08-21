package com.editor.d3.process
{
	import com.air.io.SelectFile;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.editor.group.D3MapItemMesh;
	import com.editor.d3.manager.D3ViewManager;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectMesh;
	import com.editor.d3.pop.preList.App3DPreListWin;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.editor.d3.view.attri.preview.MeshPreview;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	
	public class D3ProccessMesh extends D3ProccessObject
	{
		public function D3ProccessMesh(d:D3ObjectMesh)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group7;
		}
		
		override public function get suffix():String
		{
			return D3ComponentConst.sign_3;
		}

		override public function createComp(checkSame:Boolean=false):Boolean
		{
			//outline
			if(!comp.checkIsInProject()){
				return super.createComp(checkSame);
			}
			
			//project
			var f:File = comp.file;
			if(f == null){
				f = comp.compItem.data as File;
			}
			var f2:File;
			if(f.nativePath.indexOf(D3ProjectFilesCache.getInstance().getProjectFold().nativePath)==-1){
				f2 = new File(D3SceneManager.getInstance().displayList.selectedFolder.nativePath+File.separator+f.name);	
			}else{
				f2 = f;
			}
			
			comp.file = f2;
			(comp as D3ObjectMesh).readMesh();
			return true;
		}
				
		override public function selected():void
		{
			if(!comp.checkIsInProject()) return;
			openPreview();
		}
		
		override public function openPreview():void
		{
			D3ViewManager.getInstance().openPreview_mesh(comp);
		}
		
		override protected function _createMapItem_cls():Class
		{
			return D3MapItemMesh;
		}
				
		override public function openViewGetFile(d:D3ComFile,f:Function):void
		{
			if(comp.configData.checkAttri("mesh")){
				var m:OpenMessageData = new OpenMessageData();
				m.info = "确定要更换? , 并且将会删除所有anims和bones";	
				if(d.item.id == 5){
					m.okFunction = changeMesh;
					m.okFunArgs = f;
				}else if(d.item.id == 7){
					super.openViewGetFile(d,f);
					return ;
				}
				
				iManager.iPopupwin.showConfirm(m);
				return ;
			}
			_openViewGetFile(f);
		}
		
		private function _openViewGetFile(f:Function):void
		{
			D3ViewManager.getInstance().openView_mesh(f);
		}
		
		private function changeMesh(f:Function):Boolean
		{
			_openViewGetFile(f);
			return true;
		}

		override public function getPreList(c:D3ComFile):Array
		{
			return D3ProjectFilesCache.getInstance().getAllMaterial();
		}
		
	}
}
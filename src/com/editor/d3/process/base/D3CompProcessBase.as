package com.editor.d3.process.base
{
	import com.air.io.WriteFile;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.manager.D3ViewManager;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.pop.preList.App3DPreListWin;
	import com.editor.d3.process.D3ProccessMethod;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.editor.d3.view.outline.D3OutlinePopViewMediator;
	import com.editor.d3.view.project.D3ProjectPopViewMediator;
	import com.editor.d3.view.source.D3SourcePopViewMediator;
	import com.editor.d3.vo.comp.D3CompItemVO;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.editor.event.App3DEvent;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.error.SandyError;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class D3CompProcessBase 
	{
		public function D3CompProcessBase(d:D3ObjectBase)
		{
			comp = d;
		}
		
		 //////////////////////////////// attri ///////////////////////////////
		
		public var comp:D3ObjectBase;
		//界面
		public var comAttriBase:ID3ComBase;
		
		public function get compType():int
		{
			return -1;
		}
		
		public function getTitle():String
		{
			return "";	
		}
		
		public function get suffix():String
		{
			return "";
		}
		
		public function get fullName():String
		{
			if(StringTWLUtil.isWhitespace(suffix)){
				return comp.name;
			}
			if(comp.name.indexOf(".")!=-1){
				return comp.name;
			}
			return comp.name + "." + suffix;
		}
		
		public var mapItem:D3EditorMapItem;
		
		
		
		
		//////////////////////////////////// function /////////////////////////////
		
		//刷新界面，属性
		//D3AttriGroupViewBase
		public function comReflash(d:ID3ComBase):void
		{
			comAttriBase = d;	
		}
		
		//D3AttriGroupViewBase -- 刷新属性后
		public function initReflashFun():void
		{
			
		}
		
		//D3DisplayListCache -- 创建对象的时候 - outline
		public function createComp(checkSame:Boolean=false):Boolean
		{
			comp.readObject();
			return true;
		}
		
		//D3DisplayListCache , 创建对象后 -- outline
		public function afterCreateComp():void
		{
			putAttri_path();
		}
		
		//D3DisplayListCache -- project
		public function convertObject():void
		{
			createComp(false);
		}
		
		//create comp,create mesh
		public function convertObjectXML():void
		{
			createComp(false);
		}
		
		//创建对象的时候
		public function beForeCreateComp(f:Function):void
		{
			if(f!=null) f(this);
		}
		
		//D3AttriGroupViewBase
		public function selected():void
		{
			
		}
		
		//attri group delete
		public function deleteAttriGroup(d:D3GroupItemVO):void
		{
			comp.configData.removeGroup(d);
		}
		
		//属性里file里选择文件
		public function openViewGetFile(d:D3ComFile,f:Function):void
		{
			D3ViewManager.getInstance().openView_preList(d,comp,f);
		}
		
		//预览
		public function openPreview():void
		{
			
		}
		
		public function reflashMethod(k:String,v:D3ProccessMethod=null):void
		{
			//if(mapItem)mapItem.setAttri(k,v.medthodProccess.getMethod());
		}
		
		public function selectMethod(k:String):void
		{
			iManager.sendAppNotification(D3Event.select3DComp_event,comp.configData.getAttri(k));
		}
		
		public function getPreList(c:D3ComFile):Array
		{
			return [];
		}
		
		protected function deleteGroup(g:int):void
		{
			var d:D3GroupItemVO = D3ComponentProxy.getInstance().group_ls.getItem(g);
			if(d == null) return ;
			if(checkCurrentSelectedIsThis()){
				D3SceneManager.getInstance().displayList.selectedAttriView.findGroupCell(d).deleteGroup();
			}else{
				deleteAttriGroup(d);
			}
		}
		
		public function openSource():void
		{
			
		}

		protected function changeName(d:ID3ComBase,dd:D3ComBaseVO):String
		{
			var s:String = dd.data;
			
			if(!comp.checkIsInProject()){
				if(d.comp.node){
					d.comp.node.changeUID(d.comp.uid);
				}
				return s;
			}
			
			var s2:String = d.comp.name;
			if(!StringTWLUtil.isWhitespace(suffix)){
				if(s.indexOf(".")==-1){
					s += "."+suffix;
				}
				if(s2.indexOf(".")==-1){
					s2 += "."+suffix;
				}
			}
			if(s == s2) return s2;
			
			var pf:File = d.comp.file.parent;
			if(!d.comp.file.isDirectory){
				var c:D3ResData = D3ResChangeProxy.getInstance().getFile(d.comp.file.nativePath);
			}
			WriteFile.changeName(d.comp.file,s);
			d.comp.file = new File(pf.nativePath+File.separator+s);
			comp.name = s;
			if(!d.comp.file.isDirectory){
				D3ResChangeProxy.getInstance().changeContent(d.comp.file.nativePath,c.content);
			}
			return s;
		}
		
		protected function reflashLeftTree():void
		{
			if(comp.checkIsInProject()){
				get_D3ProjectPopViewMediator().reflashTree();
			}else{
				get_D3OutlinePopViewMediator().reflashTree()
			}
		}
		
		protected function putAttri_path():void
		{
			if(comp.checkIsInProject()){
				comp.configData.putAttri("path",D3ProjectFilesCache.getInstance().getProjectResPath(comp.file));
			}else{
				if(comp.node!=null){
					comp.node.reflashPath();
					comp.configData.putAttri("path",comp.node.path);
				}
			}
		}
		
		public function dispose():void
		{
			
		}
		
		public function setAttri(k:String,v:*):void
		{
			if(mapItem!=null) mapItem.setAttri(k,v);
			if(comp&&comp.configData){
				comp.configData.putAttri(k,v);
			}
		}
		
		protected function reflashPreview(d:ID3ComBase,v:D3ComBaseVO):void
		{
			if(mapItem!=null) mapItem.setAttri(d.key,v.data);
		}
		
		//D3ObjectBase,D3TreeNode都有name
		protected function saveAttri(d:ID3ComBase,v:D3ComBaseVO):void
		{
			if(d.item.value == "button") return ;
			
			comp.configData.putAttri(d.key,v.data);
			
			if(comp.checkIsInProject()){
				comp.configData.putAttri("path",D3ProjectFilesCache.getInstance().getProjectResPath(d.comp.file))
			}
			
			if(d.key == "visible" || d.key == "name"){
				if(comp.node!=null)comp.node.reflashSort();
				putAttri_path();
				reflashAttriNow();
				reflashLeftTree();
			}
			
			if(d.key == "rendering"){
				reflashLeftTree();
			}
			D3ProjectCache.dataChange = true;
		}
		
		protected function reflashAttriNow():void
		{
			if(D3SceneManager.getInstance().displayList.selectedAttriView){
				D3SceneManager.getInstance().displayList.selectedAttriView.reflashAttriNow(comp);
			}
		}
		
		protected function deleteObject():void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "删除对象，所有绑定对象将保留，确定要删除?"
			m.okFunction = confirm_del
			iManager.iPopupwin.showConfirm(m);
		}
		
		protected function confirm_del():Boolean
		{
			D3SceneManager.getInstance().displayList.removeObject(comp);
			iManager.sendAppNotification(D3Event.reflashOutline_in3D_event);
			iManager.sendAppNotification(D3Event.deleteD3Comp_event,comp);
			if(D3SceneManager.getInstance().displayList.selectedComp.uid == comp.uid){
				iManager.sendAppNotification(D3Event.select3DComp_event);
			}
			D3ProjectCache.dataChange = true;
			return true;
		}
		
		protected function checkCurrentSelectedIsThis():Boolean
		{
			return D3SceneManager.getInstance().displayList.selectedAttriView.comp.uid == comp.uid;
		}
		
		
		
		//////////////////////////////////////////////////////////
		
		private function get_D3OutlinePopViewMediator():D3OutlinePopViewMediator
		{
			return iManager.retrieveMediator(D3OutlinePopViewMediator.NAME) as D3OutlinePopViewMediator;
		}
		
		private function get_D3ProjectPopViewMediator():D3ProjectPopViewMediator
		{
			return iManager.retrieveMediator(D3ProjectPopViewMediator.NAME) as D3ProjectPopViewMediator;
		}
		
		protected function get_D3SourcePopViewMediator():D3SourcePopViewMediator
		{
			return iManager.retrieveMediator(D3SourcePopViewMediator.NAME) as D3SourcePopViewMediator;
		}
		
		protected function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
		protected function showConfirm(d:OpenMessageData):void
		{
			iManager.iPopupwin.showConfirm(d);
		}

		protected function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
	}
}
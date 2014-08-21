package com.editor.d3.object
{
	import away3d.animators.nodes.SkeletonClipNode;
	
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessAnim;
	import com.editor.d3.view.attri.cell.renderer.D3ComAnimItemRenderer;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class D3ObjectAnim extends D3ObjectBase
	{
		public function D3ObjectAnim(from:int)
		{
			super(from);
			proccess = new D3ProccessAnim(this);
			compItem = D3ComponentProxy.getInstance().com_ls.getItemByGroup1(group);
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group8;
		}
		
		public function readAnim():void
		{
			if(!D3ResChangeProxy.getInstance().checkFile(file)){
				D3ResChangeProxy.getInstance().addFile(file,"");
			}
			configData = D3ResChangeProxy.getInstance().getFile(file.nativePath,true);
			configData.comp = this;
			if(!StringTWLUtil.isWhitespace(name))configData.putAttri("name",name);
			configData.putAttri("path",D3ProjectFilesCache.getInstance().getProjectResPath(file))
			configData.readObject();
		}
		
		
		
		////////////////// outline ///////////////////////
		
		public var itemRenderer:D3ComAnimItemRenderer;
		
		public function readAnim2():void
		{
			readObject();
			configData.putAttri("path",parentObject.node.path+"."+name)
		}
		
		private var _isDefaultAnim:Boolean;
		public function get isDefaultAnim():Boolean
		{
			return _isDefaultAnim;
		}
		public function set isDefaultAnim(value:Boolean):void
		{
			_isDefaultAnim = value;
		}
		
		public function getAnimFile():File
		{
			return new File(D3ProjectFilesCache.getInstance().addProjectResPath(configData.getAttri("anim_file")));
		}
		
		public function playAnim():void
		{
			parentObject.proccess.mapItem.animation_create_complete_f = animation_create_complete_f;
			parentObject.proccess.mapItem.loadAnim(this);
		}
		
		private function animation_create_complete_f(n:SkeletonClipNode,m:D3EditorMapItem):void
		{
			parentObject.proccess.mapItem.playAnim(name);
		}
		
		public function get isDefault():Boolean
		{
			return configData.getAttri("isDefault")
		}
		
		public function stopAnim():void
		{
			parentObject.proccess.mapItem.stopAnim();
		}
		
		override public function dispose():void
		{
			D3Object(parentObject).removeAnim(this);
			super.dispose();
		}
		
	}
}
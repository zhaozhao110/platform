package com.editor.moudule_drama.vo.drama
{
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	import com.editor.moudule_drama.vo.drama.layout.IDrama_LayoutViewBaseVO;

	/**
	 * 加载布局对象数据
	 * @author sun
	 * 
	 */	
	public class Drama_LoadingLayoutResData
	{
		/**资源信息 VO (必须)**/
		public var loading_resInfoItemVO:AppResInfoItemVO;
		/**关键帧 VO (必须)**/
		public var loading_keyframeVO:ITimelineKeyframe_BaseVO;
		/**显示对象 VO**/
		public var loading_layoutViewVO:IDrama_LayoutViewBaseVO;
		/**属性 VO**/
		public var loading_propertyVO:ITimelineViewProperties_BaseVO;
		/**是否选中状态**/
		public var loading_selectedStatus:int;
		/**加载 url**/
		public var loading_url:String;
		/**加载类型**/
		public var loadingType:int;
		private var _fileType:int;
		/**加载文件类型**/
		public function get fileType():int
		{
			return _fileType;
		}
		public function set fileType(value:int):void
		{
			//trace("------",value)
			_fileType = value;
		}

		/**文件路径**/
		public var fileUrl:String;
		
		public function Drama_LoadingLayoutResData()
		{
			loading_url = "";
			fileUrl = "";
		}
		
	}
}
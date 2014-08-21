package com.editor.module_gdps.utils
{
    import com.editor.module_gdps.manager.GDPSDataManager;
    import com.editor.module_gdps.services.GDPSServices;
    import com.editor.module_gdps.services.GdpsHttpServiceLocator;
    import com.editor.module_gdps.vo.user.GDPSUserInfoVO;
    import com.sandy.error.SandyError;
    import com.sandy.fabrication.ISandyMediator;
    import com.sandy.logging.ILogger;
    import com.sandy.manager.SandyManagerBase;
    import com.sandy.popupwin.interfac.IManagerPopupwinManager;
    
    /**
     * 用于加载后台的缓存数据
     *
     * @author WuJian
     */
    public class CacheDataUtil extends SandyManagerBase
    {
        public function CacheDataUtil()
        {
        }

        /**
         * 返回当前登录用户id
         *
         */
        public static function getUserId():int
        {
            var ui:GDPSUserInfoVO = getUserInfo();
            if (ui != null && ui.uid > 0)
            {
                return ui.uid;
            }
            return -1;
        }

        /**
         * 返回当前登录用户信息
         *
         */
        public static function getUserInfo():GDPSUserInfoVO
        {
            return GDPSDataManager.getInstance().getUserInfo;
        }

        /**
         * 加载当前项目id
         *
         */
        public static function getProjectId():int
        {
            var ui:GDPSUserInfoVO = getUserInfo();
            if (ui != null && ui.getProjectId >= 0)
            {
                return ui.getProjectId;
            }
            return -1;
        }
		
		/**
		 * 加载当前项目类型[1-WEBGAME,2-MOBILEGAME]
		 *
		 */
		public static function getProjectType():String
		{
			var ui:GDPSUserInfoVO = getUserInfo();
			if (ui != null && ui.getProjectType != null)
			{
				return ui.getProjectType;
			}
			trace("getProjectType-请求后台获取当前系统项目类型!");
			return "0";
		}

        /**
         * 加载当前项目session id
         *
         */
        public static function getSessionId():String
        {
            var ui:GDPSUserInfoVO = getUserInfo();
            if (ui != null && ui.jsessionid != "")
            {
                return ui.jsessionid;
            }
            else
            {
                if (getProjectId() > 0) //当前项目id不为空时，必须存在session
                {
					SandyError.error("获取当前session失败!!!");
                }
                return null;
            }
        }

        /**
         * 加载数据字典类型
         *
         */
        public static function getDict(dtId:Object, successCallback:Function):void
        {
            var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
            http.args2 = { "projectId": getProjectId(), "dtId": dtId };
            http.sucResult_f = successCallback;
            http.conn(GDPSServices.getCacheDictData_url, "POST",GDPSDataManager.resultFor_obj_type);
        }
    }
}

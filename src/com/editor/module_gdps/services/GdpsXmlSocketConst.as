package com.editor.module_gdps.services
{

    /**
     * 记录gdps socket消息相关--ServerInterfaceConst
     * @link GdpsSandyEngineConfig.serverInterfaceClass
     */
    public class GdpsXmlSocketConst
    {

        //=========================================客户端socket类型===================================
        /**登陆类型-用于通知消息*/
        public static const client_type_login:String = "FLEX_LOGIN";

        /**检测类型-用于批次版本数据检测*/
        public static const client_type_detect:String = "FLEX_DETECT";

        /**打包类型-用于批次版本数据打包*/
        public static const client_type_packaging:String = "FLEX_PACKAGING";

        public static const client_type_config:String = "FLEX_CONFIG";
		
        public static const client_type_res:String = "FLEX_RES";

        public static const client_type_client:String = "FLEX_CLIENT";

        public static const client_type_server:String = "FLEX_SERVER";
		
		public static const client_type_adddetail:String = "FLEX_ADDDETAIL";

        //=========================================前台注册flash节点===================================
        /**注册flash节点消息心跳-保持session长连接*/
        public static const timer_msg:String = "S0000";

        /**注册flash节点消息*/
        public static const register_msg:String = "S0001";

        /**接受注册flash节点返回消息*/
        public static const received_msg:String = "S0002";

        //=========================================数据检测发布进度显示===================================
        /**数据检测，GDPS服务器主推实时进度消息*/
        public static const detect_msg:String = "F0001";

        /**数据打包，GDPS服务器主推实时进度消息*/
        public static const packaging_msg:String = "F0002";

        /**基础数据更新，GDPS服务器主推实时进度消息*/
        public static const publish_config_msg:String = "F0003";

        /**RES资源更新，GDPS服务器主推实时进度消息*/
        public static const publish_res_msg:String = "F0004";

        /**客户端代码更新，GDPS服务器主推实时进度消息*/
        public static const publish_client_msg:String = "F0005";

        /**服务端代码更新，GDPS服务器主推实时进度消息*/
        public static const publish_server_msg:String = "F0006";
		
		/**直接添加编辑数据至更新批次，GDPS服务器主推实时进度消息*/
		public static const publish_adddetail_msg:String = "F0007";
    }
}

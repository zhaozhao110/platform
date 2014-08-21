package com.editor.module_gdps.vo
{
	import com.sandy.net.XmlSocketData;
	
	/**
	 * gdps xmlsocket 
	 * 消息定义格式<br/>
	 * 发送消息给服务器时:消息头|回执码|当前用户sessionId或者loginCode|clientType(flash客户端类型)|消息内容
	 * eg:S10001(消息头)|S10002(回执消息类型)|jsessionid/admin(当前用户sessionid或者系统登录key)|PACKAGING(打包类型)|消息内容
	 * 接收服务器推送消息:
	 * eg:S10001(消息头)|0(回执码0-成功)|jsessionid(当前用户sessionid)|PACKAGING(打包类型)|20%(消息内容)
	 */
	public class GDPSXmlSocketData extends XmlSocketData
	{
		public function GDPSXmlSocketData()
		{
			super();
		}
	}
}
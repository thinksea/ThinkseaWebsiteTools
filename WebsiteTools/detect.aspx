<%@ Page Language="C#" %>
<%@ Implements Interface="System.Web.UI.ICallbackEventHandler" %>
<%@ Assembly Src="Define.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    protected string CPUTest()
    {
        int m, b;
        m = b = 100;
        double v;
        System.DateTime begin;
        System.DateTime end;
        double timespan;
        re:
        {
            begin = System.DateTime.Now;
            for (double i = 0; i < m * 10000; i++)
            {
                v = (((i + 1) * 2) - 3) / 10;
            }
            end = System.DateTime.Now;
            timespan = (end - begin).TotalMilliseconds;
        }
        if (timespan < 100)
        {
            m *= 10;
            goto re;
        }

        string sSpeed = "未知";
        if (timespan < 0.05 * m)
        {
            sSpeed = "<span style='padding: 5px; background-color: green; color: white;'>极快</span>";
        }
        else if (timespan < 0.15 * m)
        {
            sSpeed = "<span style='padding: 5px; background-color: lawngreen;'>较快</span>";
        }
        else if (timespan < 0.2 * m)
        {
            sSpeed = "<span style='padding: 5px; background-color: lightskyblue;'>普通</span>";
        }
        else if (timespan < 0.3 * m)
        {
            sSpeed = "<span style='padding: 5px; background-color: orange;'>较慢</span>";
        }
        else
        {
            sSpeed = "<span style='padding: 5px; background-color: red; color: yellow;'>极慢</span>";
        }
        return string.Format("{0} 万次浮点混合运算：{1:.0} 毫秒。评价：{2}", m, timespan, sSpeed);
    }

    private string CallbackResult = "";
    public string GetCallbackResult()
    {
        return this.CallbackResult;

    }

    public void RaiseCallbackEvent(string eventArgument)
    {
        if (eventArgument.Length == 0)
        {
            return;
        }

        switch (eventArgument)
        {
            case "NetTest":
                this.CallbackResult = "";
                for (int i = 0; i < 100; i++)
                {
                    this.CallbackResult += "<!--000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|000000000|0000000-->"; // 1 KB 大小的数据块。
                }
                break;
        }

    }

    /// <summary>
    /// 根据参数的值返回同意义的图形替换标记。
    /// </summary>
    /// <param name="b"></param>
    /// <returns></returns>
    public string ConvertBooleanToString(bool b)
    {
        if (b)
            return "<span style='color:green; font-weight: bold;'>√</span>";
        else
            return "<span style='color:red; font-weight: bold;'>×</span>";
    }

    /// <summary>
    /// 检查是否支持指定的组件。
    /// </summary>
    /// <param name="obj"></param>
    /// <returns></returns>
    public string checkObject(string obj)
    {
        try
        {
            object o = Server.CreateObject(obj);
            return ConvertBooleanToString(true);
        }
        catch
        {
            return ConvertBooleanToString(false);
        }
    }

    protected void btnCheckObject_Click(object sender, EventArgs e)
    {
        this.lCheckObjectResult.Text = "";
        this.tbCheckObject.Text = this.tbCheckObject.Text.Trim();
        if (this.tbCheckObject.Text.Length == 0)
        {
            return;
        }

        try
        {
            object o = Server.CreateObject(this.tbCheckObject.Text);
            this.lCheckObjectResult.Text = string.Format("服务器支持指定的组件“{0}”", this.tbCheckObject.Text);
            this.lCheckObjectResult.ForeColor = System.Drawing.Color.Green;
        }
        catch
        {
            this.lCheckObjectResult.Text = string.Format("服务器不支持指定的组件“{0}”", this.tbCheckObject.Text);
            this.lCheckObjectResult.ForeColor = System.Drawing.Color.Red;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!this.IsPostBack && !this.IsCallback)
        {
            Thinksea.WebsiteTools.Define.CheckLogin();

        }

    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head runat="server">
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>检测系统环境配置</title>
		<meta http-equiv="expires" content="0" />
		<link href="css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
*
{
    FONT-FAMILY: 宋体;
    FONT-SIZE: 12px;
}
.FieldCaption
{
    white-space: nowrap;
    text-align: center;
    font-size: 14px;
	height: 25px;
	background-color: #C1DBFC;
}
.gridView
{
}
.gridView thead th
{
    white-space: nowrap;
    text-align: center;
}
.gridView tbody td
{
    white-space: nowrap;
    text-align: center;
}
.gridView tfoot th
{
    text-align: left;
}
    .style1
    {
        height: 25px;
    }
</style>
		<script language="javascript" type="text/javascript">
<!--
var NetTestBeginTime;
var NetTestEndTime;
function Callback(o, command)
{
    eval("var e='" + o + "';");
    switch( command )
    {
        case "NetTest":
            NetTestEndTime = new Date();
            var TotalKB = e.length / 1024;
            var AverageSpeed = TotalKB / ((NetTestEndTime - NetTestBeginTime) / 1000);
            if(AverageSpeed <= 7) //56 K猫
            {
                document.getElementById('progressValue').style.width = 100 * AverageSpeed / 7 + "px";
            }
            else if(AverageSpeed <= 256) //2 M
            {
                document.getElementById('progressValue').style.width = 100 + 200 * AverageSpeed / 256 + "px";
            }
            else if(AverageSpeed <= 12800) //10 M+
            {
                document.getElementById('progressValue').style.width = 300 + 200 * AverageSpeed / 12800 + "px";
            }
            document.getElementById('progressText').innerHTML = "总共传送 " + TotalKB + " KB，平均 " + AverageSpeed.toPrecision(2) * 1.0 + " KB/秒(" + AverageSpeed.toPrecision(2) * 8 + "kb/秒)";
            break;
    }
}

//当执行功能操作时出现异常时执行此方法。
function CallbackError(e,command)
{
    alert(e);
    //HidProgressBar();
    //MessageBox(e.replace(/(56|64|72)\|[^|]*$/ig, ""), null, "OK", "Error", null, null, null, null);
}

//测试网络带宽。
function NetTest()
{
    NetTestEndTime = NetTestBeginTime = new Date();
    <%=this.ClientScript.GetCallbackEventReference(this, "'NetTest'", "Callback", "'NetTest'", "CallbackError", true )%> //带宽测试
}

function OnPageLoad()
{
    if(window.parent != null && window.parent.HiddenProgressBar) window.parent.HiddenProgressBar();
    NetTest();
}
//-->
		</script>
	</head>
	<body onload="OnPageLoad();">
		<form id="form1" runat="server">
			<table style="width: 600px; margin: 0px auto; border: solid 1px #6687BA;" border="0">
				<tr>
					<td class="FieldCaption">服 务 器 的 配 置</td>
				</tr>
				<tr>
					<td>
						<table cellspacing="0" cellpadding="5" border="0" style="width: 100%">
							<tr style="background-color: #ffffff">
								<td>服务器计算机名称</td>
								<td><%=Server.MachineName%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>服务器 IP 地址</td>
								<td><%=Request.ServerVariables["LOCAL_ADDR"]%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>服务器的主机名，DNS别名，或IP地址</td>
								<td><%=Request.ServerVariables["SERVER_NAME"]%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>服务器处理请求的端口</td>
								<td><%=Request.ServerVariables["SERVER_PORT"]%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>处理器数量</td>
								<td><%=System.Environment.ProcessorCount%> 颗</td>
							</tr>
							<tr style="background-color: #efefef">
								<td>映射到进程上下文的物理内存量</td>
								<td><%=(System.Diagnostics.Process.GetCurrentProcess().WorkingSet64 / 1024).ToString("N0")%> KB</td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>为关联的进程分配的分页内存量</td>
								<td><%=(System.Diagnostics.Process.GetCurrentProcess().PagedMemorySize64 / 1024).ToString("N0")%> KB</td>
							</tr>
							<tr style="background-color: #efefef">
								<td>系统最后启动时间</td>
								<td><%=System.DateTime.Now - System.TimeSpan.FromMilliseconds(System.Environment.TickCount)%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>系统持续工作时间</td>
								<td><%
TimeSpan ts = System.TimeSpan.FromMilliseconds(System.Environment.TickCount);
this.Response.Write(string.Format("{0} 天 {1} 小时 {2} 分钟", ts.Days, ts.Hours, ts.Minutes));
%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>服务器操作系统</td>
								<td><%=System.Environment.OSVersion%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>IIS版本</td>
								<td><%=Request.ServerVariables["SERVER_SOFTWARE"]%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>.NET 公共语言运行库的版本号</td>
								<td><%=System.Environment.Version%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>协议的名称和版本</td>
								<td><%=Request.ServerVariables["SERVER_PROTOCOL"]%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>服务器系统时间</td>
								<td><%=System.DateTime.Now%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>网站根目录物理路径</td>
								<td><%=System.Web.HttpContext.Current.Server.MapPath("/")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>ASP.NET 虚拟应用程序目录的物理路径</td>
								<td><%=System.Web.HttpRuntime.AppDomainAppPath%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>当前 ASP.NET 应用程序的 /bin 目录的物理路径</td>
								<td><%=System.Web.HttpRuntime.BinDirectory%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>ASP.NET 客户端脚本文件的虚拟路径</td>
								<td><%=System.Web.HttpRuntime.AspClientScriptVirtualPath%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>脚本超时时间</td>
								<td><%=Server.ScriptTimeout%>
									秒</td>
							</tr>
							<tr style="background-color: #efefef">
								<td class="style1">检取 ISAPIDLL 的 metabase 路径</td>
								<td class="style1"><%=Request.ServerVariables["APPL_MD_PATH"]%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>路径信息</td>
								<td><%=Request.ServerVariables["PATH_INFO"]%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>显示执行SCRIPT的虚拟路径</td>
								<td><%=Request.ServerVariables["SCRIPT_NAME"]%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>当前 Session 编号</td>
								<td><%=Session.SessionID%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>应用程序 Session 数量</td>
								<td><%=Session.Count%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>应用程序 Application 数量</td>
								<td><%=Application.Count%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td><table border="0" cellpadding="3" cellspacing="3">
								        <tr><td>CPU 运算能力测试</td></tr>
								        <tr><td>
参考色：
<span style='white-space: nowrap; padding: 5px; background-color: red; color: yellow;'>极慢</span>
<span style='white-space: nowrap; padding: 5px; background-color: orange;'>较慢</span>
<span style='white-space: nowrap; padding: 5px; background-color: lightskyblue;'>普通</span>
<span style='white-space: nowrap; padding: 5px; background-color: lawngreen;'>较快</span>
<span style='white-space: nowrap; padding: 5px; background-color: green; color: white;'>极快</span>
								        </td></tr>
                                    </table>
								</td>
								<td>
                                    <%=this.CPUTest()%>
                                </td>
							</tr>
							<tr style="background-color: #ffffff">
								<td colspan="2">
    							    当前 ASP.NET 用户的信息
								<table cellpadding="5" cellspacing="0" border="0" style="margin-left: 100px">
								    <tr><td>用户的 Windows 登录名</td><td><%=this.Request.LogonUserIdentity.Name%></td></tr>
								    <tr><td>是否匿名帐户</td><td><%=ConvertBooleanToString(this.Request.LogonUserIdentity.IsAnonymous)%></td></tr>
								    <tr><td>是否来宾帐户</td><td><%=ConvertBooleanToString(this.Request.LogonUserIdentity.IsGuest)%></td></tr>
								    <tr><td>是否系统帐户</td><td><%=ConvertBooleanToString(this.Request.LogonUserIdentity.IsSystem)%></td></tr>
								</table></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="FieldCaption">连 接 带 宽 测 试</td>
				</tr>
				<tr>
					<td style="background-color: #ffffff">
<div style="padding:10px 0px; text-align: center;">
      <table style="width: 500px;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="width: 100px; background-color: Red;"> 56k猫</td><td style="width: 200px; background-color: yellow;"> 2M ADSL</td><td style="width: 200px; background-color: lawngreen"> 10M LAN 或更高带宽</td>
        </tr>
      </table>
    <div id="progressBar" style="position: relative; border: solid 1px #111111;BACKGROUND-color: #F8FFF0; width: 500px; height: 20px; text-align: center;">
        <div id="progressValue" style="position: absolute; z-index: -1; left: 1px; top: 1px; height: 18px; width: 1px; background-color: lawngreen;"></div><div id="progressText" style="color: Black; padding-top: 3px;">? KB/s</div>
    </div>
</div>
					</td>
				</tr>
				<tr>
					<td class="FieldCaption">服 务 器 磁 盘 信 息</td>
				</tr>
				<tr>
					<td style="background-color: #ffffff">
<table class="gridView" cellspacing="0" cellpadding="5" border="0" style="width: 100%">
    <thead><tr><th>盘符和磁盘类型</th><th>就绪</th><th>卷标</th><th>文件系统</th><th>总空间</th><th>可用空间</th></tr></thead>
    <tbody>
<%
System.IO.DriveInfo [] dis = System.IO.DriveInfo.GetDrives();
for (int i = 0; i < dis.Length; i++)
{
    System.IO.DriveInfo tmp = dis[i];
%>
    <tr style="<%=i%2==0? "background-color: #efefef": ""%>">
        <td style="text-align: right;">
<%if (tmp.IsReady)
  {
      switch (tmp.DriveType)
      {
          case System.IO.DriveType.CDRom:
              this.Response.Write("光盘设备");
              break;
          case System.IO.DriveType.Fixed:
              this.Response.Write("固定磁盘");
              break;
          case System.IO.DriveType.Network:
              this.Response.Write("网络驱动器");
              break;
          case System.IO.DriveType.NoRootDirectory:
              this.Response.Write("驱动器没有根目录");
              break;
          case System.IO.DriveType.Ram:
              this.Response.Write("RAM 磁盘");
              break;
          case System.IO.DriveType.Removable:
              this.Response.Write("移动存储设备");
              break;
          case System.IO.DriveType.Unknown:
              this.Response.Write("未知");
              break;
      }
  }
  this.Response.Write("&nbsp;" + tmp.Name);
%>
        </td>
<%
    if (tmp.Name == @"A:\") //跳过 A 盘检测
    {
%>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td style="text-align: right;">&nbsp;</td>
        <td style="text-align: right;">&nbsp;</td>
<%
    }
    else
    {
        if (tmp.IsReady)
        {
            try
            {
                this.Response.Write(string.Format(@"<td>{4}</td>
    <td>{0}</td>
    <td>{1}</td>
    <td style='text-align: right;'>{2}</td>
    <td style='text-align: right;'>{3}</td>
    ", (!string.IsNullOrEmpty(tmp.VolumeLabel) ? tmp.VolumeLabel : "&nbsp;")
                , tmp.DriveFormat
                , Thinksea.WebsiteTools.Define.ConvertToFileSize(tmp.TotalSize)
                , Thinksea.WebsiteTools.Define.ConvertToFileSize(tmp.TotalFreeSpace)
                , ConvertBooleanToString(true)
                ));
            }
            catch
            {
                this.Response.Write(string.Format(@"
<td>{0}</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td style='text-align: right;'>&nbsp;</td>
<td style='text-align: right;'>&nbsp;</td>"
                    , ConvertBooleanToString(false)
                    ));
            }
        }
        else
        {
            this.Response.Write(string.Format(@"
<td>{0}</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td style='text-align: right;'>&nbsp;</td>
<td style='text-align: right;'>&nbsp;</td>"
                , ConvertBooleanToString(false)
                ));
    }
%>
    </tr>
<%
    }
}
%>
    </tbody>
    <tfoot><tr><th colspan="6">“<%=ConvertBooleanToString(false)%>”表示磁盘没有就绪或者当前IIS站点没有对该磁盘的操作权限。</th></tr></tfoot>
</table>
					</td>
				</tr>
				<tr>
					<td class="FieldCaption">常 见 组 件 支 持</td>
				</tr>
				<tr>
					<td>
						<table cellspacing="0" cellpadding="5" border="0" style="width: 100%">
							<tr style="background-color: #ffffff">
								<td>ADODB.RecordSet <span style="color: Gray;">(Access 数据库)</span></td>
								<td><%=checkObject("ADODB.RecordSet")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>MSWC.AdRotator</td>
								<td><%=checkObject("MSWC.AdRotator")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>MSWC.BrowserType</td>
								<td><%=checkObject("MSWC.BrowserType")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>MSWC.NextLink</td>
								<td><%=checkObject("MSWC.NextLink")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>MSWC.Tools</td>
								<td><%=checkObject("MSWC.Tools")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>MSWC.Status</td>
								<td><%=checkObject("MSWC.Status")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>MSWC.Counters</td>
								<td><%=checkObject("MSWC.Counters")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>IISSample.ContentRotator</td>
								<td><%=checkObject("IISSample.ContentRotator")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>IISSample.PageCounter</td>
								<td><%=checkObject("IISSample.PageCounter")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>MSWC.PermissionChecker</td>
								<td><%=checkObject("MSWC.PermissionChecker")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>Microsoft.XMLHTTP <span style="color: Gray;">(Http 组件, 常在采集系统中用到)</span></td>
								<td><%=checkObject("Microsoft.XMLHTTP")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>WScript.Shell <span style="color: Gray;">(Shell 组件, 可能涉及安全问题)</span></td>
								<td><%=checkObject("WScript.Shell")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>Scripting.FileSystemObject <span style="color: Gray;">(FSO 文件系统管理、文件读写)</span></td>
								<td><%=checkObject("Scripting.FileSystemObject")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>ADODB.Connection <span style="color: Gray;">(ADO 数据对象)</span></td>
								<td><%=checkObject("ADODB.Connection")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>Adodb.Stream <span style="color: Gray;">(ADO 数据流对象, 常见被用在无组件上传程序中)</span></td>
								<td><%=checkObject("Adodb.Stream")%></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="FieldCaption">邮 件 组 件 支 持</td>
				</tr>
				<tr>
					<td>
						<table cellspacing="0" cellpadding="5" border="0" style="width: 100%">
							<tr style="background-color: #ffffff">
								<td>CDONTS.NewMail <span style="color: Gray;">(CDONTS邮件发送)</span></td>
								<td><%=checkObject("CDONTS.NewMail")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>JMail.SmtpMail <span style="color: Gray;">(Dimac JMail 邮件收发)</span></td>
								<td><%=checkObject("JMail.SmtpMail")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>CDO.Message <span style="color: Gray;">(CDOSYS)</span></td>
								<td><%=checkObject("CDO.Message")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>Persits.MailSender <span style="color: Gray;">(ASPemail发信)</span></td>
								<td><%=checkObject("Persits.MailSender")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>SMTPsvg.Mailer <span style="color: Gray;">(ASPmail 发信)</span></td>
								<td><%=checkObject("SMTPsvg.Mailer")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>DkQmail.Qmail <span style="color: Gray;">(dkQmail 发信)</span></td>
								<td><%=checkObject("DkQmail.Qmail")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>Geocel.Mailer <span style="color: Gray;">(Geocel发信)</span></td>
								<td><%=checkObject("Geocel.Mailer")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>SmtpMail.SmtpMail.1 <span style="color: Gray;">(SmtpMail发信)</span></td>
								<td><%=checkObject("SmtpMail.SmtpMail.1")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>Persits.Upload.1 <span style="color: Gray;">(ASPUpload文件上传)</span></td>
								<td><%=checkObject("Persits.Upload.1")%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>aspcn.Upload <span style="color: Gray;">(ASPCN文件上传)</span></td>
								<td><%=checkObject("aspcn.Upload")%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>自定义组件查询：<span style="color: Gray;">(请输入你要检测的组件的ProgId或ClassId)</span></td>
								<td>&nbsp;</td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>
                                    <asp:TextBox ID="tbCheckObject" runat="server"></asp:TextBox><asp:Button ID="btnCheckObject" runat="server" Text="检查" 
                                        OnClick="btnCheckObject_Click" UseSubmitBehavior="False" />
                                    <asp:Label ID="lCheckObjectResult" runat="server"></asp:Label>
                                </td>
								<td>&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="FieldCaption">客 户 端 的 系 统 配 置</td>
				</tr>
				<tr>
					<td>
						<table cellspacing="0" cellpadding="5" border="0" style="width: 100%">
							<tr style="background-color: #ffffff">
								<td>DNS 名称</td>
								<td><%=Request.UserHostName%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>IP 地址</td>
								<td><%=Request.UserHostAddress%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>客户端平台名称(PlatForm)</td>
								<td><%=Request.Browser.Platform%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>客户端是否为基于 Win16 的计算机</td>
								<td><%=ConvertBooleanToString(Request.Browser.Win16)%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>客户端是否为基于 Win32 的计算机</td>
								<td><%=ConvertBooleanToString(Request.Browser.Win32)%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>.NET 公共语言运行库的版本号</td>
								<td><%
System.Version [] clrvers = Request.Browser.GetClrVersions();
for( int i = clrvers.Length - 1; i >= 0; i-- )
{
	Response.Write( clrvers[i].ToString() + "<br />" );
}
%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>最后访问地址</td>
								<td><%=Request.UrlReferrer%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>语言支持</td>
								<td><%=Request.ServerVariables["HTTP_ACCEPT_LANGUAGE"]%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>图片支持</td>
								<td><%=Request.ServerVariables["HTTP_ACCEPT"]%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>Cookies</td>
								<td style="word-break: break-all;"><%=Request.ServerVariables["HTTP_COOKIE"]%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>HTTP_ACCEPT_ENCODING</td>
								<td><%=Request.ServerVariables["HTTP_ACCEPT_ENCODING"]%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>HTTP_CONNECTION</td>
								<td><%=Request.ServerVariables["HTTP_CONNECTION"]%></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="FieldCaption">客 户 端 的 浏 览 器 配 置</td>
				</tr>
				<tr>
					<td>
						<table cellspacing="0" cellpadding="5" border="0" style="width: 100%">
							<tr style="background-color: #ffffff">
								<td>浏览器(Browser)</td>
								<td><%=Request.Browser.Browser%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>浏览器版本(Version)</td>
								<td><%=Request.Browser.Version%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>浏览器是否测试版</td>
								<td><%=ConvertBooleanToString(Request.Browser.Beta)%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>是否支持 Cookies</td>
								<td><%=ConvertBooleanToString(Request.Browser.Cookies)%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>是否支持 Java 小程序（JavaApplets）</td>
								<td><%=ConvertBooleanToString(Request.Browser.JavaApplets)%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>是否支持 VBScript</td>
								<td><%=ConvertBooleanToString(Request.Browser.VBScript)%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>是否支持 JavaScript</td>
								<td><%=ConvertBooleanToString(Request.Browser.JavaScript)%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>是否支持背景声音</td>
								<td><%=ConvertBooleanToString(Request.Browser.BackgroundSounds)%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>是否支持 ActiveX 控件</td>
								<td><%=ConvertBooleanToString(Request.Browser.ActiveXControls)%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>是否支持 HTML 框架</td>
								<td><%=ConvertBooleanToString(Request.Browser.Frames)%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>是否是“美国在线”（AOL）浏览器</td>
								<td><%=ConvertBooleanToString(Request.Browser.AOL)%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>是否支持 Web 广播的频道定义格式（CDF）</td>
								<td><%=ConvertBooleanToString(Request.Browser.CDF)%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>是否支持 HTML 表</td>
								<td><%=ConvertBooleanToString(Request.Browser.Tables)%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>是否 Web 爬行遍历搜索引擎</td>
								<td><%=ConvertBooleanToString(Request.Browser.Crawler)%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>支持的 ECMA 脚本的版本号</td>
								<td><%=Request.Browser.EcmaScriptVersion.ToString()%></td>
							</tr>
							<tr style="background-color: #efefef">
								<td>支持的万维网联合会（W3C）XML文档对象模型（DOM）的版本</td>
								<td><%=Request.Browser.W3CDomVersion.ToString()%></td>
							</tr>
							<tr style="background-color: #ffffff">
								<td>支持的 Microsoft HTML（MSHTML）文档对象模型（DOM）的版本</td>
								<td><%=Request.Browser.MSDomVersion.ToString()%></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>

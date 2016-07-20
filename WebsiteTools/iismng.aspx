<%@ Page language="c#" Inherits="Thinksea.WebsiteTools.iismng" CodeFile="iismng.aspx.cs" %>
<%@ Assembly Src="Define.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD html 4.0 Transitional//EN" >
<html>
	<head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>IIS 管理</title>
	    <meta http-equiv="expires" content="0" />
        <link href="css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
function OnLoad()
{
    var editPassword = document.getElementById("editUserName");
    editPassword.select();
    editPassword.focus();
}
</script>
	    <style type="text/css">
            .style1
            {
            }
        </style>
	</head>
	<body onload="OnLoad();" style="margin: 10px;">
		<form id="Form1" method="post" runat="server" autocomplete="off">
			<table id="Table1" cellspacing="1" cellpadding="1" border="0">
				<tr>
					<td colspan="2" style="color: Gray;" style="padding-bottom:10px;">* 对 IIS 操作需要有效的 Windows 用户名和密码。</td>
				</tr>
				<tr>
					<td nowrap>用户名：</td>
					<td class="style1"><asp:TextBox id="editUserName" runat="server" Width="150px"></asp:TextBox>
						<asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" 
                            ControlToValidate="editUserName" ErrorMessage="*" 
                            SetFocusOnError="True"></asp:RequiredFieldValidator></td>
				</tr>
				<tr>
					<td nowrap>密码：</td>
					<td class="style1">
						<asp:TextBox id="editNewPassword" runat="server" Width="150px"></asp:TextBox>
						<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="editNewPassword" ErrorMessage="*" 
                            SetFocusOnError="True"></asp:RequiredFieldValidator></td>
				</tr>
				<tr>
					<td nowrap style="width:1%;" style="padding-top:10px;">当前 IIS 状态：</td>
					<td class="style1" style="padding-top:10px;">
                        <asp:Label ID="lblIISState" runat="server" Text="状态未知"></asp:Label>
                    </td>
				</tr>
				<tr>
					<td colspan="2"><asp:Label id="lblPrompt" runat="server" ForeColor="Red"></asp:Label></td>
				</tr>
				<tr>
					<td align="center" colspan="2" style="padding-top:10px;">
						<asp:Button id="btnRestartIIS" runat="server" Text="重启 IIS" onclick="btnRestartIIS_Click" UseSubmitBehavior="false" OnClientClick="if(!window.confirm('确认重新启动 IIS 吗？')){return false;}"></asp:Button>
						<asp:Button id="btnStartIIS" runat="server" Text="启动 IIS" onclick="btnStartIIS_Click" UseSubmitBehavior="false" OnClientClick="if(!window.confirm('确认启动 IIS 吗？')){return false;}"></asp:Button>
						<asp:Button id="btnStopIIS" runat="server" Text="停止 IIS" onclick="btnStopIIS_Click" UseSubmitBehavior="false" OnClientClick="if(!window.confirm('确认停止 IIS 吗？')){return false;}"></asp:Button>
                    </td>
				</tr>
				<tr>
					<td align="center" colspan="2">
						<asp:Button id="btnRefreshIISState" runat="server" Text="重新获取 IIS 状态" UseSubmitBehavior="false" onclick="btnRefreshIISState_Click"></asp:Button>
						<input id="btnCancel" type="button" value=" 关闭 " onclick="window.frameElement.Close(); return false;" />
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>

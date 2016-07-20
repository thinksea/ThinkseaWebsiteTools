<%@ Page language="c#" Inherits="Thinksea.WebsiteTools.pwd" CodeFile="pwd.aspx.cs" %>
<%@ Assembly Src="Define.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD html 4.0 Transitional//EN" >
<html>
	<head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>更改登陆密码</title>
	    <meta http-equiv="expires" content="0" />
        <link href="css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
function OnLoad()
{
    var editPassword = document.getElementById("editPassword");
    editPassword.select();
    editPassword.focus();
}

</script>
	</head>
	<body onload="OnLoad();" style="margin: 10px;">
		<form id="Form1" method="post" runat="server">
			<table id="Table1" cellspacing="1" cellpadding="1" border="0" style="width: 200px;">
				<tr>
					<td nowrap>原密码：</td>
					<td>
						<asp:TextBox id="editPassword" runat="server" TextMode="Password"></asp:TextBox></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td nowrap>新密码：</td>
					<td>
						<asp:TextBox id="editNewPassword" runat="server" TextMode="Password"></asp:TextBox></td>
					<td nowrap>
						<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="editNewPassword" ErrorMessage="*" 
                            SetFocusOnError="True"></asp:RequiredFieldValidator></td>
				</tr>
				<tr>
					<td nowrap>新密码验证：</td>
					<td>
						<asp:TextBox id="editNewPasswordAgain" runat="server" TextMode="Password"></asp:TextBox></td>
					<td nowrap>
						<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" 
                            ControlToValidate="editNewPasswordAgain" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
						</td>
				</tr>
				<tr>
					<td colspan="3">
						<asp:CompareValidator id="CompareValidator1" runat="server" 
                            ErrorMessage="两次输入的新密码不同&lt;br /&gt;" ControlToValidate="editNewPasswordAgain"
							ControlToCompare="editNewPassword" Display="Dynamic" SetFocusOnError="True"></asp:CompareValidator>
							<asp:Label id="lblPrompt" runat="server" ForeColor="Red"></asp:Label></td>
				</tr>
				<tr>
					<td align="center" colspan="3">
						<asp:Button id="btnAccept" runat="server" Text="保存修改" onclick="btnAccept_Click"></asp:Button>&nbsp;<input type="button" value=" 取消 " onclick="window.frameElement.Close(); return false;" /></td>
				</tr>
			</table>
		</form>
	</body>
</html>

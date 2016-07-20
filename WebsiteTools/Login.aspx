<%@ Page language="c#" Inherits="Thinksea.WebsiteTools.Login" CodeFile="Login.aspx.cs" %>
<%@ Assembly Src="Define.cs" %>
<%@ Assembly Src="Thinksea.WebsiteTools.VerifyCode.cs" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>登陆</title>
	    <meta http-equiv="expires" content="0" />
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server" defaultbutton="btnAccept" defaultfocus="editPassword" submitdisabledcontrols="true">
			<TABLE id="Table1" style="BORDER-RIGHT: #ccccff 1px solid; BORDER-TOP: #ccccff 1px solid; BORDER-LEFT: #ccccff 1px solid; BORDER-BOTTOM: #ccccff 1px solid"
				cellspacing="1" cellpadding="1" width="300" align="center" border="0">
				<TR bgcolor="#ccccff">
					<TD nowrap colspan="4"><strong>Thinksea website tools</strong></TD>
				</TR>
				<TR>
					<TD nowrap colspan="4" height="20"></TD>
				</TR>
				<TR>
					<TD nowrap width="20"></TD>
					<TD nowrap width="1%">密码：</TD>
					<TD nowrap style="WIDTH: 161px"><asp:textbox id="editPassword" runat="server" Width="100%" TextMode="Password" MaxLength="50"></asp:textbox></TD>
					<TD nowrap width="20"></TD>
				</TR>
				<TR>
					<TD nowrap width="20">&nbsp;</TD>
					<TD nowrap width="1%">验证码：</TD>
					<TD nowrap style="WIDTH: 161px"><table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                        <asp:TextBox ID="editVerifyCode" runat="server" MaxLength="6" Width="78px"></asp:TextBox>
                                </td>
                                <td>
                        <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder></td>
                            </tr>
                        </table>
                    </TD>
					<TD nowrap width="20"></TD>
				</TR>
				<TR>
					<TD nowrap align="center" colspan="4" height="20"><asp:label id="lblPrompt" runat="server" ForeColor="Red"></asp:label></TD>
				</TR>
				<TR>
					<TD nowrap align="center" colspan="4"><asp:button id="btnAccept" runat="server" Text=" 登 陆 " onclick="btnAccept_Click"></asp:button><input id="btnClose" type="button" value=" 关闭 " onclick="window.opener=null;window.open('','_self');window.close();return false;" /></TD>
				</TR>
				<TR>
					<TD nowrap align="center" colspan="4" height="20"></TD>
				</TR>
			</TABLE>
		</form>
	</body>
</HTML>

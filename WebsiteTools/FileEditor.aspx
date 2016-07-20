<%@ Page Language="C#" Inherits="Thinksea.WebsiteTools.FileEditor" CodeFile="FileEditor.aspx.cs" ValidateRequest="false" %>
<%@ Assembly Src="Define.cs" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>文本文件编辑器</title>
	<meta http-equiv="expires" content="0" />
    <link href="css/css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .lab
    {
        white-space: nowrap;
    }
    </style>
    <script language="javascript" type="text/javascript" src="aspnet_client/MessageBox/MessageBox.js"></script>
    <script language="javascript" type="text/javascript">
        function reloadFile()
        {
            document.getElementById("tbContent").value = "";
            return true;
        }

        //处理窗体尺寸更改事件。
        function onwindowresize() {
            document.getElementById("tbContent").style.width = (clientWidth()) + "px";
        }

        function onload()
        {
            onwindowresize();
            AddWindowOnResize(onwindowresize);
        }
    </script>
</head>
<body style="overflow: auto;" onload="onload();">
    <form id="form1" runat="server">
        <table id="Table1" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td style="border-bottom: solid 1px gray;" class="lab">存盘文件名：<asp:TextBox ID="tbFileName" runat="server" Width="40%"></asp:TextBox>
                    <br />
                    文件打开编码：<asp:DropDownList ID="ddlEncoderLoad" runat="server">
                        <asp:ListItem Value="utf-8">Unicode (UTF-8 带签名) -代码页 65001</asp:ListItem>
                        <asp:ListItem Value="gb2312">简体中文(GB3212)- 代码页 936</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnRefreshFromServer" runat="server" 
                        onclick="btnRefreshFromServer_Click" Text="加载文件从服务器" 
                        CausesValidation="False" UseSubmitBehavior="False" OnClientClick="if(!reloadFile()) return;" />
                    <br />
                    <asp:CheckBox ID="cbSetSaveCode" runat="server" Text="设置存盘文件使用的编码格式：" 
                        AutoPostBack="True" oncheckedchanged="cbSetSaveCode_CheckedChanged" />
                    <asp:DropDownList ID="ddlEncoderSave" runat="server" Enabled="False">
                        <asp:ListItem Value="utf-8">Unicode (UTF-8 带签名) -代码页 65001</asp:ListItem>
                        <asp:ListItem Value="gb2312">简体中文(GB3212)- 代码页 936</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="ddlEncoderSave" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <br />
                    <asp:CheckBox ID="cbBackupFile" runat="server" Text="当覆盖文件时先备份原文件" 
                        Checked="True" />
                    <br />
                    <asp:Button ID="btnSave" runat="server" onclick="btnSave_Click" Text="保存文件到服务器" 
                        UseSubmitBehavior="False" />
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top; height: 100%;">
                    <asp:TextBox ID="tbContent" runat="server" TextMode="MultiLine" Height="100%" Wrap="false" Width="100%"></asp:TextBox>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

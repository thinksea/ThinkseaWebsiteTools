<%@ Page language="c#" Inherits="Thinksea.WebsiteTools.UnZIP" CodeFile="UnZIP.aspx.cs" %>
<%@ Assembly Src="Define.cs" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
	<head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>解压缩文件</title>
        <link href="css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
.title
{
    white-space: nowrap;
}
</style>
<script language="javascript" type="text/javascript">
//<![CDATA[
function OnInit()
{
    var currentDirectory = window.parent.Directory;

    var editOutPath = document.getElementById("editOutPath");
    if (currentDirectory == "/")
    {
        editOutPath.value = currentDirectory;
    }
    else
    {
        editOutPath.value = currentDirectory + "/";
    }
}

//移动选中的文件。
function selectFolder() {
    var pbFolderBrowser = window.parent.PageBox("FolderBrowser.aspx", "请选择目的文件夹", 500, 400, function(arg) {
        if (arg) {
            document.getElementById("editOutPath").value = arg == "/" ? arg : arg + "/";
            return false;
        }
    }, null, null, true, true);
}

//]]>

</script>
	</head>
	<body style="margin-left: 10px;">
		<form id="Form1" method="post" runat="server">
			<table id="Table1" cellspacing="1" cellpadding="1" border="0">
				<tr>
					<td class="title">压缩文档名：</td>
					<td><asp:textbox id="editZipFile" runat="server" Width="416px" ReadOnly="True"></asp:textbox></td>
				</tr>
				<tr>
					<td class="title">输出文件夹：</td>
					<td><asp:textbox id="editOutPath" runat="server" Width="354px"></asp:textbox>
					    <input id="btnSelectFolder" type="button" value="浏览…" onclick="selectFolder(); return false;" />
						<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="editOutPath" ErrorMessage="*"></asp:RequiredFieldValidator></td>
				</tr>
				<tr>
					<td class="title">&nbsp;</td>
					<td class="title">从网站根目录开始的绝对路径</td>
				</tr>
				<tr>
					<td class="title">覆盖文件：</td>
					<td class="title">
						<asp:checkbox id="cbOverwriteFiles" runat="server" Text="当解压缩档案文件存在时覆盖原文件"></asp:checkbox></td>
				</tr>
				<tr>
					<td class="title">解压缩密码：</td>
					<td>
						<asp:textbox id="editPassword" runat="server" TextMode="Password"></asp:textbox></td>
				</tr>
				<tr>
					<td class="title">解压缩结果：</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" colspan="2">
						<asp:textbox id="editResult" runat="server" Width="560px" TextMode="MultiLine" 
                            Height="300px" Wrap="False"></asp:textbox></td>
				</tr>
				<tr>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td align="center" colspan="2">
						<asp:button id="btnUnZip" runat="server" Text="开始解压缩" onclick="btnUnZip_Click"></asp:button> <input id="btnCancel" type="button" value=" 关 闭 " onclick="window.frameElement.Close(); return false;" /></td>
				</tr>
			</table>
		</form>
	</body>
</html>

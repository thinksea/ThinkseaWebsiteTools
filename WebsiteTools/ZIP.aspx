<%@ Page language="c#" Inherits="Thinksea.WebsiteTools.ZIP" CodeFile="ZIP.aspx.cs" %>
<%@ Assembly Src="Define.cs" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
	<head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>压缩文件</title>
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
    var selectedFiles = window.parent.GetSelectedFiles();

    var ZipFile = document.getElementById("editZipFile");
    if (currentDirectory == "/")
    {
        ZipFile.value = currentDirectory + "<%=System.DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".zip"%>";
    }
    else
    {
        ZipFile.value = currentDirectory + "/" + "<%=System.DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".zip"%>";
    }

    var FileName = document.getElementById("FileName");
    FileName.value="";
    for (var i = 0; i < selectedFiles.length; i++)
    {
        if (FileName.value != "")
        {
            FileName.value += "\r\n";
        }
        if (currentDirectory=="/")
        {
            FileName.value += currentDirectory + selectedFiles[i];
        }
        else
        {
            FileName.value += currentDirectory + "/" + selectedFiles[i];
        }
    }
}

//]]>
</script>
	</head>
	<body style="margin-left: 10px;">
		<form id="Form1" method="post" runat="server">
			<table id="Table1" cellspacing="1" cellpadding="1" border="0">
				<tr>
					<td class="title">压缩文档名：</td>
					<td><asp:textbox id="editZipFile" runat="server" Width="416px"></asp:textbox>
						<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="editZipFile" ErrorMessage="*"></asp:RequiredFieldValidator></td>
				</tr>
				<tr>
					<td class="title">&nbsp;</td>
					<td>从网站根目录开始的绝对路径</td>
				</tr>
				<tr>
					<td class="title" style="vertical-align: top;">待压缩文件：</td>
					<td class="title"><asp:textbox id="FileName" runat="server" 
                            Width="416px" Rows="5" TextMode="MultiLine"></asp:textbox>
						<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" 
                            ControlToValidate="FileName" ErrorMessage="*"></asp:RequiredFieldValidator></td>
				</tr>
				<tr>
					<td class="title">&nbsp;</td>
					<td class="title">从网站根目录开始的绝对路径</td>
				</tr>
				<tr>
					<td class="title">覆盖压缩文件：</td>
					<td class="title"><asp:checkbox id="cbOverwriteFiles" runat="server" 
                            Text="当压缩档案文件已经存在时覆盖原文件"></asp:checkbox></td>
				</tr>
				<tr>
					<td class="title">解压缩密码：</td>
					<td><asp:textbox id="editPassword" runat="server" TextMode="Password"></asp:textbox></td>
				</tr>
				<tr>
					<td class="title">密码验证：</td>
					<td class="title"><asp:textbox id="editPasswordAgain" runat="server" TextMode="Password"></asp:textbox>
                        <asp:comparevalidator id="CompareValidator1" runat="server" 
                            ErrorMessage="两次输入的密码不同" ControlToCompare="editPassword"
							ControlToValidate="editPasswordAgain"></asp:comparevalidator></td>
				</tr>
				<tr>
					<td class="title">压缩结果：</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" colspan="2"><asp:textbox id="editResult" runat="server" Width="560px" Wrap="False" Height="210px" TextMode="MultiLine"></asp:textbox></td>
				</tr>
				<tr>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td align="center" colspan="2"><asp:button id="btnZip" runat="server" Text="开始压缩" onclick="btnZip_Click"></asp:button> <input id="btnCancel" type="button" value=" 关 闭 " onclick="window.frameElement.Close(); return false;" /></td>
				</tr>
			</table>
		</form>
	</body>
</html>

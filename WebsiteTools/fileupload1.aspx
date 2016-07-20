<%@ Page Language="C#" Debug="true" %>
<%@ Assembly Src="Define.cs" %>
<script runat="server">
    /// <summary>
    /// 允许上传的文件类型列表。如果为空 null 则允许上传任意类型的文件。（文件类型不允许带前缀点号“.”。）
    /// </summary>
    private string[] AcceptedUploadFileTypes = null;//new string[] {"zip", "rar", "jpg","jpeg","jpe","gif","bmp","png", "swf", "avi", "wmv", "wma", "mp3", "doc", "xml", "txt", "rm", "rmvb", "mpeg", "mpeg4"};

    /// <summary>
    /// 文件上传临时目录。
    /// </summary>
    protected string UploadTempPath
    {
        get
        {
            return this.MapPath("uploadfiles");
            //return this.CurrentFolder;
        }
    }
    /// <summary>
    /// 文件上传目录。
    /// </summary>
    protected string CurrentFolder
    {
        get
        {
            string p = this.MapPath(this.Request["path"]);
            return p.EndsWith("\\") ? p : p + "\\";
        }
    }

    /// <summary>
    /// 指示是否在 bin 目录。
    /// </summary>
    protected bool IsBinDirectory
    {
        get
        {
            return this.CurrentFolder.StartsWith(System.Web.HttpRuntime.BinDirectory);
        }
    }

    /// <summary>
    /// 上传文件的最大尺寸（以字节为单位）。取值为 -1 表示不限制上传文件大小。
    /// </summary>
    protected readonly int UploadFileMaxSize = -1;

    protected void Page_Load(object sender, System.EventArgs e)
    {
        if (!this.IsPostBack && !this.IsCallback)
        {
            Thinksea.WebsiteTools.Define.CheckLogin();

            if (this.AcceptedUploadFileTypes != null)
            {
                this.lUploadTypes.Text = string.Join("；", this.AcceptedUploadFileTypes);
            }
            else
            {
                this.lUploadTypes.Text = "无限制";
            }
            if (this.IsBinDirectory)
            {
                this.rblOption.Items[0].Enabled = false;
                //this.rblOption.Items[1].Enabled = false;
                //this.rblOption.SelectedValue = "Overwrite";
            }
        }

    }

    /// <summary>
    /// 验证指定的文件类型是否允许上传。
    /// </summary>
    /// <param name="ExtensionName">文件扩展名。</param>
    /// <returns>如果是返回 True，否则返回 False。</returns>
    private bool IsValidUploadFileType(string ExtensionName)
    {
        if (this.AcceptedUploadFileTypes == null) return true;
        string ext = ExtensionName.ToLower().Trim('.');
        //string ext = FileName.Substring(FileName.LastIndexOf(".") + 1, FileName.Length - FileName.LastIndexOf(".") - 1).ToLower();
        foreach (string tmp in this.AcceptedUploadFileTypes)
        {
            if (ext == tmp.ToLower())
            {
                return true;
            }
        }
        return false;

    }

    protected void btn_upload_Load(object sender, System.EventArgs e)
    {
        Button m_button = sender as Button;
        Thinksea.WebControls.Upload.Upload m_upload = new Thinksea.WebControls.Upload.Upload();
        m_upload.MaxUploadSize = 1048576;//最大允许上传 1G 大小的文件。
        m_upload.RegisterProgressBar(m_button);
        if (!System.IO.Directory.Exists(this.UploadTempPath)) //创建上传文件功能使用的临时目录。
        {
            System.IO.Directory.CreateDirectory(UploadTempPath);
        }
        m_upload.UploadPath = this.UploadTempPath;//文件上传临时目录。

    }

    protected void btn_upload_Click(object sender, EventArgs e)
    {
        if (!this.IsValid) return;

        this.lResultsMessage.Text = "";

        Thinksea.WebControls.Upload.Upload m_upload = new Thinksea.WebControls.Upload.Upload();
        Thinksea.WebControls.Upload.UploadFileCollection files = m_upload.GetUploadedFileCollection("m_file");
        int count = files.Count;//总共上传的文件数量。
        int Success = 0;//成功上传文件数量。

        if (count == 0)
        {
            this.lResultsMessage.Text += "<li><img src='images/interjection.gif' width='20' height='20' />没有选择需要上传的文件。您可以单击“浏览”按钮选择上传的文件。</li>";
            return;
        }

        try
        {
            foreach (Thinksea.WebControls.Upload.UploadFile tmp in files)
            {
                if (tmp != null && tmp.FullName != null && tmp.FullName != string.Empty)//skip the empty input file.
                {
                    string UploadFileName = System.IO.Path.GetFileName(tmp.FullNameOnClient);
                    string ext = System.IO.Path.GetExtension(UploadFileName);

                    if (tmp.Length == 0)//禁止上传零字节的文件.
                    {
                        if (System.IO.File.Exists(tmp.FullName))
                        {
                            System.IO.File.Delete(tmp.FullName);
                        }
                        this.lResultsMessage.Text = "<li><img src='images/error.gif' width='20' height='20' />“" + this.Server.HtmlEncode(tmp.FullNameOnClient) + "”无效的文件尺寸。允许上传的文件尺寸不能是 0 字节。上传失败。</li>";
                        continue;
                    }
                    if (this.UploadFileMaxSize != -1 && tmp.Length > this.UploadFileMaxSize)
                    {
                        if (System.IO.File.Exists(tmp.FullName))
                        {
                            System.IO.File.Delete(tmp.FullName);
                        }
                        this.lResultsMessage.Text = "<li><img src='images/error.gif' width='20' height='20' />“" + this.Server.HtmlEncode(tmp.FullNameOnClient) + "”无效的文件尺寸。允许上传的文件尺寸不能大于 " + this.UploadFileMaxSize.ToString() + " 字节。上传失败。</li>";
                        continue;
                    }
                    if (!this.IsValidUploadFileType(ext))
                    {
                        if (System.IO.File.Exists(tmp.FullName))
                        {
                            System.IO.File.Delete(tmp.FullName);
                        }
                        this.lResultsMessage.Text += "<li><img src='images/error.gif' width='20' height='20' />“" + this.Server.HtmlEncode(tmp.FullNameOnClient) + "”禁止上传此类型文件。上传失败。</li>";
                        continue;
                    }

                    bool r_Rename = false;//指示上传文件是否经过改名。
                    #region 验证上传文件库库中是否存在与将要上传的文件同名的文件。
                    if (System.IO.File.Exists(System.IO.Path.Combine(this.CurrentFolder, UploadFileName)))
                    {
                        switch (this.rblOption.SelectedValue)
                        {
                            case "AllowNewFileName": //以新名称上传。
                                {
                                    #region 如果存在重名文件，则重新生成新的上传文件名。
                                    System.Random rand = new System.Random();
                                    string mainName = System.IO.Path.GetFileNameWithoutExtension(UploadFileName);
                                    do
                                    {
                                        UploadFileName = mainName + "_" + rand.Next(99999) + ext;
                                    } while (System.IO.File.Exists(System.IO.Path.Combine(this.CurrentFolder, UploadFileName)));
                                    #endregion
                                    r_Rename = true;
                                }
                                break;
                            case "Overwrite": //覆盖原文件。
                                {
                                    System.IO.File.Delete(System.IO.Path.Combine(this.CurrentFolder, UploadFileName));
                                }
                                break;
                            case "AutoBack": //先备份原文件然后再上传。
                            default:
                                {
                                    #region 如果存在重名文件，则生成备份文件名。
                                    System.Random rand = new System.Random();
                                    string backupFileName = UploadFileName;
                                    string mainName = System.IO.Path.GetFileNameWithoutExtension(UploadFileName);
                                    string extName = ext;
                                    if (this.IsBinDirectory && ext.ToLower() == ".dll") //对于 bin 目录里面的 dll 文件，采用特殊的扩展名备份，以避免程序集冲突。
                                    {
                                        extName += ".bak";
                                    }

                                    do
                                    {
                                        backupFileName = mainName + "_" + System.DateTime.Now.ToString("yyyyMMdd_HHmmss") + "_" + rand.Next(99999) + extName;
                                    } while (System.IO.File.Exists(System.IO.Path.Combine(this.CurrentFolder, backupFileName)));
                                    #endregion
                                    System.IO.File.Move(System.IO.Path.Combine(this.CurrentFolder, UploadFileName), System.IO.Path.Combine(this.CurrentFolder, backupFileName)); //备份原文件。
                                }
                                break;
                        }
                    }
                    #endregion

                    string SaveFile = System.IO.Path.Combine(this.CurrentFolder, UploadFileName);
                    bool r_Success = false;//指示上传文件是否成功。
                    #region 上传文件。
                    try
                    {
                        try
                        {
                            tmp.SaveAs(SaveFile);
                        }
                        catch (System.IO.DirectoryNotFoundException ex)
                        {
                            this.lResultsMessage.Text += "<li>“" + this.Server.HtmlEncode(tmp.FullNameOnClient) + "”上传失败，原因是：“" + this.Server.HtmlEncode(ex.Message) + "”。解决方法：可以尝试给磁盘目录 NETWORK SERVER 用户(Win2003)或 ASPNET 用户(Win2000) 用户读权限。</li>";
                            return;
                        }

                        Success++;
                        r_Success = true;
                    }
                    catch
                    {
                        r_Success = false;
                        if (System.IO.File.Exists(SaveFile))
                        {
                            System.IO.File.Delete(SaveFile);
                        }
                    }
                    #endregion

                    if (r_Success)
                    {
                        if (r_Rename)
                        {
                            this.lResultsMessage.Text += "<li><img src='images/interjection.gif' width='20' height='20' />“" + this.Server.HtmlEncode(tmp.FullNameOnClient) + "”以新的文件名“" + this.Server.HtmlEncode(UploadFileName) + "”上传，上传成功。</li>";
                        }
                        else
                        {
                            this.lResultsMessage.Text += "<li>“" + this.Server.HtmlEncode(tmp.FullNameOnClient) + "”上传成功。</li>";
                        }
                    }
                    else
                    {
                        if (r_Rename)
                        {
                            this.lResultsMessage.Text += "<li><img src='images/error.gif' width='20' height='20' />“" + this.Server.HtmlEncode(tmp.FullNameOnClient) + "”以新的文件名“" + this.Server.HtmlEncode(UploadFileName) + "”上传，上传失败。</li>";
                        }
                        else
                        {
                            this.lResultsMessage.Text += "<li><img src='images/error.gif' width='20' height='20' />“" + this.Server.HtmlEncode(tmp.FullNameOnClient) + "”上传失败。</li>";
                        }
                    }

                }

            }
        }
        catch
        {
            throw;
        }

        if (count == Success)
        {
            this.lResultsMessage.Text += "<br/><hr/>总共上传 " + count.ToString() + " 文件，全部上传成功。";
        }
        else
        {
            this.lResultsMessage.Text += "<br/><hr/>总共上传 " + count.ToString() + " 文件，" + Success.ToString() + "成功，" + (count - Success).ToString() + "失败。";
        }
        if (Success > 0)//有成功上传的文件则刷新文件列表窗口。
        {
            this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.parent.refresh();", true);
        }

    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head runat="server">
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>上传文件</title>
		<meta http-equiv="expires" content="0" />
		<link href="css/css.css" rel="stylesheet" type="text/css" />
		<style type="text/css">
.file{
	PADDING: 3px; 
	border: solid 1px #799ae1;
	font-size: 12px;
	font-family: Arial, 宋体;
}
		</style>
		<script language="javascript" type="text/javascript">
<!--
function addUploadBox()
{
	var uploadBoxesCount = 0;
	var uploadBoxes = document.getElementsByTagName("input");
	for(var i=0; i < uploadBoxes.length; i++)
	{
		if(uploadBoxes[i].type=='file' && uploadBoxes[i].name=="m_file")
		{
			if(uploadBoxes[i].value == "")//如果存在一个以上的空文件框则结束过程。
			{
				return;
			}
			uploadBoxesCount ++;
		}
	}

	var newBox = document.createElement("input");
	newBox.type = "file";
	newBox.name = "m_file";
	newBox.className = "file";
	newBox.contentEditable = false;
	newBox.style.width="100%";
	newBox.ChangedHandler = addUploadBox;
	newBox.onchange = newBox.ChangedHandler;
	document.getElementById("files").appendChild(newBox);
	document.getElementById("files").appendChild(document.createElement("br"));

}
//-->
		</script>
	</head>
	<body oncontextmenu="return false;" onselectstart="return false;" ondrag="return false;">
		<form id="Form1" enctype="multipart/form-data" runat="server">
			<table id="Table1" style="width: 100%" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td style="PADDING: 5px; BORDER: solid 1px #6687BA; width: 100%; background-color: #c8ddf4;">允许上传的文件类型：<br />
						<asp:literal id="lUploadTypes" runat="server"></asp:literal></td>
				</tr>
				<tr>
					<td style="PADDING: 3px">上传文件列表：</td>
				</tr>
				<tr>
					<td>
						<div id="files" style="BORDER: gray 1px dashed; PADDING: 5px; WIDTH: 100%; HEIGHT: 50px; background-color: #c8ddf4;"><input contenteditable="false" style="WIDTH: 100%" onpropertychange="addUploadBox();" type="file" class="file"
								name="m_file" /><br />
						</div>
					</td>
				</tr>
				<tr>
					<td style="PADDING-RIGHT: 3px; PADDING-LEFT: 3px; PADDING-BOTTOM: 3px; PADDING-TOP: 3px" align="right">
					    <table><tr><td>
					        <asp:RadioButtonList ID="rblOption" runat="server" RepeatLayout="Flow">
                                <asp:ListItem Value="AllowNewFileName">允许更改上传文件名称以避免产生覆盖</asp:ListItem>
                                <asp:ListItem Value="AutoBack" Selected="True">覆盖重名文件，先备份原文件</asp:ListItem>
                                <asp:ListItem Value="Overwrite">覆盖重名文件，不备份原文件（慎用此选项）</asp:ListItem>
                            </asp:RadioButtonList>
                        </td><td>
                            <asp:button id="btn_upload" Text="开始上传" Runat="server" onclick="btn_upload_Click" onload="btn_upload_Load" CssClass="Button"></asp:button>
                        </td></tr></table>
					</td>
				</tr>
				<tr>
					<td>
						<hr />
					</td>
				</tr>
				<tr>
					<td><asp:literal id="lResultsMessage" Runat="server"></asp:literal></td>
				</tr>
			</table>
		</form>
	</body>
</html>

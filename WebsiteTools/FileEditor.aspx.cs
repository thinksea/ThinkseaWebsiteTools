using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Thinksea.WebsiteTools
{
    public partial class FileEditor : System.Web.UI.Page
    {
        /// <summary>
        /// 加载文件使用的编码格式。
        /// </summary>
        public string LoadFileCode
        {
            get
            {
                string encoder = "utf-8";
                if (this.ddlEncoderLoad.SelectedIndex < 0)
                {
                    ListItem li = this.ddlEncoderLoad.Items.FindByValue(encoder);
                    if (li != null)
                    {
                        this.ddlEncoderLoad.SelectedValue = li.Value;
                    }
                }
                else
                {
                    encoder = this.ddlEncoderLoad.SelectedValue;
                }
                return encoder;
            }
        }

        /// <summary>
        /// 保存文件时使用的编码格式。
        /// </summary>
        public string SaveFileCode
        {
            get
            {
                if (this.cbSetSaveCode.Checked)
                {
                    return this.ddlEncoderSave.SelectedValue;
                }
                else
                {
                    return this.LoadFileCode;
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                Thinksea.WebsiteTools.Define.CheckLogin();

                if (!string.IsNullOrEmpty(this.Request["filename"]))
                {
                    this.tbFileName.Text = this.Request["filename"];
                    this.ReloadData();
                    this.ClientScript.RegisterStartupScript(this.GetType(), "", @"document.title = document.getElementById('tbFileName').value + ' - 文本文件编辑器';", true);
                }
                else
                {
                    //if (!string.IsNullOrEmpty(this.Request["directory"]))
                    //{
                    //    this.tbFileName.Text = this.Request["directory"].TrimEnd('/', '\\') + "/新建文档.txt";
                    //}
                    //else
                    //{
                    //    this.tbFileName.Text = "/新建文档.txt";
                    //}
                    this.ClientScript.RegisterStartupScript(this.GetType(), "", @"if(window.opener!=null)
{
    document.getElementById('tbFileName').value = (window.opener.Directory.replace(/\\/gi, '/') + '/新建文档.txt').replace(/\/\//gi, '/');
    document.title = document.getElementById('tbFileName').value + ' - 文本文件编辑器';
}", true);
                }
            }
            else
            {
                this.ClientScript.RegisterStartupScript(this.GetType(), "", @"document.title = document.getElementById('tbFileName').value + ' - 文本文件编辑器';", true);
            }

        }

        /// <summary>
        /// 重新加载数据从服务器。
        /// </summary>
        protected void ReloadData()
        {
            string file = this.MapPath(this.tbFileName.Text);
            if (System.IO.File.Exists(file) == false)
            {
                this.Response.Clear();
                this.Response.Write("未找到指定的文件“" + file + "”。");
                this.Response.End();
                return;
            }
            string encoder = this.LoadFileCode;
            System.IO.StreamReader fs = new System.IO.StreamReader(file, System.Text.Encoding.GetEncoding(encoder));
            try
            {
                this.tbContent.Text = fs.ReadToEnd();
            }
            finally
            {
                fs.Close();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string file = this.MapPath(this.tbFileName.Text);
            string encoder = this.SaveFileCode;
            string dir = System.IO.Path.GetDirectoryName(file);
            if (!System.IO.Directory.Exists(dir)) //如果目录不存在则创建。
            {
                System.IO.Directory.CreateDirectory(dir);
            }
            else
            {
                if (this.cbBackupFile.Checked && System.IO.File.Exists(file)) //如果需要备份原文件
                {
                    #region 如果存在重名文件，则生成备份文件名。
                    System.Random rand = new System.Random();
                    string CurrentFolder = System.IO.Path.GetDirectoryName(file);
                    string backupFileName = file;
                    string mainName = System.IO.Path.GetFileNameWithoutExtension(file);
                    string ext = System.IO.Path.GetExtension(file);
                    do
                    {
                        backupFileName = mainName + "_" + System.DateTime.Now.ToString("yyyyMMdd_HHmmss") + "_" + rand.Next(99999) + ext;
                    } while (System.IO.File.Exists(System.IO.Path.Combine(CurrentFolder, backupFileName)));
                    #endregion
                    System.IO.File.Move(file, System.IO.Path.Combine(CurrentFolder, backupFileName)); //备份原文件。
                }
            }

            System.IO.StreamWriter sw = new System.IO.StreamWriter(file, false, System.Text.Encoding.GetEncoding(encoder));
            try
            {
                sw.Write(this.tbContent.Text);
            }
            finally
            {
                sw.Close();
            }

        }
        protected void btnRefreshFromServer_Click(object sender, EventArgs e)
        {
            this.ReloadData();
        }
        protected void cbSetSaveCode_CheckedChanged(object sender, EventArgs e)
        {
            this.ddlEncoderSave.Enabled = this.cbSetSaveCode.Checked;
        }
}

}

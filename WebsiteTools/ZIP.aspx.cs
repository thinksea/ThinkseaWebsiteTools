using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace Thinksea.WebsiteTools
{
	/// <summary>
	/// ZIP 的摘要说明。
	/// </summary>
	public partial class ZIP : System.Web.UI.Page
	{

		protected void Page_Load(object sender, System.EventArgs e)
		{
			// 在此处放置用户代码以初始化页面
			if( ! this.IsPostBack )
			{
                Thinksea.WebsiteTools.Define.CheckLogin();

                this.ClientScript.RegisterStartupScript(this.GetType(), "", @"OnInit();", true);
			}

		}

		protected void btnZip_Click(object sender, System.EventArgs e)
		{
			if( ! this.IsValid ) return;

            string ZipFile = this.Server.MapPath(this.editZipFile.Text);// System.IO.Path.GetFullPath(System.IO.Path.Combine(ZipFileDirectory, System.IO.Path.GetFileName(this.editZipFile.Text).TrimStart('\\', '/', '.')));
            string ZipFileDirectory = System.IO.Path.GetDirectoryName(ZipFile);// 压缩包存放路径。
            string[] tfiles = this.FileName.Text.Split(new string[] { "\r\n", "\n\r", "\r", "\n" }, StringSplitOptions.RemoveEmptyEntries);

			#region 确保压缩文档存盘目录存在。
            if (!System.IO.Directory.Exists(ZipFileDirectory))
			{
				try
				{
                    Thinksea.WebsiteTools.Define.CreateDirectory(ZipFileDirectory);
				}
				catch
				{
                    this.editResult.Text += "\r\n>>>>>压缩中止：原因是无法创建压缩文档存放目录 " + ZipFileDirectory.Substring(this.Server.MapPath("/").Length - 1);
					return;
				}
			}
			#endregion

			if( System.IO.File.Exists( ZipFile ) == true && this.cbOverwriteFiles.Checked == false )
			{
				this.editResult.Text += "\r\n>>压缩中止：原因是已经存在重名的压缩文档。";
				return;
			}

			System.DateTime BeginDateTime = System.DateTime.Now;
			int countc = 0;
			try
			{
                System.Collections.Generic.List<string> scoll = new System.Collections.Generic.List<string>();
                foreach (string tmp in tfiles)
                {
                    scoll.Add(System.IO.Path.GetFullPath(System.IO.Path.Combine(this.MapPath("/"), tmp.Replace('/', '\\').TrimStart('\\', '.'))));
                }

                if (System.IO.Path.GetExtension(ZipFile).ToLower() != ".rar")
                {
                    #region 调用 ZIP 压缩功能 DLL 执行压缩。
                    countc = TZip.ZipDir(ZipFile, scoll.ToArray(), this.editPassword.Text, 1024 * 1024);
                    #endregion
                }
                else
                {
                    #region 调用 RAR 执行压缩。
                    System.Diagnostics.ProcessStartInfo winrarProcessInfo = new System.Diagnostics.ProcessStartInfo(this.MapPath("rar.exe"));
                    winrarProcessInfo.RedirectStandardInput = true;
                    winrarProcessInfo.UseShellExecute = false;
                    winrarProcessInfo.CreateNoWindow = true;
                    winrarProcessInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                    string Arguments = " a -ep1 -inul -y -m5";
                    if (!string.IsNullOrEmpty(this.editPassword.Text))
                    {
                        Arguments += string.Format(@" -p""{0}""", this.editPassword.Text);
                    }
                    Arguments += string.Format(@" ""{0}""", ZipFile);
                    Arguments += " @";
                    winrarProcessInfo.Arguments = Arguments;
                    System.Diagnostics.Process winrarProcess1 = new System.Diagnostics.Process();
                    winrarProcess1.StartInfo = winrarProcessInfo;
                    winrarProcess1.Start(); //进行压缩
                    foreach (string file in scoll)
                    {
                        winrarProcess1.StandardInput.WriteLine(file);
                    }
                    winrarProcess1.StandardInput.Close();
                    winrarProcess1.WaitForExit();
                    int exitCode = winrarProcess1.ExitCode;
                    winrarProcess1.Close();
                    switch (exitCode)
                    {
                        case 0: //操作成功
                            break;
                        case 1: //警告，没有发生致命错误
                            throw new System.Exception("引发了一个警告，但是没有发生致命错误。");
                            break;
                        case 2: //发生一个致命错误
                            throw new System.Exception("发生一个致命错误。");
                            break;
                        case 3: //解压缩时发生一个 CRC 错误
                            throw new System.Exception("解压缩时发生一个 CRC 错误。");
                            break;
                        case 4: //试图修改先前使用 'k' 命令锁定的压缩文件
                            throw new System.Exception("试图修改先前使用 'k' 命令锁定的压缩文件。");
                            break;
                        case 5: //写入磁盘错误
                            throw new System.Exception("写入磁盘错误。");
                            break;
                        case 6: //打开文件错误
                            throw new System.Exception("打开文件错误。");
                            break;
                        case 7: //命令行选项错误
                            throw new System.Exception("命令行选项错误。");
                            break;
                        case 8: //没有足够的内存进行操作
                            throw new System.Exception("没有足够的内存进行操作。");
                            break;
                        case 9: //创建文件错误
                            throw new System.Exception("创建文件错误。");
                            break;
                        case 255: //用户中断操作
                            throw new System.Exception("用户中断操作。");
                            break;
                        default: //未知错误
                            throw new System.Exception("未知的 RAR 程序错误，错误号：" + exitCode.ToString());
                            break;
                    }

                    countc = 0;
                    foreach (string file in scoll)
                    {
                        if (System.IO.File.Exists(file))
                        {
                            countc++;
                        }
                        else if (System.IO.Directory.Exists(file))
                        {
                            string[] files = System.IO.Directory.GetFiles(file, "*.*", System.IO.SearchOption.AllDirectories);
                            string[] dirs = System.IO.Directory.GetDirectories(file, "*.*", System.IO.SearchOption.AllDirectories);
                            countc += (files.Length + dirs.Length);
                        }
                    }
                    #endregion
                }

            }
			catch( System.Exception ex )
			{
				this.editResult.Text += ( "\r\n>>压缩失败！详细信息：" + ex.ToString() );
				return;
			}
			System.DateTime EndDateTime = System.DateTime.Now;

            this.editResult.Text = this.editResult.Text
                + "\r\n========================== 压缩完成 ============================="
                + "\r\n压缩文档：" + ZipFile.Replace(this.MapPath("/"), "/").Replace('\\', '/')
                + "\r\n压缩文件数量：" + countc.ToString()
                + "\r\n开始时间：" + BeginDateTime.ToString()
                + "\r\n结束时间：" + EndDateTime.ToString()
                + "\r\n总共花费时间：" + (EndDateTime - BeginDateTime).ToString()
                + "\r\n=================================================================";

            this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.parent.refresh();", true);
        }


	}


}

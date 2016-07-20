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
using System.IO;

namespace Thinksea.WebsiteTools
{
	/// <summary>
	/// UnZIP 的摘要说明。
	/// </summary>
	public partial class UnZIP : System.Web.UI.Page
	{

		protected void Page_Load(object sender, System.EventArgs e)
		{
			// 在此处放置用户代码以初始化页面
            if (!this.IsPostBack)
			{
                Thinksea.WebsiteTools.Define.CheckLogin();

                this.ClientScript.RegisterStartupScript(this.GetType(), "", @"OnInit();", true);
                if (this.Request["zipfilename"] != null && this.Request["zipfilename"] != "")
				{
					this.editZipFile.Text = this.Request["zipfilename"];
				}
			}

		}

		#region Web 窗体设计器生成的代码
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: 该调用是 ASP.NET Web 窗体设计器所必需的。
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// 设计器支持所需的方法 - 不要使用代码编辑器修改
		/// 此方法的内容。
		/// </summary>
		private void InitializeComponent()
		{    

		}
		#endregion

		protected void btnUnZip_Click(object sender, System.EventArgs e)
		{
			if( ! this.IsValid ) return;

			string ZipFile = "";
			string OutPath = "";
			try
			{
                ZipFile = this.Server.MapPath(this.editZipFile.Text.Replace('/', '\\'));
                OutPath = this.Server.MapPath(this.editOutPath.Text.Replace('/', '\\'));
			}
			catch(System.Exception ex)
			{
				this.editResult.Text += ( "\r\n>>解压缩失败！详细信息：" + ex.ToString() );
				return;
			}

			System.DateTime BeginDateTime = System.DateTime.Now;
			int countc = 0;
			try
			{
                if (System.IO.Path.GetExtension(ZipFile).ToLower() == ".zip")
                {
                    #region 调用 ZIP 压缩功能 DLL 执行解压缩。
                    countc = Thinksea.WebsiteTools.TZip.Decompress(ZipFile, OutPath, this.editPassword.Text, this.cbOverwriteFiles.Checked, 1024 * 1024);
                    #endregion
                }
                else
                {
                    #region 调用 RAR 执行解压缩。
                    if (!System.IO.Directory.Exists(OutPath))
                    {
                        System.IO.Directory.CreateDirectory(OutPath);
                    }
                    System.Diagnostics.ProcessStartInfo winrarProcessInfo = new System.Diagnostics.ProcessStartInfo(this.MapPath("rar.exe"));
                    winrarProcessInfo.UseShellExecute = false;
                    winrarProcessInfo.CreateNoWindow = true;
                    winrarProcessInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                    string Arguments = " x -ep1 -inul -y";
                    Arguments += string.Format(@" -p""{0}""", string.IsNullOrEmpty(this.editPassword.Text) ? "0" : this.editPassword.Text);
                    Arguments += string.Format(@" ""{0}"" ""{1}""", ZipFile, OutPath);
                    winrarProcessInfo.Arguments = Arguments;
                    System.Diagnostics.Process winrarProcess1 = new System.Diagnostics.Process();
                    winrarProcess1.StartInfo = winrarProcessInfo;
                    winrarProcess1.Start(); //进行压缩
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

                    {
                        string[] files = System.IO.Directory.GetFiles(OutPath, "*.*", System.IO.SearchOption.AllDirectories);
                        string[] dirs = System.IO.Directory.GetDirectories(OutPath, "*.*", System.IO.SearchOption.AllDirectories);
                        countc = (files.Length + dirs.Length);
                    }
                    #endregion
                }

            }
			catch(ICSharpCode.SharpZipLib.Zip.ZipException ex)
			{
				if( ex.Message == "Invalid password" )
				{
					this.editResult.Text += ("\r\n>>您输入的解压缩密码错误！");
					return;
				}
			}
			catch( System.Exception ex )
			{
				this.editResult.Text += ( "\r\n>>解压缩失败！详细信息：" + ex.ToString() );
				return;
			}

			System.DateTime EndDateTime = System.DateTime.Now;
            this.editResult.Text = this.editResult.Text
                + "\r\n========================== 解压缩完成 ============================="
                + "\r\n解压缩文件名：" + this.editZipFile.Text
                + "\r\n解压缩路径：" + OutPath.Replace(this.MapPath("/"), "/").TrimEnd('/', '\\') + "/"
				+ "\r\n解压缩文件数量：" + countc.ToString()
				+ "\r\n开始时间：" + BeginDateTime.ToString()
				+ "\r\n结束时间：" + EndDateTime.ToString()
				+ "\r\n总共花费时间：" + (EndDateTime - BeginDateTime).ToString()
				+ "\r\n=================================================================";

            this.editResult.Text += System.IO.Path.GetExtension(ZipFile);
            this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.parent.refresh();", true);
        }


    }
}

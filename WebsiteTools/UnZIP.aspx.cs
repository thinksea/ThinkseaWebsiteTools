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
	/// UnZIP ��ժҪ˵����
	/// </summary>
	public partial class UnZIP : System.Web.UI.Page
	{

		protected void Page_Load(object sender, System.EventArgs e)
		{
			// �ڴ˴������û������Գ�ʼ��ҳ��
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

		#region Web ������������ɵĴ���
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: �õ����� ASP.NET Web ���������������ġ�
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// �����֧������ķ��� - ��Ҫʹ�ô���༭���޸�
		/// �˷��������ݡ�
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
				this.editResult.Text += ( "\r\n>>��ѹ��ʧ�ܣ���ϸ��Ϣ��" + ex.ToString() );
				return;
			}

			System.DateTime BeginDateTime = System.DateTime.Now;
			int countc = 0;
			try
			{
                if (System.IO.Path.GetExtension(ZipFile).ToLower() == ".zip")
                {
                    #region ���� ZIP ѹ������ DLL ִ�н�ѹ����
                    countc = Thinksea.WebsiteTools.TZip.Decompress(ZipFile, OutPath, this.editPassword.Text, this.cbOverwriteFiles.Checked, 1024 * 1024);
                    #endregion
                }
                else
                {
                    #region ���� RAR ִ�н�ѹ����
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
                    winrarProcess1.Start(); //����ѹ��
                    winrarProcess1.WaitForExit();
                    int exitCode = winrarProcess1.ExitCode;
                    winrarProcess1.Close();
                    switch (exitCode)
                    {
                        case 0: //�����ɹ�
                            break;
                        case 1: //���棬û�з�����������
                            throw new System.Exception("������һ�����棬����û�з�����������");
                            break;
                        case 2: //����һ����������
                            throw new System.Exception("����һ����������");
                            break;
                        case 3: //��ѹ��ʱ����һ�� CRC ����
                            throw new System.Exception("��ѹ��ʱ����һ�� CRC ����");
                            break;
                        case 4: //��ͼ�޸���ǰʹ�� 'k' ����������ѹ���ļ�
                            throw new System.Exception("��ͼ�޸���ǰʹ�� 'k' ����������ѹ���ļ���");
                            break;
                        case 5: //д����̴���
                            throw new System.Exception("д����̴���");
                            break;
                        case 6: //���ļ�����
                            throw new System.Exception("���ļ�����");
                            break;
                        case 7: //������ѡ�����
                            throw new System.Exception("������ѡ�����");
                            break;
                        case 8: //û���㹻���ڴ���в���
                            throw new System.Exception("û���㹻���ڴ���в�����");
                            break;
                        case 9: //�����ļ�����
                            throw new System.Exception("�����ļ�����");
                            break;
                        case 255: //�û��жϲ���
                            throw new System.Exception("�û��жϲ�����");
                            break;
                        default: //δ֪����
                            throw new System.Exception("δ֪�� RAR ������󣬴���ţ�" + exitCode.ToString());
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
					this.editResult.Text += ("\r\n>>������Ľ�ѹ���������");
					return;
				}
			}
			catch( System.Exception ex )
			{
				this.editResult.Text += ( "\r\n>>��ѹ��ʧ�ܣ���ϸ��Ϣ��" + ex.ToString() );
				return;
			}

			System.DateTime EndDateTime = System.DateTime.Now;
            this.editResult.Text = this.editResult.Text
                + "\r\n========================== ��ѹ����� ============================="
                + "\r\n��ѹ���ļ�����" + this.editZipFile.Text
                + "\r\n��ѹ��·����" + OutPath.Replace(this.MapPath("/"), "/").TrimEnd('/', '\\') + "/"
				+ "\r\n��ѹ���ļ�������" + countc.ToString()
				+ "\r\n��ʼʱ�䣺" + BeginDateTime.ToString()
				+ "\r\n����ʱ�䣺" + EndDateTime.ToString()
				+ "\r\n�ܹ�����ʱ�䣺" + (EndDateTime - BeginDateTime).ToString()
				+ "\r\n=================================================================";

            this.editResult.Text += System.IO.Path.GetExtension(ZipFile);
            this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.parent.refresh();", true);
        }


    }
}

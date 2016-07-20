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
	/// ZIP ��ժҪ˵����
	/// </summary>
	public partial class ZIP : System.Web.UI.Page
	{

		protected void Page_Load(object sender, System.EventArgs e)
		{
			// �ڴ˴������û������Գ�ʼ��ҳ��
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
            string ZipFileDirectory = System.IO.Path.GetDirectoryName(ZipFile);// ѹ�������·����
            string[] tfiles = this.FileName.Text.Split(new string[] { "\r\n", "\n\r", "\r", "\n" }, StringSplitOptions.RemoveEmptyEntries);

			#region ȷ��ѹ���ĵ�����Ŀ¼���ڡ�
            if (!System.IO.Directory.Exists(ZipFileDirectory))
			{
				try
				{
                    Thinksea.WebsiteTools.Define.CreateDirectory(ZipFileDirectory);
				}
				catch
				{
                    this.editResult.Text += "\r\n>>>>>ѹ����ֹ��ԭ�����޷�����ѹ���ĵ����Ŀ¼ " + ZipFileDirectory.Substring(this.Server.MapPath("/").Length - 1);
					return;
				}
			}
			#endregion

			if( System.IO.File.Exists( ZipFile ) == true && this.cbOverwriteFiles.Checked == false )
			{
				this.editResult.Text += "\r\n>>ѹ����ֹ��ԭ�����Ѿ�����������ѹ���ĵ���";
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
                    #region ���� ZIP ѹ������ DLL ִ��ѹ����
                    countc = TZip.ZipDir(ZipFile, scoll.ToArray(), this.editPassword.Text, 1024 * 1024);
                    #endregion
                }
                else
                {
                    #region ���� RAR ִ��ѹ����
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
                    winrarProcess1.Start(); //����ѹ��
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
				this.editResult.Text += ( "\r\n>>ѹ��ʧ�ܣ���ϸ��Ϣ��" + ex.ToString() );
				return;
			}
			System.DateTime EndDateTime = System.DateTime.Now;

            this.editResult.Text = this.editResult.Text
                + "\r\n========================== ѹ����� ============================="
                + "\r\nѹ���ĵ���" + ZipFile.Replace(this.MapPath("/"), "/").Replace('\\', '/')
                + "\r\nѹ���ļ�������" + countc.ToString()
                + "\r\n��ʼʱ�䣺" + BeginDateTime.ToString()
                + "\r\n����ʱ�䣺" + EndDateTime.ToString()
                + "\r\n�ܹ�����ʱ�䣺" + (EndDateTime - BeginDateTime).ToString()
                + "\r\n=================================================================";

            this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.parent.refresh();", true);
        }


	}


}

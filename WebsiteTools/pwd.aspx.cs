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
	/// pwd ��ժҪ˵����
	/// </summary>
	public partial class pwd : System.Web.UI.Page
	{
	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			// �ڴ˴������û������Գ�ʼ��ҳ��
            if (!this.IsPostBack)
            {
                Thinksea.WebsiteTools.Define.CheckLogin();
            }

        }

		protected void btnAccept_Click(object sender, System.EventArgs e)
		{
			if( this.CheckPassword(this.editPassword.Text) )
			{
				this.ModifyPassword(this.editNewPassword.Text);
                this.lblPrompt.Text = "";//�޸�������ɣ�
			}
			else
			{
				this.lblPrompt.Text = "ԭ�������";
			}

		}

		public bool CheckPassword( string Password )
		{
			string PwdFile = this.Server.MapPath(".") + "\\pwg.config";
			string Pwd = "";
			System.IO.StreamReader srf = new System.IO.StreamReader( PwdFile );
			try
			{
				Pwd = srf.ReadToEnd();
			}
			finally
			{
				srf.Close();
			}
			if( EncryptPassword( Password ) == Pwd )
			{
				return true;
			}
			else
			{
				return false;
			}

		}

		/// <summary>
		/// ���������ַ�����
		/// </summary>
		/// <param name="Password"></param>
		/// <returns></returns>
		public static string EncryptPassword( string Password )
		{
			return System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile( Password, "sha1" );
		}

		public void ModifyPassword( string NewPassword )
		{
            string PwdFile = this.Server.MapPath("pwg.config");
			System.IO.StreamWriter swf = new System.IO.StreamWriter( PwdFile );
			try
			{
				swf.Write( EncryptPassword( NewPassword ) );
			}
			finally
			{
				swf.Close();
			}

            this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.setTimeout(function(){
var pb = window.parent.MessageBox('����������ɣ�'
	, '��Ϣ'
	, 'OK'
	, 'Information'
);
window.frameElement.Close();
}, 0);", true);

        }

	}
}

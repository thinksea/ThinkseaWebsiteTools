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
	/// Login 的摘要说明。
	/// </summary>
	public partial class Login : System.Web.UI.Page
	{
		private Thinksea.WebsiteTools.VerifyCode verifyCode = new Thinksea.WebsiteTools.VerifyCode();
		protected void Page_Load(object sender, System.EventArgs e)
		{
			// 在此处放置用户代码以初始化页面
			this.verifyCode.ColorText = true;
			this.verifyCode.Pinto = 0.5F;
			this.PlaceHolder1.Controls.Add(verifyCode);
		}

		protected void btnAccept_Click(object sender, System.EventArgs e)
		{
			if (this.verifyCode.IsVerify(this.editVerifyCode.Text) == false)
            {
                this.lblPrompt.Text = "验证码不正确！";
				this.editVerifyCode.Text = "";
                return;
            }
			if( CheckPassword(this.editPassword.Text) )
			{
				if( Request["ReturnUrl"] == null )
				{
                    Define.SetLogin();
					this.Response.Redirect( "." );
				}
				else
				{
                    Define.SetLogin();
                    this.Response.Redirect(Request["ReturnUrl"]);
				}
			}
			else
			{
				this.lblPrompt.Text = "密码错误！";
				this.editVerifyCode.Text = "";
            }

		}

		public bool CheckPassword( string Password )
		{
            string PwdFile = this.Server.MapPath("pwg.config");
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
		/// 加密密码字符串。
		/// </summary>
		/// <param name="Password"></param>
		/// <returns></returns>
		public static string EncryptPassword( string Password )
		{
			return System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile( Password, "sha1" );
		}


	}
}

using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;

using System.ComponentModel.Design;
using System.ComponentModel.Design.Serialization;
using System.Collections;
using System.Diagnostics;

namespace Thinksea.WebsiteTools
{
	/// <summary>
	/// 验证码控件。
	/// </summary>
	/// <remarks>
	/// <note>要求应用本控件的网络页面必须启动 Session 会话。</note>
	/// </remarks>
	[ToolboxData("<{0}:VerifyCode runat=server></{0}:VerifyCode>"),
	DefaultProperty("Length"),
	]
	public class VerifyCode : System.Web.UI.WebControls.Image, INamingContainer//, IPostBackEventHandler//, IStateManager
	{
		/// <summary>
		/// 用于存储验证码的密码字符串。
		/// </summary>
		private string _VerifyCode = "";
		/// <summary>
		/// 用于存储验证码的字符枚举，指示产生的验证码允许出现的字符列表。
		/// </summary>
		private string _VerifyCodeEnumerable = "0123456789";
		/// <summary>
		/// 获取或设置产生的验证码允许出现的字符列表。
		/// </summary>
		[
		System.ComponentModel.DefaultValue("0123456789"),
		System.ComponentModel.Category("Data"), 
		System.ComponentModel.Description("产生的验证码允许出现的字符列表"),
		System.ComponentModel.NotifyParentProperty(true),
		]
		public string VerifyCodeEnumerable
		{
			get
			{
				return this._VerifyCodeEnumerable;
			}
			set
			{
				this._VerifyCodeEnumerable = value;
			}
		}

		/// <summary>
		/// 验证码长度
		/// </summary>
		private int _Length = 6;
		/// <summary>
		/// 设置或获取验证码长度
		/// </summary>
		[
		System.ComponentModel.DefaultValue(6),
		System.ComponentModel.Category("Data"), 
		System.ComponentModel.Description("验证码长度"),
		System.ComponentModel.NotifyParentProperty(true),
		]
		public int Length
		{
			get
			{
				return this._Length;
			}
			set
			{
				if( value <= 0 )
				{
					throw new System.ArgumentOutOfRangeException("value", value, "指定的参数已超出有效取值的范围，该参数取值必须大于 0。");
				}
				this._Length = value;
			}
		}

		/// <summary>
		/// 字号
		/// </summary>
		private int _FontSize = 22;
		/// <summary>
		/// 设置或获取字号
		/// </summary>
		[
		System.ComponentModel.DefaultValue(22),
		System.ComponentModel.Category("Data"), 
		System.ComponentModel.Description("字号"),
		System.ComponentModel.NotifyParentProperty(true),
		]
		public int FontSize
		{
			get
			{
				return this._FontSize;
			}
			set
			{
				if( value <= 0 )
				{
					throw new System.ArgumentOutOfRangeException("value", value, "指定的参数已超出有效取值的范围，该参数取值必须大于 0。");
				}
				this._FontSize = value;
			}
		}

		/// <summary>
		/// 文本颜色。
		/// </summary>
		private System.Drawing.Color _ForeColor = System.Drawing.Color.Black;
		/// <summary>
		/// 设置或获取文本颜色。
		/// </summary>
		[
		//System.ComponentModel.DefaultValue(System.Drawing.Color.Black),
		System.ComponentModel.Category("Data"), 
		System.ComponentModel.Description("文本颜色"),
		System.ComponentModel.NotifyParentProperty(true),
		]
		public new System.Drawing.Color ForeColor
		{
			get
			{
				return this._ForeColor;
			}
			set
			{
				this._ForeColor = value;
			}
		}

		/// <summary>
		/// 杂色填充深度
		/// </summary>
		private float _Pinto = 0.20F;
		/// <summary>
		/// 设置或获取杂色填充深度
		/// </summary>
		[
		System.ComponentModel.DefaultValue(0.20F),
		System.ComponentModel.Category("Data"), 
		System.ComponentModel.Description("杂色填充深度"),
		System.ComponentModel.NotifyParentProperty(true),
		]
		public float Pinto
		{
			get
			{
				return this._Pinto;
			}
			set
			{
				if( value < 0 )
				{
					throw new System.ArgumentOutOfRangeException("value", value, "指定的参数已超出有效取值的范围，该参数取值不能小于 0。");
				}
				this._Pinto = value;
			}
		}

		private System.Drawing.Color _BackColor = System.Drawing.Color.White;
		/// <summary>
		/// 设置或获取背景填充颜色
		/// </summary>
		[
		//System.ComponentModel.DefaultValue(System.Drawing.Color.White),
		System.ComponentModel.Category("Data"),
        System.ComponentModel.Description("背景填充颜色"),
		System.ComponentModel.NotifyParentProperty(true),
		]
		public new System.Drawing.Color BackColor
		{
			get
			{
				return this._BackColor;
			}
			set
			{
				this._BackColor = value;
			}
		}

        private bool _ColorText = false;
        /// <summary>
        /// 获取或设置一个值，指示用彩色显示或者用单色显示文字。
        /// </summary>
        [
        System.ComponentModel.DefaultValue(false),
        System.ComponentModel.Category("Data"),
        System.ComponentModel.Description("指示生成彩色文本还是单色文字。"),
        System.ComponentModel.NotifyParentProperty(true),
        ]
        public bool ColorText
        {
            get
            {
                return this._ColorText;
            }
            set
            {
                this._ColorText = value;
            }
        }

		/// <summary>
		/// 加密密码字符串。
		/// </summary>
		/// <param name="Password"></param>
		/// <returns></returns>
		private static string EncryptPassword( string Password )
		{
            return Password;
		}

		/// <summary>
		/// 获取验证码的密码字符串。
		/// </summary>
		/// <returns>验证码的密文形式。</returns>
		public string GetVerifyCode()
		{
			if (this.IsTrackingViewState)
			{
				object savedVerifyCode = this.Page.Session["VerifyCode" + this.ClientID];
				if( savedVerifyCode != null ) this._VerifyCode = (string)savedVerifyCode;
			}
			return this._VerifyCode;

		}

		/// <summary>
		/// 验证指定的验证码是否与此实例所表示的验证码相同。
		/// </summary>
		/// <param name="VerifyCode">用户输入的验证码。</param>
		/// <returns>如果输入正确返回 true，否则返回 false。</returns>
		public bool IsVerify( string VerifyCode )
		{
			if( this.GetVerifyCode() == EncryptPassword( VerifyCode ) )
			{
				return true;
			}
			return false;

		}

		/// <summary>
		/// 验证指定的验证码是否与指定验证码控件所表示的验证码相同。
		/// </summary>
		/// <param name="VerifyCode">用户输入的验证码。</param>
		/// <param name="VerifyCodeControlID">验证码控件 ID。</param>
		/// <returns>如果输入正确返回 true，否则返回 false。</returns>
		public static bool IsVerify( string VerifyCode, string VerifyCodeControlID )
		{
			object savedVerifyCode = System.Web.HttpContext.Current.Session["VerifyCode" + VerifyCodeControlID];
			if( savedVerifyCode != null )
			{
				if( (string)savedVerifyCode == EncryptPassword( VerifyCode ) )
				{
					return true;
				}
			}
			return false;

		}


		/// <summary>
		/// 随机生成一个新的验证码。
		/// </summary>
		/// <returns></returns>
		private string GenerateVerifyCodeString( )
		{
			System.Random rand = new System.Random();
			string tmpVerifyCodeEnumerable = this.VerifyCodeEnumerable;
			string strVerifyCode = "";
			for( int i = 0; i < this.Length; i++ )
			{
				strVerifyCode += tmpVerifyCodeEnumerable[rand.Next(tmpVerifyCodeEnumerable.Length)];
			}
			return strVerifyCode;

		}

		/// <summary>
		/// 生成包含指定文本的斑点图像。
		/// </summary>
		/// <param name="VerifyCodeText">验证码文本</param>
		/// <returns></returns>
		private System.Drawing.Bitmap GenerateVerifyCodeImage( string VerifyCodeText )
		{
            System.Drawing.Size size;//输出图像的尺寸
            System.Drawing.StringFormat stringFormat = new System.Drawing.StringFormat(System.Drawing.StringFormatFlags.NoClip | System.Drawing.StringFormatFlags.NoWrap | System.Drawing.StringFormatFlags.MeasureTrailingSpaces | System.Drawing.StringFormatFlags.FitBlackBox);
            System.Drawing.Font font = new System.Drawing.Font("Arial", this.FontSize, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Pixel);
            System.Drawing.Pen LinePen = new System.Drawing.Pen(new System.Drawing.SolidBrush(this.ForeColor));

            System.Random rand = new System.Random();

            #region 计算图像尺寸。
            using (System.Drawing.Bitmap b = new System.Drawing.Bitmap(1, 1, System.Drawing.Imaging.PixelFormat.Format32bppArgb))
            {
                System.Drawing.Graphics g1 = System.Drawing.Graphics.FromImage(b);
                g1.PageUnit = font.Unit;
                System.Drawing.SizeF sizeF = g1.MeasureString(VerifyCodeText, font, new System.Drawing.PointF(0, 0), stringFormat);
                size = new System.Drawing.Size(System.Convert.ToInt32(System.Math.Ceiling(sizeF.Width)), System.Convert.ToInt32(System.Math.Ceiling(font.Size)));
            }
            #endregion

            System.Drawing.Bitmap bitmap = new System.Drawing.Bitmap(size.Width, size.Height, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
            System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bitmap);
            g.Clear(this.BackColor);

            #region 绘制验证码文本。
            {
                if (!this.ColorText)
                {
                    g.DrawString(VerifyCodeText, font, new System.Drawing.SolidBrush(this.ForeColor), 0, 0, stringFormat);
                }
                else
                {
                    #region 画彩色验证码。
                    System.Drawing.Region[] rgs = g.MeasureCharacterRanges(VerifyCodeText, font, new System.Drawing.RectangleF(0, 0, size.Width, size.Height), stringFormat);
                    int minR, maxR, minG, maxG, minB, maxB;

                    minR = this.ForeColor.R - 160;
                    if (minR < 0) minR = 0;
                    maxR = minR + 160;
                    if (maxR > 255) maxR = 255;

                    minG = this.ForeColor.G - 160;
                    if (minG < 0) minG = 0;
                    maxG = minG + 160;
                    if (maxG > 255) maxG = 255;

                    minB = this.ForeColor.B - 160;
                    if (minB < 0) minB = 0;
                    maxB = minB + 160;
                    if (maxB > 255) maxB = 255;

                    float x = 0;
                    for (int i = 0; i < VerifyCodeText.Length; i++)
                    {
                        char ch = VerifyCodeText[i];
                        int cr, cg, cb;
                        cr = rand.Next(minR, maxR);
                        cg = rand.Next(minG, maxG);
                        cb = rand.Next(minB, maxB);
                        //int l;
                        //do
                        //{
                        //    cr = rand.Next(0, 255);
                        //    cg = rand.Next(0, 255);
                        //    cb = rand.Next(0, 255);
                        //    l = (cr - this.BackColor.R) ^ 2 + (cg - this.BackColor.G) ^ 2 + (cb - this.BackColor.B) ^ 2;
                        //}
                        //while (l > 100 || l < -100);
                        System.Drawing.SolidBrush brush = new System.Drawing.SolidBrush(System.Drawing.Color.FromArgb(cr, cg, cb));

                        //System.Drawing.SolidBrush brush = new System.Drawing.SolidBrush(this.ForeColor);
                        g.DrawString(ch.ToString(), font, brush, x, 0, stringFormat);
                        if (ch >= 0 && ch <= 255)
                        {
                            x += font.Size / 2 + 2;
                        }
                        else
                        {
                            x += font.Size + 2;
                        }
                    }
                    #endregion
                }
                g.Flush();
            }
            #endregion

            #region 填充杂色。
            if (!this.ColorText)
            {
                float p1 = size.Width * size.Height * this.Pinto;
                for (int i = 0; i < p1; i++)
                {
                    int x = rand.Next(size.Width);
                    int y = rand.Next(size.Height);
                    bitmap.SetPixel(x, y, LinePen.Color);
                }
            }
            float p2 = size.Width * size.Height * 0.01F * this.Pinto;
            for (int i = 0; i < p2; i++)
            {
                int x1 = rand.Next(size.Width);
                int y1 = rand.Next(size.Height);
                int x2 = rand.Next(size.Width);
                int y2 = rand.Next(size.Height);
                g.DrawLine(LinePen, x1, y1, x2, y2);

            }
            #endregion

            return bitmap;

        }

		/// <summary>
		/// 初始化此实例。
		/// </summary>
		public VerifyCode()
		{

		}


        protected override void OnPreRender(EventArgs e)
        {
			if (this.Page.Request["VerifyCodeRefreshTime"] == null || this.Page.Request["VerifyCodeRefreshTime"] == "")
            {
				string VerifyCodeURL = SetUriParameter(this.Page.Request.Url.ToString(), "VerifyCodeID", this.ClientID);
				VerifyCodeURL = SetUriParameter(VerifyCodeURL, "VerifyCodeRefreshTime", System.DateTime.Now.Ticks.ToString());
				this.ImageUrl = VerifyCodeURL;
            }
			else if (this.Page.Request["VerifyCodeID"].ToLower() == this.ClientID.ToLower())
            {
                this.Page.Response.Clear();
				string generateVerifyCode = this.GenerateVerifyCodeString();
				this._VerifyCode = EncryptPassword(generateVerifyCode);
                //if (this.IsTrackingViewState)
                {
					this.Page.Session["VerifyCode" + this.Page.Request["VerifyCodeID"]] = this._VerifyCode;
                }


                this.Page.Response.ContentType = "application/octet-stream";
				this.GenerateVerifyCodeImage(this._VerifyCode).Save(this.Page.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                this.Page.Response.End();
            }

        }

        /// <summary>
        /// 为指定的 URI 设置参数。
        /// </summary>
        /// <param name="uri">一个可能包含参数的 uri 字符串。</param>
        /// <param name="Name">参数名。</param>
        /// <param name="Value">新的参数值。</param>
        /// <returns>已经设置了指定参数名和参数值的 uri 字符串。</returns>
        /// <remarks>
        /// 如果指定的参数存在，则更改参数值为指定的新的参数值，否则，添加一个具有指定参数名和新的参数值的参数。
        /// </remarks>
        /// <example>
        /// </para>
        /// <para lang="C#">
        /// 输出结果：
        /// </para>
        /// </example>
        private static string SetUriParameter(string uri, string Name, string Value)
        {
            string result = uri.Trim().TrimEnd('?');//消除 URI 中无参数但存在问号“...?”这种 URI 中的问号。
            int queryIndex = result.IndexOf('?');
            if (queryIndex == -1)
            {//如果无参数。
                return result + "?" + Name + "=" + System.Web.HttpUtility.UrlEncode(Value);
            }
            else
            {//如果有参数。
                string urlRegStr = "(?<spl>\\?|&)" + Name + "=([^&]*)";//测试可能被替换的参数的正则表达式。
                if (System.Text.RegularExpressions.Regex.IsMatch(
                    result
                    , urlRegStr
                    , System.Text.RegularExpressions.RegexOptions.IgnoreCase | System.Text.RegularExpressions.RegexOptions.ExplicitCapture
                    ))
                {//如果存在同名参数。
                    return System.Text.RegularExpressions.Regex.Replace(
                        result, urlRegStr
                        , "${spl}" + Name + "=" + System.Web.HttpUtility.UrlEncode(Value)
                        , System.Text.RegularExpressions.RegexOptions.IgnoreCase | System.Text.RegularExpressions.RegexOptions.ExplicitCapture
                        );
                }
                else
                {//如果无同名参数。
                    return result + "&" + Name + "=" + System.Web.HttpUtility.UrlEncode(Value);
                }
            }

        }

    }
}

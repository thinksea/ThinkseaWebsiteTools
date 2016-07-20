using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Thinksea.WebsiteTools
{
    /// <summary>
    /// 此类封装了通用的预定义功能。
    /// </summary>
    public sealed class Define
    {
        /// <summary>
        /// 一个构造方法。
        /// </summary>
        static Define()
        {
        }

        /// <summary>
        /// 获取一个 Cookie。
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public static string GetCookie(string cookieName, string name)
        {
            HttpCookie hc = System.Web.HttpContext.Current.Request.Cookies[cookieName];
            if (hc == null)
            {
                return null;
            }
            return HttpUtility.UrlDecode(hc[name]);
        }

        /// <summary>
        /// 设置一个 Cookie。
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="name"></param>
        /// <param name="value"></param>
        public static void SetCookie(string cookieName, string name, string value)
        {
            HttpCookie hc = System.Web.HttpContext.Current.Response.Cookies[cookieName];
            if (hc == null)
            {
                hc.Secure = true;
                hc.HttpOnly = true;
                //hc.Expires = System.DateTime.Now.AddHours(1);
            }
            hc[name] = HttpUtility.UrlEncode(value);
        }

        /// <summary>
        /// 验证用户是否已经登陆。
        /// </summary>
        public static void CheckLogin()
        {
            string oIsAuthenticated = Define.GetCookie("ThinkseaWebsiteTools", "IsAuthenticated");
            if (oIsAuthenticated == null || !System.Convert.ToBoolean(oIsAuthenticated))
            {
                System.Web.HttpContext.Current.Response.Redirect("Login.aspx?ReturnUrl=" + System.Web.HttpContext.Current.Request.Url.ToString());
                return;
            }
        }

        /// <summary>
        /// 设置用户登陆状态。
        /// </summary>
        public static void SetLogin()
        {
            Define.SetCookie("ThinkseaWebsiteTools", "IsAuthenticated", "true");
        }

        /// <summary>
        /// 设置用户登出状态。
        /// </summary>
        public static void SetLogout()
        {
            Define.SetCookie("ThinkseaWebsiteTools", "IsAuthenticated", "false");
            System.Web.HttpContext.Current.Response.Redirect("Login.aspx");
        }

        /// <summary>
        /// 将文件长度转换为以合适的单位（“TB”、“GB”、“MB”、“KB”、“B”）表示形式的文本。
        /// </summary>
        /// <param name="Length">以字节“B”为单位的文件长度。</param>
        /// <returns>表示文件长度的带有单位的字符串。</returns>
        /// <example>
        /// <para lang="C#">
        /// 下面的代码演示了如何使用这个方法：
        /// </para>
        /// <code lang="C#">
        /// <![CDATA[System.Console.WriteLine(ConvertToFileSize(11));
        /// System.Console.WriteLine(ConvertToFileSize(12989));
        /// System.Console.WriteLine(ConvertToFileSize(1726752));
        /// System.Console.WriteLine(ConvertToFileSize(1526725236));
        /// System.Console.WriteLine(ConvertToFileSize(95393296753236));
        /// ]]>
        /// </code>
        /// <para lang="C#">
        /// 输出结果：
        /// <br/>11 B
        /// <br/>12.68 KB
        /// <br/>1.65 MB
        /// <br/>1.42 GB
        /// <br/>86.76 TB
        /// </para>
        /// </example>
        public static string ConvertToFileSize(long Length)
        {
            long KB = 1024;
            long MB = KB * 1024;
            long GB = MB * 1024;
            long TB = GB * 1024;

            if (Length >= TB)
            {
                return (((double)Length) / ((double)TB)).ToString("0.##") + " TB";
            }
            else
            {
                if (Length >= GB)
                {
                    return (((double)Length) / ((double)GB)).ToString("0.##") + " GB";
                }
                else
                {
                    if (Length >= MB)
                    {
                        return (((double)Length) / ((double)MB)).ToString("0.##") + " MB";
                    }
                    else
                    {
                        if (Length >= KB)
                        {
                            return (((double)Length) / ((double)KB)).ToString("0.##") + " KB";
                        }
                        else
                        {
                            return Length.ToString("0.##") + " B";
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 将指定的文本转换为 JavaScript 字符串。
        /// </summary>
        /// <param name="str">待转换字符串。</param>
        /// <returns>符合 JavaScript 规则的字符串。此返回结果可以直接与双引号或单引号串联构成标准的 JavaScript 字符串。</returns>
        /// <example>
        /// <para lang="C#">
        /// <![CDATA[
        /// 下面的代码演示了如何使用这个方法转换“<a'b"c>”：
        /// ]]>
        /// </para>
        /// <code lang="C#">
        /// <![CDATA[this.Response.Write(Thinksea.Web.ConvertToJavaScriptString("<a'b\"c>"));
        /// ]]>
        /// </code>
        /// <para lang="C#">
        /// 输出结果：
        /// <br/>
        /// <![CDATA[
        /// <a\'b\"c>
        /// ]]>
        /// </para>
        /// </example>
        public static string ConvertToJavaScriptString(string str)
        {
            return str.Replace("\\", "\\\\").Replace("'", "\\'").Replace("\"", "\\\"").Replace("\r", "\\r").Replace("\n", "\\n");

        }

        /// <summary>
        /// 按 path 的指定创建所有目录和子目录。
        /// </summary>
        /// <param name="path">要创建的目录路径。</param>
        public static void CreateDirectory(string path)
        {
            if (!System.IO.Directory.Exists(path))
            {
                System.IO.Directory.CreateDirectory(path);
            }

        }

    }


    /// <summary>
    /// Zip 的摘要说明。
    /// </summary>
    public class TZip
    {
        public TZip()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        /// <summary>
        /// 新建压缩文档输出流。
        /// </summary>
        /// <param name="CompressFileName">压缩包文件全名。</param>
        /// <param name="Password">文档压缩密码。</param>
        /// <param name="bufferSize">所需的缓冲区大小（以字节为单位）。对于 0 和 8 之间的 bufferSize 值，缓冲区的实际大小设置为 8 字节。</param>
        /// <returns>创建压缩文件输出流。</returns>
        public static ICSharpCode.SharpZipLib.Zip.ZipOutputStream CreatZipFileOutputStream(string CompressFileName, string Password, int bufferSize)
        {
            System.IO.FileStream stream = new System.IO.FileStream(CompressFileName, System.IO.FileMode.Create, System.IO.FileAccess.Write, System.IO.FileShare.None, bufferSize);
            try
            {
                ICSharpCode.SharpZipLib.Zip.ZipOutputStream outputStream = new ICSharpCode.SharpZipLib.Zip.ZipOutputStream(stream);//压缩文档操作流。
                if (Password != string.Empty)
                {
                    outputStream.Password = Password;//设置压缩密码。
                }
                outputStream.SetLevel(ICSharpCode.SharpZipLib.Zip.Compression.Deflater.BEST_COMPRESSION);//设置压缩级别。

                return outputStream;

            }
            catch
            {
                stream.Close();
                throw;
            }

        }

        /// <summary>
        /// 压缩文件集合到指定的文件输出流。
        /// </summary>
        /// <param name="zipFileOutputStream">指示压缩文件输出流。</param>
        /// <param name="Files">待压缩文件集合。</param>
        /// <param name="SplitPath">要删除的在文件集合中共有的路径前缀。</param>
        /// <param name="bufferSize">所需的缓冲区大小（以字节为单位）。对于 0 和 8 之间的 bufferSize 值，缓冲区的实际大小设置为 8 字节。</param>
        public static void ZipFiles(ICSharpCode.SharpZipLib.Zip.ZipOutputStream zipFileOutputStream, string[] Files, string SplitPath, int bufferSize)
        {
            if (bufferSize < 8) bufferSize = 8;

            byte[] transferBuffer = new byte[bufferSize];//定义用于传输数据的缓存。

            foreach (string tmpFilePath in Files)
            {
                string entryPath = tmpFilePath.Substring(SplitPath.Length);//计算文件存储在压缩包中的路径全名。
                entryPath = entryPath.Replace('\\', '/').TrimStart('/');//删除前导路径符，确保以相对文件名压缩存档。

                #region 开始压缩文件。
                ICSharpCode.SharpZipLib.Zip.ZipEntry entry = new ICSharpCode.SharpZipLib.Zip.ZipEntry(entryPath);//新建压缩头。
                entry.CompressionMethod = ICSharpCode.SharpZipLib.Zip.CompressionMethod.Deflated;//设置压缩模式。

                #region 保存待压缩文件属性。
                System.IO.FileInfo fileInfo = new System.IO.FileInfo(tmpFilePath);
                entry.DateTime = fileInfo.LastWriteTime;//文件最后修改时间。
                entry.ExternalFileAttributes = (int)fileInfo.Attributes;//文件属性。
                entry.Size = fileInfo.Length;//文件大小。
                #endregion

                using (System.IO.FileStream fileStream = new System.IO.FileStream(tmpFilePath, System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.Read, bufferSize))//打开待压缩文件流。
                {
                    try
                    {
                        zipFileOutputStream.PutNextEntry(entry);//写文件头到压缩流。
                        #region 写压缩文件内容到压缩文件流。
                        int bytesRead;
                        do
                        {
                            bytesRead = fileStream.Read(transferBuffer, 0, transferBuffer.Length);//从待压缩文件读数据块到缓存。
                            zipFileOutputStream.Write(transferBuffer, 0, bytesRead);//将缓存中的数据块写入压缩流。
                        }
                        while (bytesRead > 0);
                        #endregion
                    }
                    finally
                    {
                        fileStream.Close();
                    }
                }
                #endregion

            }

        }

        /// <summary>
        /// 压缩目录集合到指定的文件输出流。
        /// </summary>
        /// <param name="zipFileOutputStream">指示压缩文件输出流。</param>
        /// <param name="Directories">待添加目录集合（包含路径全名）。</param>
        /// <param name="SplitPath">要添加的在目录集合中共有的路径前缀。</param>
        public static void ZipDirectories(ICSharpCode.SharpZipLib.Zip.ZipOutputStream zipFileOutputStream, string[] Directories, string SplitPath)
        {
            foreach (string tmpDirectoryPath in Directories)
            {
                string entryPath = tmpDirectoryPath.Substring(SplitPath.Length);//计算目录存储在压缩包中的路径全名。
                entryPath = entryPath.Replace('\\', '/').TrimStart('/');//删除前导路径符，确保以相对目录名压缩存档。

                if (entryPath.Length == 0 || entryPath.EndsWith("/") == false)
                {
                    entryPath = entryPath + "/";
                }

                ICSharpCode.SharpZipLib.Zip.ZipEntry zipEntry = new ICSharpCode.SharpZipLib.Zip.ZipEntry(entryPath);
                zipEntry.CompressionMethod = ICSharpCode.SharpZipLib.Zip.CompressionMethod.Deflated;//设置压缩模式。

                #region 保存待压缩文件属性。
                System.IO.DirectoryInfo directoryInfo = new System.IO.DirectoryInfo(tmpDirectoryPath);
                zipEntry.DateTime = directoryInfo.LastWriteTime;//文件最后修改时间。
                zipEntry.ExternalFileAttributes = (int)directoryInfo.Attributes;//文件属性。
                #endregion

                zipFileOutputStream.PutNextEntry(zipEntry);
            }

        }

        /// <summary>
        /// 如果压缩目标是目录，则压缩指定目录下的文件到指定的文件输出流。包含子文件夹。
        /// </summary>
        /// <param name="CompressFileName">压缩包文件全名。</param>
        /// <param name="Files">待压缩目标集合。</param>
        /// <param name="Password">文档压缩密码。</param>
        /// <param name="bufferSize">所需的缓冲区大小（以字节为单位）。</param>
        /// <returns>成功压缩的文件数量。</returns>
        public static int ZipDir(string CompressFileName, string[] Files, string Password, int bufferSize)
        {
            int count = 0;
            if (Files.Length > 0)
            {
                using (ICSharpCode.SharpZipLib.Zip.ZipOutputStream zipFileOutputStream = CreatZipFileOutputStream(CompressFileName, Password, bufferSize))
                {
                    try
                    {
                        foreach (string Path in Files)
                        {
                            if (System.IO.File.Exists(Path))//如果待压缩目标是一文件。
                            {
                                ZipFiles(zipFileOutputStream, new string[] { Path }, System.IO.Path.GetDirectoryName(Path), 1024 * 1024);
                                count++;
                            }
                            else
                            {
                                if (System.IO.Directory.Exists(Path))
                                {
                                    count++;
                                    string[] dirs = System.IO.Directory.GetDirectories(Path, "*.*", System.IO.SearchOption.AllDirectories);
                                    string[] subfiles = System.IO.Directory.GetFiles(Path, "*.*", System.IO.SearchOption.AllDirectories);
                                    //string[][] fileSystemList = SearchFilesSystem(Path);//计算待压缩文件列表。
                                    ZipDirectories(zipFileOutputStream, dirs, System.IO.Path.GetDirectoryName(Path));
                                    ZipFiles(zipFileOutputStream, subfiles, System.IO.Path.GetDirectoryName(Path), 1024 * 1024);
                                    count += dirs.Length;
                                    count += subfiles.Length;
                                }
                            }
                        }
                    }
                    finally
                    {
                        zipFileOutputStream.Close();
                    }
                }
            }
            return count;
        }

        /// <summary>
        /// 解压缩一个压缩文档。
        /// </summary>
        /// <param name="CompressFileName">待解压缩的文件。</param>
        /// <param name="targetDir">解压输出目录。</param>
        /// <param name="Password">文档压缩密码。</param>
        /// <param name="overwriteFiles">指示是否用解压后的文件覆盖解压输出目录下的同名文件。</param>
        /// <param name="bufferSize">所需的缓冲区大小（以字节为单位）。对于 0 和 8 之间的 bufferSize 值，缓冲区的实际大小设置为 8 字节。</param>
        /// <returns>返回成功解压缩的文件数量。</returns>
        public static int Decompress(string CompressFileName, string targetDir, string Password, bool overwriteFiles, int bufferSize)
        {
            int totalEntries = 0;

            if (bufferSize < 8) bufferSize = 8;

            byte[] transferBuffer = new byte[bufferSize];//定义用于传输数据的缓存。

            using (System.IO.FileStream stream = new System.IO.FileStream(CompressFileName, System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.Read, bufferSize))//打开解压缩输入文件流。
            {
                try
                {
                    using (ICSharpCode.SharpZipLib.Zip.ZipInputStream inputStream = new ICSharpCode.SharpZipLib.Zip.ZipInputStream(stream)) //压缩文档操作流。
                    {
                        try
                        {
                            inputStream.Password = Password;//设置解压缩密码。

                            #region 循环解压缩全部文档。
                            ICSharpCode.SharpZipLib.Zip.ZipEntry theEntry;
                            while ((theEntry = inputStream.GetNextEntry()) != null)
                            {
                                string entryFileName = "";//解压缩文件在压缩文档中的存储名。
                                string targetFullName = "";//解压缩文件存储全名。
                                string targetDirectoryPath = "";//解压缩文件存储目录。

                                #region 计算解压缩参数。
                                if (System.IO.Path.IsPathRooted(theEntry.Name))
                                {
                                    entryFileName = System.IO.Path.Combine(System.IO.Path.GetDirectoryName(theEntry.Name), System.IO.Path.GetFileName(theEntry.Name));
                                }
                                else
                                {
                                    entryFileName = theEntry.Name;
                                }

                                targetFullName = System.IO.Path.GetFullPath(System.IO.Path.Combine(targetDir, entryFileName));
                                targetDirectoryPath = System.IO.Path.GetDirectoryName(targetFullName);
                                #endregion

                                if (theEntry.IsDirectory)
                                {
                                    if (overwriteFiles == true || System.IO.Directory.Exists(targetFullName) == false)
                                    {
                                        //System.IO.Directory.CreateDirectory( targetFullName );
                                        Thinksea.WebsiteTools.Define.CreateDirectory(targetFullName);
                                        System.IO.Directory.SetLastWriteTime(targetFullName, theEntry.DateTime);
                                        totalEntries++;
                                    }

                                }
                                else
                                {
                                    if (overwriteFiles == false && System.IO.File.Exists(targetFullName) == true)
                                    {
                                        continue;
                                    }

                                    if (entryFileName.Length > 0)
                                    {
                                        #region 确保解压缩目录存在。
                                        if (System.IO.Directory.Exists(targetDirectoryPath) == false)
                                        {
                                            //System.IO.Directory.CreateDirectory(targetDirectoryPath);
                                            Thinksea.WebsiteTools.Define.CreateDirectory(targetDirectoryPath);
                                        }
                                        #endregion

                                        #region 解压缩一个文档。
                                        using (System.IO.FileStream streamWriter = new System.IO.FileStream(targetFullName, System.IO.FileMode.Create, System.IO.FileAccess.Write, System.IO.FileShare.None, bufferSize))//打开解压缩输出文件流。
                                        {
                                            try
                                            {
                                                streamWriter.SetLength(theEntry.Size);
                                                int bytesRead;
                                                do
                                                {
                                                    bytesRead = inputStream.Read(transferBuffer, 0, transferBuffer.Length);//从压缩文档读数据块到缓存。
                                                    streamWriter.Write(transferBuffer, 0, bytesRead);//将缓存中的数据块写入解压缩文件流。
                                                }
                                                while (bytesRead > 0);

                                            }
                                            finally
                                            {
                                                streamWriter.Close();
                                            }

                                        }
                                        #endregion

                                        #region 恢复文档属性。
                                        System.IO.File.SetLastWriteTime(targetFullName, theEntry.DateTime);
                                        //File.SetAttributes(targetFullName, (System.IO.FileAttributes)(theEntry.ExternalFileAttributes));
                                        #endregion

                                        totalEntries++;

                                    }

                                }

                            }
                            #endregion
                        }
                        finally
                        {
                            inputStream.Close();
                        }
                    }
                }
                finally
                {
                    stream.Close();
                }
            }

            return totalEntries;

        }


    }

}
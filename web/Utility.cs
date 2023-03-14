namespace web
{
    public class Utility
    {
        public static String MapPath(string path)
        {
            return AppDomain.CurrentDomain.GetData("root") + "\\" + path;
        }
    }
}

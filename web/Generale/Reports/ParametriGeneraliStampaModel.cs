namespace web.Generale.Reports
{
    public class ParametriGeneraliStampaModel
    {

        public static string ORIENTAMENTO_VERTICALE = "V";
        public static string ORIENTAMENTO_ORIZZONTALE = "O";

        public static string DIMENSIONE_A4 = "A4";
        public static string DIMENSIONE_A5 = "A5";
        public static string DIMENSIONE_A6 = "A6";

        public string? Orientamento { get; set; }

        public string? DimensionePagina { get; set; }

        public int? Id_stampante { get; set; }

        public int? Quantita { get; set; }

    }
}

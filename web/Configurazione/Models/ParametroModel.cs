using System.Data.SqlClient;
using web.Generale;

namespace web.Configurazione.Models
{
    public class ParametroModel : BasicModel
    {
       
        public string? Cod_parametro { get; set; }

        public string? Desc_parametro { get; set; }
        public string? Valore { get; set; }


        public ParametroModel()
        {
            NomeTabella = "parametro";

        }
        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);

            Cod_parametro = GetString(reader, nameof(Cod_parametro));
            Desc_parametro = GetString(reader, nameof(Desc_parametro));
            Valore = GetString(reader, nameof(Valore));
        }
    }


    public class Parametro
    {
        public static readonly string PERMETTI_ALLOCAZIONE_SFUSO = "ALSFU";
        public static readonly string USA_ETICHETTE_UDC_ESTERNE = "ETEST";
        public static readonly string ACCETTA_ARTICOLI_NO_LISTA = "ARTNL";
        public static readonly string PERMETTI_PRELIEVO_SENZA_ASSEGNAZIONE = "NOASS";
        public static readonly string PERIODO_MOVIMENTAZIONI = "PERMO";
    }
}

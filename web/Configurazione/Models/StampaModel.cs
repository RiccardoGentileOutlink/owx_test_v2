using System.Data.SqlClient;
using web.Generale;

namespace web.Configurazione.Models
{
    public class StampaModel : BasicModel
    {
        public int Id_stampa { get; set; }
        public string? Cod_stampa { get; set; }
        public string? Desc_stampa { get; set; }
        public int? Id_stampante_def { get; set; }

        public StampanteModel? Stampante_def { get; set; }


        public StampaModel()
        {
            NomeTabella = "stampa";
        }

        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);

           Id_stampa = GetIntNonNullable(reader, nameof(Id_stampa));
            Cod_stampa = GetString(reader, nameof(Cod_stampa));
            Desc_stampa = GetString(reader, nameof(Desc_stampa));
            Id_stampante_def = GetInt(reader, nameof(Id_stampante_def));

            Stampante_def = new StampanteModel();
            Stampante_def.FromReader(reader);

        }
    }
}

using System.Data.SqlClient;
using web.Generale;

namespace web.Autenticazione.Models
{
    public class AziendaModel : BasicModel
    {
        public AziendaModel()
        {
            NomeTabella = "azienda";
            GestioneAzienda = false;
        }

        //esiste già di default nella superclasse la proprietà Id_azienda
        //public int Id_azienda { get; set; }

        public String? Ragione_sociale { get; set; }
        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);


            Id_azienda = GetInt(reader, nameof(Id_azienda));
            Ragione_sociale = GetString(reader, nameof(Ragione_sociale));
        }
    }
}
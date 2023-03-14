using System.Data.SqlClient;
using web.Generale;

namespace web.Configurazione.Models
{
    public class StampanteModel : BasicModel
    {
        public int Id_stampante { get; set; }
       
        public string? Nome_stampante { get; set; }
        public string? Desc_stampante { get; set; }
      

        public StampanteModel()
        {
            NomeTabella = "stampante";
        }

        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);

            Id_stampante = GetIntNonNullable(reader,nameof(Id_stampante));
            Nome_stampante = GetString(reader, nameof(Nome_stampante));
            Desc_stampante = GetString(reader, nameof(Desc_stampante));
        }
    }
}

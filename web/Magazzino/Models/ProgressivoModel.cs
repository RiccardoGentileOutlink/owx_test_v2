using System.Data.SqlClient;
using web.Generale;

namespace web.Magazzino.Models
{
    public class ProgressivoModel : BasicModel
    {
        public int Id_progressivo { get; set; }
       
        public string? Cod_progressivo { get; set; }
        public string? Desc_progressivo { get; set; }
        public int? Anno { get; set; }
        public int Contatore { get; set; }
      
        public ProgressivoModel()
        {
            NomeTabella = "progressivo";
        }

        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);
            Id_progressivo = GetIntNonNullable(reader, nameof(Id_progressivo));
            Cod_progressivo = GetString(reader, nameof(Cod_progressivo));
            Desc_progressivo = GetString(reader, nameof(Desc_progressivo));
            Anno = GetInt(reader, nameof(Anno));
            Contatore = GetIntNonNullable(reader, nameof(Contatore));

        }
    }
}

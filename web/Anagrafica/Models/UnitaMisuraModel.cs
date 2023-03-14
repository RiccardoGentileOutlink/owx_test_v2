using System.Data.SqlClient;
using web.Generale;

namespace web.Anagrafica.Models
{
    public class UnitaMisuraModel : BasicModel
    {
        public int Id_unita_misura { get; set; }
        public string? Cod_unita_misura { get; set; }
        public string? Desc_unita_misura { get; set; }
       

        public UnitaMisuraModel()
        {
            NomeTabella = "unita_misura";
        }

        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);
            Id_unita_misura = GetIntNonNullable(reader, nameof(Id_unita_misura));
            Cod_unita_misura = GetString(reader, nameof(Cod_unita_misura));
            Desc_unita_misura = GetString(reader, nameof(Desc_unita_misura));
           
        }
    }
}

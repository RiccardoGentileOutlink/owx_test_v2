using System.Data.SqlClient;
using System.Security.Policy;
using web.Generale;

namespace web.Magazzino.Models
{
   
    public class MontanteModel : BasicModel
    {
        public int Id_montante { get; set; }
        public string? Cod_montante { get; set; }
        public string? Desc_montante { get; set; }
        public string? Cod_alias { get; set; }
        public int? Id_magazzino { get; set; }
        public int? Id_zona { get; set; }
        public int? Id_corridoio { get; set; }


        public CorridoioModel? Corridoio { get; set; }

        public MontanteModel()
        {
            NomeTabella = "montante";
            GestioneAzienda = false;
            GestioneLogUtenti = false;
        }

      

        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);
            Id_montante = GetIntNonNullable(reader, nameof(Id_montante));
            Cod_montante = GetString(reader, nameof(Cod_montante));
            Desc_montante = GetString(reader, nameof(Desc_montante));
            Cod_alias = GetString(reader, nameof(Cod_alias));
            Id_magazzino = GetInt(reader, nameof(Id_magazzino));
            Id_zona = GetInt(reader, nameof(Id_zona));
            Id_corridoio = GetInt(reader, nameof(Id_corridoio));

            Corridoio = new CorridoioModel();
            Corridoio.FromReader(reader);
        }
    }
}

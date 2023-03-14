using System.Data.SqlClient;
using web.Generale;

namespace web.Magazzino.Models
{
   
    public class CorridoioModel : BasicModel
    {
        public int Id_corridoio { get; set; }
        public string? Cod_corridoio { get; set; }
        public string? Desc_corridoio { get; set; }
        public string? Cod_alias { get; set; }
        public int Id_magazzino { get; set; }
        public int Id_zona { get; set; }


        // MagazzinoModel? magazzino; IL MAGAZZINO E' GIA DENTRO A ZONA MODEL QUINDI QUA SAREBBE RIDONDANTE
        public ZonaModel? Zona { get; set; }
        public CorridoioModel()
        {
            NomeTabella = "corridoio";
            GestioneAzienda = false;
            GestioneLogUtenti = false;
        }

       
        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);
            Id_corridoio = GetIntNonNullable(reader, nameof(Id_corridoio));
            Cod_corridoio = GetString(reader, nameof(Cod_corridoio));
            Desc_corridoio = GetString(reader, nameof(Desc_corridoio));
            Cod_alias = GetString(reader, nameof(Cod_alias));
            Id_magazzino = GetIntNonNullable(reader, nameof(Id_magazzino));
            Id_zona = GetIntNonNullable(reader, nameof(Id_zona));

            Zona = new ZonaModel();
            Zona.FromReader(reader);

            
        }
    }
}

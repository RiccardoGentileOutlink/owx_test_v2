using System.Data.SqlClient;
using web.Generale;

namespace web.Magazzino.Models
{
   
    public class ZonaModel: BasicModel
    {
        public int Id_zona { get; set; }
        public string? Cod_zona { get; set; }
        public string? Desc_zona { get; set; }
        public string? Cod_alias { get; set; }
        public int Id_magazzino { get; set; }


        public MagazzinoModel? Magazzino { get; set; }

        public ZonaModel()
        {
            NomeTabella = "zona";
            GestioneAzienda = false;
            GestioneLogUtenti = false;
        }

       

        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);

            Id_zona = GetIntNonNullable(reader, nameof(Id_zona));
            Cod_zona = GetString(reader, nameof(Cod_zona));
            Desc_zona = GetString(reader, nameof(Desc_zona));
            Cod_alias = GetString(reader, nameof(Cod_alias));
            Id_magazzino = GetIntNonNullable(reader, nameof(Id_magazzino));

            Magazzino = new MagazzinoModel();
            Magazzino.FromReader(reader);


        }



    }
}

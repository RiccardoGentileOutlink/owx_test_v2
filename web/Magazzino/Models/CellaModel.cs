using System.Data.SqlClient;
using web.Generale;

namespace web.Magazzino.Models
{

    public class CellaModel : BasicModel
    {
        public int Id_cella { get; set; }
        public string? Cod { get; set; }
        public string? Cod_cella { get; set; }
        public string? Desc_cella { get; set; }
        public string? Cod_alias { get; set; }
        public int? Id_magazzino { get; set; }
        public int? Id_zona { get; set; }
        public int? Id_corridoio { get; set; }
        public int? Id_montante { get; set; }
        public int? Id_piano { get; set; }
        public string? Sessione { get; set; }
        public int? Ordinamento { get; set; }

        public  PianoModel? Piano { get; set; }

        public CellaModel()
        {
            NomeTabella = "cella";
            GestioneLogUtenti = false;
        }
        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);

            Id_cella = GetIntNonNullable(reader, nameof(Id_cella));
            Cod = GetString(reader, nameof(Cod));
            Cod_cella = GetString(reader, nameof(Cod_cella));
            Desc_cella = GetString(reader, nameof(Desc_cella));
            Cod_alias = GetString(reader, nameof(Cod_alias));
            Id_magazzino = GetInt(reader, nameof(Id_magazzino));
            Id_zona = GetInt(reader, nameof(Id_zona));
            Id_corridoio = GetInt(reader, nameof(Id_corridoio));
            Id_montante = GetInt(reader, nameof(Id_montante));
            Id_piano = GetInt(reader, nameof(Id_piano));
            Sessione = GetString(reader, nameof(Sessione));
            Ordinamento = GetInt(reader, nameof(Ordinamento));

            Piano = new PianoModel();
            Piano.FromReader(reader);

        }
    }
}

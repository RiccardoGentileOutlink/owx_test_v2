using System.Data.SqlClient;
using web.Generale;

namespace web.Magazzino.Models
{
    
    public class PianoModel:BasicModel
    {
        public int Id_piano { get; set; }
        public string? Cod_piano { get; set; }
        public string? Desc_piano { get; set; }
        public string? Cod_alias { get; set; }
        public int? Id_magazzino { get; set; }
        public int? Id_zona { get; set; }
        public int? Id_corridoio { get; set; }
        public int? Id_montante { get; set; }

        public MontanteModel? Montante { get; set; }

        public PianoModel()
        {
            NomeTabella = "piano";
            GestioneAzienda = false;
            GestioneLogUtenti = false;
        }

       

        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);
            Id_piano  = GetIntNonNullable(reader, nameof(Id_piano));
            Cod_piano = GetString(reader, nameof(Cod_piano));
            Desc_piano = GetString(reader, nameof(Desc_piano));
            Cod_alias = GetString(reader, nameof(Cod_alias));
            Id_magazzino = GetInt(reader, nameof(Id_magazzino));
            Id_zona = GetInt(reader, nameof(Id_zona));
            Id_corridoio = GetInt(reader, nameof(Id_corridoio));
            Id_montante = GetInt(reader, nameof(Id_montante));

            Montante = new MontanteModel();
            Montante.FromReader(reader);
        }
    }
}

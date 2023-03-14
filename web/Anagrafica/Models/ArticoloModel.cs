using System.Data.SqlClient;
using System.Diagnostics;
using web.Generale;

namespace web.Anagrafica.Models
{
    public class ArticoloModel : BasicModel
    {
        public int Id_articolo { get; set; }
        public string? Cod_articolo { get; set; }
        public string? Desc_articolo { get; set; }
        public int Id_unita_misura { get; set; }
        public decimal? Peso { get; set; }
        public decimal? Altezza { get; set; }
        public decimal? Larghezza { get; set; }
        public decimal? Profondita { get; set; }
        public decimal? Volume { get; set; }
        public string? Indice_rotazione { get; set; }
        public int? Num_movimenti { get; set; }
        public int? Qta_movimenti { get; set; }
        public int? Pezzi_per_confezione { get; set; }
        public int? Id_articolo_padre { get; set; }
        public string? Nota_articolo { get; set; }
        public bool? Obsoleto { get; set; }

        public UnitaMisuraModel? Unita_misura { get; set; }

        public ArticoloModel? Articolo_padre { get; set; }


        public ArticoloModel()
        {
            NomeTabella = "articolo";
        }

        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);
            Id_articolo = GetIntNonNullable(reader, nameof(Id_articolo));
            Cod_articolo = GetString(reader, nameof(Cod_articolo));
            Desc_articolo = GetString(reader, nameof(Desc_articolo));
            Id_unita_misura = GetIntNonNullable(reader, nameof(Id_unita_misura));
            Peso = GetDecimal(reader, nameof(Peso));
            Altezza = GetDecimal(reader, nameof(Altezza));
            Larghezza = GetDecimal(reader, nameof(Larghezza));
            Profondita = GetDecimal(reader, nameof(Profondita));
            Volume = GetDecimal(reader, nameof(Volume));
            Indice_rotazione = GetString(reader, nameof(Indice_rotazione));
            Num_movimenti = GetInt(reader, nameof(Num_movimenti));
            Qta_movimenti = GetInt(reader, nameof(Qta_movimenti));
            Pezzi_per_confezione = GetInt(reader, nameof(Pezzi_per_confezione));
            Id_articolo_padre = GetInt(reader, nameof(Id_articolo_padre));
            Nota_articolo = GetString(reader, nameof(Nota_articolo));
            Obsoleto = GetBoolean(reader, nameof(Obsoleto));

            Unita_misura = new UnitaMisuraModel();
            Unita_misura.FromReader(reader);

            //L'articolo padre viene aggiunto all'occorrenza dal controller perchè sarebbe troppo dispensioso aggiugerlo sempre con tutti i campi 
            //collegati (Esempio Unita di misura). Vedi GestoreArticolo.GetArticoli


        }
    }


  

}

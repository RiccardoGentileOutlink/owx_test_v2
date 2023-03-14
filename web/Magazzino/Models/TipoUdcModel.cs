using System.Data.SqlClient;
using web.Generale;

namespace web.Magazzino.Models
{
    public class TipoUdcModel : BasicModel
    {
        public int Id_tipo_udc { get; set; }

        public string? Cod_tipo_udc { get; set; }

        public string? Desc_tipo_udc { get; set; }

        public bool Uscita { get; set; }


        public TipoUdcModel()
        {
            NomeTabella = "tipo_udc";
        }



        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);

            Id_tipo_udc = GetIntNonNullable(reader, nameof(Id_tipo_udc));
            Cod_tipo_udc = GetString(reader, nameof(Cod_tipo_udc));
            Desc_tipo_udc = GetString(reader, nameof(Desc_tipo_udc));
            Uscita = GetBoolean(reader, nameof(Uscita))??false;
        }
    }
}

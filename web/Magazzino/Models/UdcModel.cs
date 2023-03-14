using System.Data.SqlClient;
using web.Generale;

namespace web.Magazzino.Models
{
    public class UdcModel : BasicModel
    {
        public int Id_udc { get; set; }
        public string? Cod_udc { get; set; }
        public int Id_tipo_udc { get; set; }
        public string? Sessione { get; set; }

        public TipoUdcModel? Tipo_udc { get; set; }
       

        public UdcModel()
        {
            NomeTabella = "udc";
        }

        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);
            Id_udc = GetIntNonNullable(reader, nameof(Id_udc));
            Cod_udc = GetString(reader, nameof(Cod_udc));
            Id_tipo_udc = GetIntNonNullable(reader, nameof(Id_tipo_udc));
            Sessione = GetString(reader, nameof(Sessione));

            Tipo_udc = new TipoUdcModel();
            Tipo_udc.FromReader(reader);
        }
    }
}

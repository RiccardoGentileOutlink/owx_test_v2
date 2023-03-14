using System.Collections.ObjectModel;
using System.Data.Common;
using System.Data.SqlClient;
using web.Autenticazione.Models;
using web.Generale;

namespace web.Magazzino.Models
{
  
    public class MagazzinoModel : BasicModel
    {
       
        public int Id_magazzino { get; set; }

        public string? Cod_magazzino { get; set; }

        public string? Desc_magazzino { get; set; }

        public int Ordinamento { get; set; }


        public MagazzinoModel()
        {
            NomeTabella = "magazzino";
            GestioneLogUtenti = false;
        }

        

        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);
            
            Id_magazzino = GetIntNonNullable(reader,nameof(Id_magazzino));
            Cod_magazzino = GetString(reader,nameof(Cod_magazzino));
            Desc_magazzino = GetString(reader,nameof(Desc_magazzino));
            Ordinamento = GetIntNonNullable(reader,nameof(Ordinamento));
            


        }

   
    }
}

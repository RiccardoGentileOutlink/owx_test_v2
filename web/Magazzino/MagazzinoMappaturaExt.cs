using OLMagazzinoMappatura;
using System.Data.SqlClient;
using web.Generale;

namespace web.Magazzino
{
    public class MagazzinoMappaturaExt: MagazzinoMappatura
    {
        private GestoreDB db;
        
        public MagazzinoMappaturaExt(GestoreDB db)
        {
            this.db = db;
           
        }
        public override void InitPlugin()
        {
            
            base.InitPlugin();
            TblCella = "cella";
            TblCorridoio = "corridoio";
            TblMagazzino = "magazzino";
            TblMontante = "montante";
            TblPiano = "piano";
            TblZona = "zona";

            
            SqlConnection conn = new SqlConnection(GestoreDB.ConnectionString);
            conn.Open();
           
            Connessione = conn;
        }

        public void close()
        {
            Connessione.Close();
        }

        public override string getCodCella(string magazzino, string zona, string corridoio, string montante, string piano, string cella)
        {
            return base.getCodCella(magazzino, zona, corridoio, montante, piano, cella);
        }

        public override string getCodCellaAlias(string magazzino, string zona, string corridoio, string montante, string piano, string cella)
        {
            return base.getCodCellaAlias(magazzino, zona, corridoio, montante, piano, cella);
        }
    }
}

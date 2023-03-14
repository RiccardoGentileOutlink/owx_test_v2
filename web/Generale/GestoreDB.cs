using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Reflection.Metadata;
using System.Security.Claims;
using System.Transactions;
using web.Autenticazione.Models;
using web.Magazzino.Models;
using IsolationLevel = System.Transactions.IsolationLevel;

namespace web.Generale
{
    public class GestoreDB
    {
        public static string? ConnectionString;

        public static TipoPlaceHolderParametri tipoPlaceHolderParametri;

        public enum TipoPlaceHolderParametri { Chiocciola,PuntoDomanda };

        
        private readonly IHttpContextAccessor httpContextAccessor;

        public GestoreDB(IHttpContextAccessor httpContextAccessor)
        {
            this.httpContextAccessor = httpContextAccessor;
        }

        private SqlConnection GetConnection()
        {
            SqlConnection conn = new SqlConnection(ConnectionString);
            conn.Open();
            return conn;
        }

        /// <summary>
        /// Per avere a disposizione l'azienda nel codice backend al di fuori dei controller passo un istanza di gestore db nei costrotturi dei controller con all'interno il riferimento all'HttpContext attraverso il meccanismo della Dependency Iniection
        /// </summary>
        /// <returns></returns>
        internal int GetAziendaSelezionata()
        {
            int azienda = 0;
            if (httpContextAccessor.HttpContext != null)
            {
                try
                {
                    azienda = Convert.ToInt16(httpContextAccessor.HttpContext.Request.Headers["Azienda"]);
                }
                catch(Exception ex)
                {

                }
            }
            return azienda;
        }

        /// <summary>
        /// Per avere a disposizione idUtente nel codice backend al di fuori dei controller passo un istanza di gestore db nei costrotturi dei controller con all'interno il riferimento all'HttpContext attraverso il meccanismo della Dependency Iniection
        /// </summary>
        /// <returns></returns>
        internal int GetIdUtente()
        {
            int idUtente = 0;
            if (httpContextAccessor.HttpContext != null)
            {
                try
                {
                    idUtente = Convert.ToInt16(httpContextAccessor.HttpContext.User.Claims.First(c => c.Type == ClaimTypes.NameIdentifier).Value);
                }
                catch (Exception ex)
                {

                }
            }
            return idUtente;
        }

        public  T? GetRecord<T>(string query, Dictionary<string,object>? parametri = null, bool ignoraAzienda = false) where T : BasicModel
        {
            if (!ignoraAzienda)
            {
                T recTest = (T)Activator.CreateInstance(typeof(T))!;
                if (recTest.GestioneAzienda && (!query.Contains("id_azienda=") && !query.Contains("id_azienda = ")))
                {
                    throw new Exception("Filtro azienda non impostato");
                }
            }

            T? rec = null;
            using (SqlConnection conn = GetConnection())
            {
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = query;
                if (parametri != null)
                {
                    foreach (string param in parametri.Keys)
                    {
                        if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.PuntoDomanda)
                        {
                            query = query.Replace("@" + param, "?");
                        }
                        cmd.Parameters.Add(new SqlParameter(param, parametri[param]));
                    }
                }
                //CommandBehavior.KeyInfo serve per avere informazioni sulle colonne e sulle tabelle (utile per costruire i model nel caso di join)
                using (SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.KeyInfo))
                {
                    if (reader.HasRows)
                    {
                        reader.Read();
                        rec  = (T)Activator.CreateInstance(typeof(T))!;
                        rec.FromReader(reader);
                    }
                }
            }
            return rec;

        }


        public List<T> GetListRecord<T>(string query, Dictionary<string, object>? parametri = null,bool ignoraAzienda=false) where T:BasicModel
        {
            if (!ignoraAzienda)
            {
                T recTest = (T)Activator.CreateInstance(typeof(T))!;
                if (recTest.GestioneAzienda && (!query.Contains("id_azienda=") && !query.Contains("id_azienda = "))){
                    throw new Exception("Filtro azienda non impostato");
                }
            }

            List<T> lista = new List<T>();
            using (SqlConnection conn = GetConnection())
            {
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = query;
                if (parametri != null)
                {
                    foreach (string param in parametri.Keys)
                    {
                        if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.PuntoDomanda)
                        {
                            query = query.Replace("@" + param, "?");
                        }
                        cmd.Parameters.Add(new SqlParameter(param, parametri[param]));
                    }
                }
                //CommandBehavior.KeyInfo serve per avere informazioni sulle colonne e sulle tabelle (utile per costruire i model nel caso di join)
                using (SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.KeyInfo))
                {
                    if (reader.HasRows)
                    {
                       
                        while (reader.Read())
                        {
                            T rec = (T)Activator.CreateInstance(typeof(T))!;  
                            rec.FromReader(reader);
                            lista.Add(rec);
                        }
                       
                    }
                }
            }
            return lista;

        }

        public int Insert( Dictionary<string, object> parametri,string tabella, string? queryIdentity = null)
        {
            return Insert(CostruisciQueryInsert(tabella, parametri), parametri, queryIdentity);
        }



        public int Insert(string query, Dictionary<string, object>? parametri = null, string? queryIdentity = null,bool ignoraAzienda=false)
        {
            if (Transaction.Current == null)
            {
                throw new Exception("Nessuna transazione attiva per l'operazione");
            }
            if (!ignoraAzienda)
            {
                if (parametri == null)
                {
                    throw new Exception("Tentativo di inserimento senza gestione esplicita dell'id_azienda");
                }
                else
                {
                    if (!parametri.ContainsKey("chk_id_azienda"))
                    {
                        throw new Exception("Tentativo di inserimento senza gestione esplicita dell'id_azienda");
                    }
                }
            }
            if (parametri != null && parametri.ContainsKey("chk_id_azienda"))
            {
                parametri.Remove("chk_id_azienda");
            }
            int id = 0;
            using (SqlConnection conn = GetConnection())
            {
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = query;
                if (parametri != null)
                {
                    foreach (string param in parametri.Keys)
                    {
                        cmd.Parameters.Add(new SqlParameter(param, parametri[param]));
                    }
                }
                cmd.ExecuteNonQuery();

                if (queryIdentity!=null)
                {
                    cmd.CommandText = queryIdentity;
                    cmd.Parameters.Clear();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            reader.Read();
                            id = reader.GetInt32(0);//prendo la prima colonna come id

                        }
                    }
                }
            }
            return id;
        }

        public int Update(Dictionary<string, object> parametri, Dictionary<string, object> parametriWhere,string tabella)
        {
            return Update(CostruisciQueryUpdate(tabella, parametri, parametriWhere), parametri, parametriWhere);
        }

        public int Update(string query, Dictionary<string, object>? parametri = null, Dictionary<string, object>? parametriWhere = null)
        {
            if (Transaction.Current == null)
            {
                throw new Exception("Nessuna transazione attiva per l'operazione");
            }
            int id = 0;
            using (SqlConnection conn = GetConnection())
            {
                
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = query;
                if (parametri != null)
                {
                    foreach (string param in parametri.Keys)
                    {
                        if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.PuntoDomanda)
                        {
                            query = query.Replace("@" + param, "?");
                        }
                        cmd.Parameters.Add(new SqlParameter(param, parametri[param]));
                    }
                }

                if (parametriWhere != null)
                {
                    foreach (string param in parametriWhere.Keys)
                    {
                        if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.PuntoDomanda)
                        {
                            query = query.Replace("@" + param, "?");
                        }
                        cmd.Parameters.Add(new SqlParameter(param, parametriWhere[param]));
                    }
                }
                cmd.ExecuteNonQuery();
            }
            return id;
        }


        public string CostruisciQueryInsert(string tabella, Dictionary<string, object> parametri)
        {
            string query = "Insert into " + tabella;
            string campi = "";
            string valori = "";
            foreach (string param in parametri.Keys)
            {
                if (param== "chk_id_azienda")
                {
                    continue;//questo è solo un parametro di controllo per verificare che sia stato gestito il campo id_azienda nelle tabelle che devono gestirlo
                }
                campi = campi + param + ",";
                if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.Chiocciola)
                {
                    valori = valori + "@" + param + ",";
                }
                if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.PuntoDomanda)
                {
                    valori = valori + "?,";
                }
                
            }

            if (campi != "")
            {
                campi = " (" + campi.Substring(0, campi.Length - 1) + ")";
                valori = " values (" + valori.Substring(0, valori.Length - 1) + ")";
            }

            query = query + campi + valori;

            return query;
        }

        public int Delete(string nometaTabella, Dictionary<string, object>? parametriWhere = null)
        {
            if (Transaction.Current == null)
            {
                throw new Exception("Nessuna transazione attiva per l'operazione");
            }
            int num = 0;
            using (SqlConnection conn = GetConnection())
            {
                
                SqlCommand cmd = conn.CreateCommand();
                string query  = "delete from " + nometaTabella;
               
                if (parametriWhere != null)
                {
                    query = query + " where ";
                    bool primo = true;
                    foreach (string param in parametriWhere.Keys)
                    {
                        if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.PuntoDomanda)
                        {
                            query = query + " " + (primo ? "" : " and ") + param + "=?";
                        }
                        if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.Chiocciola)
                        {
                            query = query + " " + (primo ? "" : " and ") + param + "=@"+param;
                        }
                        cmd.Parameters.Add(new SqlParameter(param, parametriWhere[param]));
                        if (primo)
                        {
                            primo = false;
                        }
                    }
                }
                cmd.CommandText = query;
                num = cmd.ExecuteNonQuery();
            }
            return num;
        }

        public void EseguiQuery(string query) { 
            if (query.ToLower().Trim().StartsWith("insert") || query.ToLower().Trim().StartsWith("update") || query.ToLower().Trim().StartsWith("delete"))
            {
                if (Transaction.Current == null)
                {
                    throw new Exception("Nessuna transazione attiva per l'operazione");
                }
            }
            else
            {
                throw new Exception("Per il metodo EseguiQuery sono ammesse solo insert,update,delete");
            }
            using (SqlConnection conn = GetConnection())
            {

                SqlCommand cmd = conn.CreateCommand();
               

                cmd.CommandText = query;
                cmd.ExecuteNonQuery();
            }
            
        }




        public void test()
        {
            List<CorridoioModel> zone = GetListRecord<CorridoioModel>("select * from corridoio inner join zona on zona.id_zona=corridoio.id_zona inner join magazzino on zona.id_magazzino=magazzino.id_magazzino", null);

            int cont = zone.Count;
        }

        internal  string CostruisciQueryUpdate(string tabella, Dictionary<string, object> parametriUpd, Dictionary<string, object> parametriWhere)
        {
            string query = "Update " + tabella;
            string campi = " set ";
            string where = " where ";
            foreach (string param in parametriUpd.Keys)
            {
                campi = campi + param + "=";
                if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.Chiocciola)
                {
                    campi = campi + "@" + param + ",";
                }
                if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.PuntoDomanda)
                {
                    campi = campi + "?,";
                }

            }

            foreach (string param in parametriWhere.Keys)
            {
                where = where + param + "=";
                if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.Chiocciola)
                {
                    where = where + "@" + param + " and ";
                }
                if (tipoPlaceHolderParametri == TipoPlaceHolderParametri.PuntoDomanda)
                {
                    where = where + "? and ";
                }

            }

            if (campi != "")
            {
                campi =  campi.Substring(0, campi.Length - 1);
                
            }

            if (where != "")
            {
                where = where.Substring(0, where.Length - 4);

            }

            query = query + campi + where;

            return query;
        }

        public TransactionScope CreaTransazione(IsolationLevel isolation=IsolationLevel.ReadUncommitted)
        {
            TransactionOptions transactionOptions = new TransactionOptions();
            transactionOptions.IsolationLevel = isolation;

            TransactionScope trans = new TransactionScope(TransactionScopeOption.RequiresNew, transactionOptions);

            return trans;
        }

        internal object ChekNull(object? value)
        {
            if (value == null)
            {
                return DBNull.Value;
            }
            return value!;
        }
    }


    


}

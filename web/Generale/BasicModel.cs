using System.Data.Common;
using System.Data.SqlClient;

namespace web.Generale
{


    public abstract class BasicModel
    {

        [NonSerialized()] protected string? NomeTabella;

        [NonSerialized()] public bool GestioneAzienda = true;

        [NonSerialized()] public bool GestioneLogUtenti = true;

        [NonSerialized()] protected List<DbColumn>? ColumnSchema;

        public DateTime? Data_ins { get; set; }
        public DateTime? Data_agg { get; set; }

        public int? Id_utente_ins { get; set; }
        public int? Id_utente_agg { get; set; }
        public int? Id_azienda { get; set; }




        public BasicModel Clone()
        {
            BasicModel cloneObj = (BasicModel)MemberwiseClone();
            return cloneObj;
        }



        public object? GetReaderObject(SqlDataReader reader, string nomeCampo)
        {


            if (ColumnSchema != null)
            {
                int? indice = null;
                DbColumn? col = ColumnSchema.Find(c => c.BaseTableName!.ToLower() == NomeTabella && c.ColumnName.ToLower() == nomeCampo.ToLower());
                if (col != null)
                {
                    indice = col.ColumnOrdinal;
                }
                if (indice == null)
                {
                    return null;
                }
                else
                {
                    return reader[indice.Value] == DBNull.Value ? null : reader[indice.Value];
                }
            }
            else
            {
                return reader[nomeCampo] == DBNull.Value ? null : reader[nomeCampo];
            }


        }


        public int? GetInt(SqlDataReader reader, string nomeCampo)
        {
            object? val = GetReaderObject(reader, nomeCampo);
            if (val != null)
            {
                try
                {
                    return Convert.ToInt32(val);
                }
                catch (Exception ex)
                {

                    return null;

                }
            }
            return null;
        }

        public decimal? GetDecimal(SqlDataReader reader, string nomeCampo)
        {
            object? val = GetReaderObject(reader, nomeCampo);
            if (val != null)
            {
                try
                {
                    return Convert.ToDecimal(val);
                }
                catch (Exception ex)
                {

                    return null;

                }
            }
            return null;
        }

        public int GetIntNonNullable(SqlDataReader reader, string nomeCampo)
        {
            object? val = GetReaderObject(reader, nomeCampo);
            if (val != null)
            {
                try
                {
                    return Convert.ToInt32(val);
                }
                catch (Exception ex)
                {

                    return 0;

                }
            }
            return 0;
        }

        public bool? GetBoolean(SqlDataReader reader, string nomeCampo)
        {
            object? val = GetReaderObject(reader, nomeCampo);
            if (val != null)
            {
                try
                {
                    return Convert.ToBoolean(val);
                }
                catch (Exception ex)
                {
                    return null;
                }
            }
            return null;
        }


        public string? GetString(SqlDataReader reader, string nomeCampo)
        {
            object? val = GetReaderObject(reader, nomeCampo);
            if (val != null)
            {
                try
                {
                    return val.ToString();
                }
                catch (Exception ex)
                {
                    return null;
                }
            }
            return null;
        }


        public DateTime? GetDateTime(SqlDataReader reader, string nomeCampo)
        {
            object? val = GetReaderObject(reader, nomeCampo);
            if (val != null && val.ToString() != "")
            {
                try
                {
                    return Convert.ToDateTime(val);
                }
                catch (Exception ex)
                {
                    return null;
                }
            }
            return null;
        }


        /// <summary>
        /// Richiamare questo metodo nelle implementazioni di FromReader come prima istruzione
        /// </summary>
        /// <param name="reader"></param>
        public virtual void FromReaderCommon(SqlDataReader reader)
        {
            ColumnSchema = reader.GetColumnSchema().ToList();
            Data_ins = GetDateTime(reader, nameof(Data_ins));
            Data_agg = GetDateTime(reader, nameof(Data_agg));
            if (GestioneAzienda)
            {
                Id_azienda = GetInt(reader, nameof(Id_azienda));
            }

            if (GestioneLogUtenti)
            {
                Id_utente_ins = GetInt(reader, nameof(Id_utente_ins));
                Id_utente_agg = GetInt(reader, nameof(Id_utente_agg));
            }

        }

        public abstract void FromReader(SqlDataReader reader);

        public Dictionary<string, object> GetParametriLogInsert(GestoreDB dB)
        {
            Dictionary<string, object> ret = new Dictionary<string, object>();
            if (GestioneAzienda)
            {
                ret.Add("id_azienda", dB.GetAziendaSelezionata());
            }
            if (GestioneLogUtenti)
            {
                ret.Add("id_utente_ins", dB.GetIdUtente());
                ret.Add("data_ins", DateTime.Now);
            }

            //questo parametro mi serve per dire alla funzione di insert che ho gestito il campo id_azienda
            //se non presente questo campo tra i parametri viene generata un'eccezione
            //questo parametro viene poi rimosso prima di effettuare la query vera e propria (vedi GestoreDb.Insert)
            ret.Add("chk_id_azienda", "");

            return ret;
        }

        public Dictionary<string, object> GetParametriLogUpdate(GestoreDB dB)
        {
            Dictionary<string, object> ret = new Dictionary<string, object>();
            if (GestioneLogUtenti)
            {
                ret.Add("id_utente_agg", dB.GetIdUtente());
                ret.Add("data_agg", DateTime.Now);
            }
            return ret;
        }

    }
}

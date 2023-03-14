using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using System.Transactions;
using web.Configurazione.Models;
using web.Generale;

namespace web.Configurazione
{

    public class GestoreConfigurazione
    {
        private GestoreDB db;
        private IStringLocalizer<Res> resources;

        public GestoreConfigurazione(GestoreDB db, IStringLocalizer<Res> resources)
        {
            this.db = db;
            this.resources = resources;
        }

        internal ActionResult<bool> EliminaStampante(StampanteModel stampanate)
        {
            try
            {

                using (TransactionScope scope = db.CreaTransazione())
                {

                    Dictionary<string, object> parametriWhere = new Dictionary<string, object>();
                    parametriWhere.Add("id_stampante", stampanate.Id_stampante);
                    db.Delete("stampante", parametriWhere);

                    scope.Complete();
                    return true;
                }
            }
            catch (Exception ex)
            {
                ObjectResult err = new ObjectResult(ex.Message);
                err.StatusCode = StatusCodes.Status500InternalServerError;
                return err;
            }
        }

        internal List<ParametroModel> GetParametri()
        {
            return db.GetListRecord<ParametroModel>("select * from parametro where id_azienda=" + db.GetAziendaSelezionata());
        }

       

        internal StampanteModel? GetStampante(int id_stampante)
        {
            StampanteModel? rec = db.GetRecord<StampanteModel>("select * from stampante where id_stampante =" + id_stampante, ignoraAzienda: true);

            return rec;
        }

        internal List<StampanteModel> GetStampanti()
        {
            return db.GetListRecord<StampanteModel>("select * from stampante where id_azienda=" + db.GetAziendaSelezionata());
        }

        internal StampaModel? GetStampa(int id_stampa)
        {
            StampaModel? rec = db.GetRecord<StampaModel>("select * from stampa left join stampante on stampa.id_stampante_def=stampante.id_stampante where id_stampa =" + id_stampa, ignoraAzienda: true);
            return rec;
        }

        internal List<StampaModel> GetStampe()
        {
            return db.GetListRecord<StampaModel>("select * from stampa left join stampante on stampa.id_stampante_def=stampante.id_stampante where stampa.id_azienda=" + db.GetAziendaSelezionata());
        }

        internal ActionResult<List<ParametroModel>> SalvaParametri(List<ParametroModel> parametri)
        {
            try
            {
                using (TransactionScope scope = db.CreaTransazione())
                {
                    foreach (ParametroModel param in parametri)
                    {
                        Dictionary<string, object> paramCheck = new Dictionary<string, object>();
                        paramCheck.Add("cod_parametro", param.Cod_parametro!);
                        if (db.GetRecord<ParametroModel>("Select * from parametro where id_azienda=" + db.GetAziendaSelezionata() + " and cod_parametro=@cod_parametro", paramCheck) != null)
                        {
                            //se esiste aggiorno
                            Dictionary<string, object> paramUpd = param.GetParametriLogUpdate(db);
                            paramUpd.Add("desc_parametro",  db.ChekNull(param.Desc_parametro));
                            paramUpd.Add("valore", param.Valore!);

                            Dictionary<string, object> paramWhere = new Dictionary<string, object>();
                            paramWhere.Add("cod_parametro", param.Cod_parametro!);
                            paramWhere.Add("id_azienda", db.GetAziendaSelezionata());

                            db.Update(paramUpd, paramWhere, "parametro");

                        }
                        else
                        {
                            //se non esiste inserisco
                            Dictionary<string, object> paramInsert = param.GetParametriLogInsert(db);
                            paramInsert.Add("cod_parametro", param.Cod_parametro!);
                            paramInsert.Add("desc_parametro", db.ChekNull(param.Desc_parametro));
                            paramInsert.Add("valore", param.Valore!);
                            db.Insert(paramInsert, "parametro");
                        }
                    }
                    scope.Complete();
                }
                return GetParametri();
            }
            catch (Exception ex)
            {
                ObjectResult err = new ObjectResult(ex.Message);
                err.StatusCode = StatusCodes.Status500InternalServerError;
                return err;
            }

        }

        internal ActionResult<StampaModel> SalvaStampa(StampaModel stampa)
        {
            try
            {
                using (TransactionScope scope = db.CreaTransazione())
                {

                    Dictionary<string, object> paramUpd = stampa.GetParametriLogUpdate(db);
                    paramUpd.Add("id_stampante_def", db.ChekNull(stampa.Id_stampante_def));

                    Dictionary<string, object> parametriWhere = new Dictionary<string, object>();
                    parametriWhere.Add("id_stampa", stampa.Id_stampa);
                    db.Update(paramUpd, parametriWhere, "stampa");

                    scope.Complete();
                }
                return stampa;
            }
            catch (Exception ex)
            {
                ObjectResult err = new ObjectResult(ex.Message);
                err.StatusCode = StatusCodes.Status500InternalServerError;
                return err;
            }
        }

        internal ActionResult<StampanteModel> SalvaStampante(StampanteModel stampante)
        {
            try
            {
                using (TransactionScope scope = db.CreaTransazione())
                {
                    if (stampante.Id_stampante == 0)
                    {
                        Dictionary<string, object> parametriChk = new Dictionary<string, object>();
                        parametriChk.Add("nome_stampante", stampante.Nome_stampante!);
                        StampanteModel? chekNome = db.GetRecord<StampanteModel>("Select * from stampante where id_azienda=" + db.GetAziendaSelezionata() + " and nome_stampante=@nome_stampante", parametriChk);
                        if (chekNome != null)
                        {
                            throw new Exception(resources[Res.MSG_ELEMENTO_GIA_PRESENTE] + " (" + stampante.Nome_stampante + ")");
                        }

                        Dictionary<string, object> parametri = stampante.GetParametriLogInsert(db);
                        parametri.Add("nome_stampante", stampante.Nome_stampante!);
                        parametri.Add("desc_stampante", db.ChekNull(stampante.Desc_stampante));

                        int id_new = db.Insert(parametri, "stampante", "select top 1 id_stampante from stampante order by id_stampante desc");
                        stampante.Id_stampante = id_new;
                    }
                    else
                    {
                        Dictionary<string, object> paramUpd = stampante.GetParametriLogUpdate(db);
                        paramUpd.Add("nome_stampante", stampante.Nome_stampante!);
                        paramUpd.Add("desc_stampante", db.ChekNull(stampante.Desc_stampante));

                        Dictionary<string, object> parametriWhere = new Dictionary<string, object>();
                        parametriWhere.Add("id_stampante", stampante.Id_stampante);
                        db.Update(paramUpd, parametriWhere, "stampante");
                    }
                    scope.Complete();
                }
                return db.GetRecord<StampanteModel>("Select * from stampante where id_stampante=" + stampante.Id_stampante, ignoraAzienda: true)!;
            }
            catch (Exception ex)
            {
                ObjectResult err = new ObjectResult(ex.Message);
                err.StatusCode = StatusCodes.Status500InternalServerError;
                return err;
            }
        }
    }
}

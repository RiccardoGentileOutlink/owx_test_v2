using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using System.Transactions;
using web.Generale;
using web.Magazzino.Models;
using web.Magazzino.Models.Params;

namespace web.Magazzino
{
    public class GestoreMagazzino
    {
        private GestoreDB db;
        private IStringLocalizer<Res> resources;



        public GestoreMagazzino(GestoreDB gestoreDB, IStringLocalizer<Res> resources)
        {
            db = gestoreDB;
            this.resources = resources;
        }

        internal ActionResult<bool> EliminaCelle(List<CellaModel> celle)
        {
            try
            {

                using (TransactionScope scope = db.CreaTransazione())
                {

                    foreach (CellaModel cella in celle)
                    {
                        Dictionary<string, object> param = new Dictionary<string, object>();
                        param.Add("id_cella", cella.Id_cella);
                        db.Delete("Cella", param);
                    }

                    //elimino le tabelle accessorie
                    db.EseguiQuery("delete from piano where id_piano not in (select id_piano from cella)");
                    db.EseguiQuery("delete from montante where id_montante not in (select id_montante from piano)");
                    db.EseguiQuery("delete from corridoio where id_corridoio not in (select id_corridoio from montante)");
                    db.EseguiQuery("delete from zona where id_zona not in (select id_zona from corridoio)");

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

        internal ActionResult<bool> GeneraUdc(GeneraUdcModel param)
        {
            try
            {

                using (TransactionScope scope = db.CreaTransazione(IsolationLevel.ReadCommitted))
                {
                    string sessione = DateTime.Now.ToString("ddMMyyyy.HHmmss.fff") + "_" + db.GetIdUtente();
                    TipoUdcModel? tipoUdc = db.GetRecord<TipoUdcModel>("select * from tipo_udc where id_tipo_udc=" + param.Id_tipo_udc, ignoraAzienda: true);
                    if (tipoUdc == null)
                    {
                        throw new Exception(resources[Res.MSG_TIPO_UDC_NON_TROVATO]);
                    }
                    else
                    {
                        //prendo il prossimo numeratore per il tipo udc, se non c'è lo creo
                        ProgressivoModel progModel = new ProgressivoModel();
                        progModel.Anno = DateTime.Now.Year;
                        progModel.Cod_progressivo = tipoUdc.Cod_tipo_udc;
                        ProgressivoModel progressivo = GetProssimoNumeratore(progModel, db);
                        //genero la sessione come dataorasecondi...millisecondi

                        //per ottimizzare aggiorno solo alla fine il numeratore (tanto sono su readCommitted e nessuno puo leggere finche non faccio il commit)
                        int contatore = progressivo.Contatore;
                        int contatoreFinale = contatore + param.Quantita - 1;
                        for (int i = 0; i < param.Quantita; i++)
                        {
                            string cod_udc = _getCodiceUdc(progModel.Cod_progressivo!, progModel.Anno, contatore);

                            Dictionary<string, object> paraInsertUdc = new UdcModel().GetParametriLogInsert(db);
                            paraInsertUdc.Add("cod_udc", cod_udc);
                            paraInsertUdc.Add("id_tipo_udc", param.Id_tipo_udc);
                            paraInsertUdc.Add("sessione", sessione);
                            db.Insert(paraInsertUdc, "udc");
                            contatore++;
                        }

                        Dictionary<string, object> paramUpdProg = progModel.GetParametriLogUpdate(db);
                        paramUpdProg.Add("contatore", contatoreFinale);

                        Dictionary<string, object> paramWhereProg = new Dictionary<string, object>();
                        paramWhereProg.Add("id_progressivo", progressivo.Id_progressivo);
                        db.Update(paramUpdProg, paramWhereProg, "progressivo");

                    }
                    scope.Complete();

                    if (param.Stampa)
                    {
                        try
                        {
                            _stampaEtichetteUdc(sessione);
                        }
                        catch (Exception ex)
                        {
                            ObjectResult erroreStampa = new ObjectResult(resources[Res.MSG_ERRORE_STAMPA_ETICHETTE_UDC] + ": " + ex.Message);
                            erroreStampa.StatusCode = StatusCodes.Status400BadRequest;
                            return erroreStampa;
                        }
                    }

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

        private void _stampaEtichetteUdc(string sessione)
        {
            throw new NotImplementedException();
        }

        private string _getCodiceUdc(string cod_progressivo, int? anno, int contatore)
        {

            string cod = cod_progressivo + anno?.ToString().Substring(2);
            string progString = contatore.ToString().PadLeft(6, '0');
            if (progString.Length > 6)
            {
                throw new Exception(resources[Res.MSG_SUPERATO_NUM_MAX_UDC]);
            }

            return cod + progString;


        }

        internal List<CellaModel> GetCelle(List<String>? idCelle = null)
        {

            string filtro = " where cella.id_azienda=" + db.GetAziendaSelezionata();
            String filtroCelle = "";
            if (idCelle != null)
            {
                foreach (String id in idCelle)
                {
                    filtroCelle = filtroCelle + id + ",";
                }
            }
            if (filtroCelle != "")
            {
                filtroCelle = filtroCelle.Substring(0, filtroCelle.Length - 1);
                filtroCelle = " and id_cella in (" + filtroCelle + ")";
            }

            filtro = filtro + filtroCelle;
            /*  List<CellaModel> lista = db.GetListRecord<CellaModel>("SELECT * FROM cella INNER JOIN corridoio ON cella.id_corridoio = corridoio.id_corridoio INNER JOIN magazzino ON cella.id_magazzino = magazzino.id_magazzino AND corridoio.id_magazzino = magazzino.id_magazzino INNER JOIN montante ON cella.id_montante = montante.id_montante AND corridoio.id_corridoio = montante.id_corridoio AND magazzino.id_magazzino = montante.id_magazzino INNER JOIN piano ON cella.id_piano = piano.id_piano AND corridoio.id_corridoio = piano.id_corridoio AND magazzino.id_magazzino = piano.id_magazzino AND montante.id_montante = piano.id_montante INNER JOIN zona ON cella.id_zona = zona.id_zona AND corridoio.id_zona = zona.id_zona AND magazzino.id_magazzino = zona.id_magazzino AND montante.id_zona = zona.id_zona AND piano.id_zona = zona.id_zona " + filtro);*/

            List<CellaModel> lista = db.GetListRecord<CellaModel>("SELECT * FROM cella INNER JOIN corridoio ON cella.id_corridoio = corridoio.id_corridoio INNER JOIN magazzino ON cella.id_magazzino = magazzino.id_magazzino  INNER JOIN montante ON cella.id_montante = montante.id_montante  INNER JOIN piano ON cella.id_piano = piano.id_piano  INNER JOIN zona ON cella.id_zona = zona.id_zona  " + filtro);

            return lista;
        }

        internal List<MagazzinoModel> GetMagazzini()
        {

            List<MagazzinoModel> lista = db.GetListRecord<MagazzinoModel>("Select * from magazzino where id_azienda=" + db.GetAziendaSelezionata());

            return lista;
        }

        internal List<TipoUdcModel> GetTipoUdc()
        {
            List<TipoUdcModel> lista = db.GetListRecord<TipoUdcModel>("Select * from tipo_udc where id_azienda=" + db.GetAziendaSelezionata());
            return lista;
        }


        internal ProgressivoModel GetProssimoNumeratore(ProgressivoModel param, GestoreDB db)
        {
            Dictionary<string, object> parametri = new Dictionary<string, object>();
            parametri.Add("cod_progressivo", param.Cod_progressivo!);
            parametri.Add("anno", param.Anno!);
            ProgressivoModel? progressivo = db.GetRecord<ProgressivoModel>("select * from progressivo where id_azienda=" + db.GetAziendaSelezionata() + " and cod_progressivo=@cod_progressivo and anno=@anno", parametri);
            if (progressivo == null)
            {
                Dictionary<string, object> paramInsert = param.GetParametriLogInsert(db);
                paramInsert.Add("cod_progressivo", param.Cod_progressivo!);
                paramInsert.Add("anno", param.Anno!);
                paramInsert.Add("contatore", 1);
                db.Insert(paramInsert, "progressivo");

                progressivo = db.GetRecord<ProgressivoModel>("select * from progressivo where id_azienda=" + db.GetAziendaSelezionata() + " and cod_progressivo=@cod_progressivo and anno=@anno", parametri);
                return progressivo!;
            }
            else
            {
                //aggiorno il contatore
                Dictionary<string, object> paramUpd = param.GetParametriLogUpdate(db);
                paramUpd.Add("contatore", progressivo!.Contatore + 1);
                Dictionary<string, object> paramWhere = new Dictionary<string, object>();
                paramWhere.Add("id_progressivo", progressivo!.Id_progressivo);
                db.Update(paramUpd, paramWhere, "progressivo");

                progressivo!.Contatore = progressivo!.Contatore + 1;
                return progressivo;
            }



        }

        internal List<UdcModel> GetUdc(List<int>? idUdc = null)
        {
            string filtro = " where udc.id_azienda=" + db.GetAziendaSelezionata();

            String filtroUdc = "";
            if (idUdc != null)
            {
                foreach (int id in idUdc)
                {
                    filtroUdc = filtroUdc + id + ",";
                }
            }
            if (filtroUdc != "")
            {
                filtroUdc = filtroUdc.Substring(0, filtroUdc.Length - 1);
                filtroUdc = " and id_udc in (" + filtroUdc + ")";
            }
            filtro += filtroUdc;

            List<UdcModel> lista = db.GetListRecord<UdcModel>("SELECT * FROM udc INNER JOIN tipo_udc ON udc.id_tipo_udc = tipo_udc.id_tipo_udc " + filtro);

            return lista;
        }
    }
}

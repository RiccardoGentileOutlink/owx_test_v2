using Microsoft.Extensions.Localization;
using web.Anagrafica.Models;
using web.Generale;

namespace web.Anagrafica
{
    public class GestoreArticolo
    {
        private GestoreDB db;
        private IStringLocalizer<Res> resources;

        public GestoreArticolo(GestoreDB db, IStringLocalizer<Res> resources)
        {
            this.db = db;
            this.resources = resources;
        }
        /*
         * Passando un bool? posso gestire i tre stati (mostra tutti quando è null, osoleti quando è true, e solo non osoleti quando è false
         */
        internal List<ArticoloModel> GetArticoli(bool includiArticoloPadre,bool? obsoleti=null)
        {
            string filtroObsoleti = "";
            if (obsoleti != null)
            {
                filtroObsoleti = " and Coalesce(articolo.obsoleto,0) =" + (obsoleti.Value?"1":"0");
            }
            List<ArticoloModel> listaArticoli = db.GetListRecord<ArticoloModel>("select * from articolo inner join unita_misura on articolo.id_unita_misura=unita_misura.id_unita_misura where articolo.id_azienda=" + db.GetAziendaSelezionata() + filtroObsoleti);

            if (includiArticoloPadre)
            {
                List<ArticoloModel> listaArticoliFiglio = db.GetListRecord<ArticoloModel>("select * from articolo inner join unita_misura on articolo.id_unita_misura=unita_misura.id_unita_misura where id_articolo_padre is not null and articolo.id_azienda=" + db.GetAziendaSelezionata() + filtroObsoleti);

                foreach (ArticoloModel figlio in listaArticoliFiglio)
                {
                    ArticoloModel? padre = listaArticoli.Find(a => a.Id_articolo == figlio.Id_articolo_padre);
                    if (padre != null)
                    {
                        listaArticoli.Find(a => a.Id_articolo == figlio.Id_articolo)!.Articolo_padre = padre;
                    }
                    
                }
            }
            return listaArticoli;
        }

        internal ArticoloModel? GetArticoloByCod(string cod_articolo, bool prendiPadre = true,bool soloAttivi = false)
        {
            Dictionary<string, object> parametri = new Dictionary<string, object>();
            parametri.Add("cod_articolo", cod_articolo);
            ArticoloModel? articolo = db.GetRecord<ArticoloModel>("select * from articolo inner join unita_misura on articolo.id_unita_misura=unita_misura.id_unita_misura where cod_articolo=@cod_articolo and articolo.id_azienda=" + db.GetAziendaSelezionata(),parametri );
            if (prendiPadre && articolo != null && articolo.Id_articolo_padre != null)
            {
                articolo.Articolo_padre = GetArticoloById(articolo.Id_articolo_padre.Value, prendiPadre = false);
            }
            if (articolo != null)
            {
                if (soloAttivi && articolo.Obsoleto.HasValue && articolo.Obsoleto.Value)
                {
                    articolo = null;//se obsoleto lo ignoro
                }
            }
            return articolo;
        }

        internal ArticoloModel? GetArticoloById(int id_articolo,bool prendiPadre=true, bool soloAttivi = false)
        {
            ArticoloModel? articolo = db.GetRecord<ArticoloModel>("select * from articolo inner join unita_misura on articolo.id_unita_misura=unita_misura.id_unita_misura where id_articolo=" + id_articolo,ignoraAzienda:true);
            if (prendiPadre && articolo!=null && articolo.Id_articolo_padre != null)
            {
                articolo.Articolo_padre = GetArticoloById(articolo.Id_articolo_padre.Value,prendiPadre=false);
            }
            if (articolo != null)
            {
                if (soloAttivi && articolo.Obsoleto.HasValue && articolo.Obsoleto.Value)
                {
                    articolo = null;//se obsoleto lo ignoro
                }
            }
            
            return articolo;
        }

        internal ArticoloModel? GetArticoloPadre(int id_articolo)
        {
            ArticoloModel? articolo = db.GetRecord<ArticoloModel>("select * from articolo inner join unita_misura on articolo.id_unita_misura=unita_misura.id_unita_misura where id_articolo = (select id_articolo_padre from articolo where id_articolo=" + id_articolo+")",ignoraAzienda:true);
            return articolo;
        }

        internal List<UnitaMisuraModel> GetUnitaMisuraAll()
        {
            List<UnitaMisuraModel> listaUdm = db.GetListRecord<UnitaMisuraModel>("select * from unita_misura where id_azienda=" + db.GetAziendaSelezionata());
            return listaUdm;
        }

        internal UnitaMisuraModel? GetUnitaMisura(int id_unita_misura)
        {
            UnitaMisuraModel? unitaMisura = db.GetRecord<UnitaMisuraModel>("select * from unita_misura where id_unita_misura=" + id_unita_misura, ignoraAzienda: true);
            return unitaMisura;
        }
    }
}

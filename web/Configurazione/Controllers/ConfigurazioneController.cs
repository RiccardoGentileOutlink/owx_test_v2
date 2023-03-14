using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using System.Drawing.Printing;
using web.Configurazione.Models;
using web.Generale;

namespace web.Configurazione.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class ConfigurazioneController : ControllerBase
    {
        private readonly IStringLocalizer<Res> resources;
        private readonly GestoreDB gestoreDB;

        public ConfigurazioneController(IStringLocalizer<Res> resources, GestoreDB gestoreDB)
        {
            this.resources = resources;
            this.gestoreDB = gestoreDB;
        }

        [HttpGet]
        public List<ParametroModel> GetParametri()
        {
            GestoreConfigurazione gestConf = new GestoreConfigurazione(gestoreDB, resources);
            return gestConf.GetParametri();
        }

        [HttpPost]
        public ActionResult<List<ParametroModel>> SalvaParametri(List<ParametroModel> parametri)
        {
            GestoreConfigurazione gestConf = new GestoreConfigurazione(gestoreDB, resources);
            return gestConf.SalvaParametri(parametri);
        }

        [HttpGet]
        public List<StampanteModel> GetStampanti()
        {
            GestoreConfigurazione gestConf = new GestoreConfigurazione(gestoreDB, resources);
            return gestConf.GetStampanti();
        }
        [HttpGet]
        public StampanteModel? GetStampante(int id_stampante)
        {
            GestoreConfigurazione gestConf = new GestoreConfigurazione(gestoreDB, resources);
            return gestConf.GetStampante(id_stampante);
        }


        [HttpDelete]
        public ActionResult<bool> EliminaStampante(StampanteModel stampanate)
        {
            GestoreConfigurazione gestConf = new GestoreConfigurazione(gestoreDB, resources);
            return gestConf.EliminaStampante(stampanate);
        }

        [HttpPost]
        public ActionResult<StampanteModel> SalvaStampante(StampanteModel stampante)
        {
            GestoreConfigurazione gestConf = new GestoreConfigurazione(gestoreDB, resources);
            return gestConf.SalvaStampante(stampante);
        }


        [HttpGet]
        public List<StampaModel> GetStampe()
        {
            GestoreConfigurazione gestConf = new GestoreConfigurazione(gestoreDB, resources);
            return gestConf.GetStampe();
        }

        [HttpGet]
        public StampaModel? GetStampa(int id_stampa)
        {
            GestoreConfigurazione gestConf = new GestoreConfigurazione(gestoreDB, resources);
            return gestConf.GetStampa(id_stampa);
        }

        [HttpPost]
        public ActionResult<StampaModel> SalvaStampa(StampaModel stampa)
        {
            GestoreConfigurazione gestConf = new GestoreConfigurazione(gestoreDB, resources);
            return gestConf.SalvaStampa(stampa);
        }


        [HttpGet]
        public List<string> GetStampantiServer()
        {
            List<string> stampantiServer = new List<string>();
            try
            {
                foreach (string nome in PrinterSettings.InstalledPrinters)
                {
                    stampantiServer.Add(nome);
                }
            }
            catch (Exception ex)
            {

            }


            return stampantiServer;

        }



    }
}

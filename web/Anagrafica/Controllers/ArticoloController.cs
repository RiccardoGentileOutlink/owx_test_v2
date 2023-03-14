using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using web.Generale;
using web.Magazzino.Models;
using web.Magazzino;
using web.Anagrafica.Models;

namespace web.Anagrafica.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class ArticoloController : ControllerBase
    {
        private readonly IStringLocalizer<Res> resources;
        private readonly GestoreDB gestoreDB;


        public ArticoloController(IStringLocalizer<Res> resources, GestoreDB gestoreDB)
        {
            this.resources = resources;
            this.gestoreDB = gestoreDB;
        }


        [HttpGet]
        public List<ArticoloModel> GetArticoli(bool includiArticoloPadre)
        {
            GestoreArticolo gestArt = new GestoreArticolo(gestoreDB, resources);
            return gestArt.GetArticoli(includiArticoloPadre);
        }

        

        [HttpGet]
        public List<ArticoloModel> GetArticoliAttivi(bool includiArticoloPadre)
        {
            GestoreArticolo gestArt = new GestoreArticolo(gestoreDB, resources);
            return gestArt.GetArticoli(includiArticoloPadre, obsoleti: false);
        }

        [HttpGet]
        public List<ArticoloModel> GetArticoliOsoleti(bool includiArticoloPadre)
        {
            GestoreArticolo gestArt = new GestoreArticolo(gestoreDB, resources);
            return gestArt.GetArticoli(includiArticoloPadre, obsoleti: true);
        }

        [HttpGet]
        public ArticoloModel? GetArticoloPadre(int id_articolo)
        {
            GestoreArticolo gestArt = new GestoreArticolo(gestoreDB, resources);
            return gestArt.GetArticoloPadre(id_articolo);
        }


        [HttpGet]
        public ArticoloModel? GetArticoloById(int id_articolo,bool soloAttivi=false)
        {
            GestoreArticolo gestArt = new GestoreArticolo(gestoreDB, resources);
            return gestArt.GetArticoloById(id_articolo,soloAttivi);
        }

        [HttpGet]
        public ArticoloModel? GetArticoloByCod(string cod_articolo, bool soloAttivi = false)
        {
            GestoreArticolo gestArt = new GestoreArticolo(gestoreDB, resources);
            return gestArt.GetArticoloByCod(cod_articolo,soloAttivi);
        }

        [HttpGet]
        public List<UnitaMisuraModel> GetUnitaMisuraAll()
        {
            GestoreArticolo gestArt = new GestoreArticolo(gestoreDB, resources);
            return gestArt.GetUnitaMisuraAll();
        }

        [HttpGet]
        public UnitaMisuraModel? GetUnitaMisura(int id_unita_misura)
        {
            GestoreArticolo gestArt = new GestoreArticolo(gestoreDB, resources);
            return gestArt.GetUnitaMisura(id_unita_misura);
        }

    }
}

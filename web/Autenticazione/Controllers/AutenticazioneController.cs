using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using web.Autenticazione.Models;
using web.Generale;

namespace web.Autenticazione.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class AutenticazioneController : ControllerBase
    {
        private readonly IStringLocalizer<Res> resources;
        private readonly GestoreDB gestoreDB;

        public AutenticazioneController(IStringLocalizer<Res> resources, GestoreDB gestoreDB)
        {
            this.resources = resources;
            this.gestoreDB = gestoreDB;
        }

        [AllowAnonymous]
        [HttpGet]
        public ActionResult<UtenteModel?> Login(string username, string password)
        {
            GestoreUtenti gestUt = new GestoreUtenti(gestoreDB, resources);
            return gestUt.Login(username, password);

        }

        [HttpPost]
        public ActionResult<UtenteModel> CreaUtente(UtenteModel utente)
        {
            GestoreUtenti gestUt = new GestoreUtenti(gestoreDB, resources);
            return gestUt.CreaUtente(utente);

        }


        [HttpPost]
        public ActionResult<UtenteModel> ModificaUtente(UtenteModel utente)
        {
            GestoreUtenti gestUt = new GestoreUtenti(gestoreDB, resources);
            return gestUt.ModificaUtente(utente);

        }

        [HttpGet]
        public List<UtenteModel> GetUtenti()
        {

            GestoreUtenti gestUt = new GestoreUtenti(gestoreDB, resources);
            return gestUt.GetUtenti();
        }


        [HttpGet]
        public UtenteModel? GetUtente(int id_utente)
        {
            GestoreUtenti gestUt = new GestoreUtenti(gestoreDB, resources);
            return gestUt.GetUtente(id_utente);
        }


        [HttpDelete]
        public ActionResult<bool> EliminaUtente(UtenteModel utente)
        {
            GestoreUtenti gestUt = new GestoreUtenti(gestoreDB, resources);
            return gestUt.EliminaUtente(utente);
        }

        [HttpGet]
        [AllowAnonymous]
        public List<AziendaModel> GetAziende()
        {

            GestoreUtenti gestUt = new GestoreUtenti(gestoreDB, resources);
            return gestUt.GetAziende();
        }



        [HttpGet]
        public String test()
        {

            return "Ciao";
        }



    }



}



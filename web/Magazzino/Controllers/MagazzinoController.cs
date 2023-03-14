using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using QuestPDF.Fluent;
using QuestPDF.Previewer;
using System.Security.Claims;
using web.Configurazione;
using web.Generale;
using web.Magazzino.Models;
using web.Magazzino.Models.Params;
using web.Magazzino.Reports;

namespace web.Magazzino.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class MagazzinoController : ControllerBase
    {
        private readonly IStringLocalizer<Res> resources;
        private readonly GestoreDB gestoreDB;

        public MagazzinoController(IStringLocalizer<Res> resources, GestoreDB gestoreDB)
        {
            this.resources = resources;
            this.gestoreDB = gestoreDB;
        }

        [HttpGet]
        public List<MagazzinoModel> GetMagazzini()
        {
            GestoreMagazzino gestMag = new GestoreMagazzino(gestoreDB, resources);
            return gestMag.GetMagazzini();

        }

        [HttpPost]
        public ResponseAnteprima AnteprimaMappatura(MappaturaModel mappatura)
        {

            MagazzinoMappaturaExt gestoreMappatura = new MagazzinoMappaturaExt(gestoreDB);
            String errorMessage = "";
            ResponseAnteprima res = new ResponseAnteprima();
            try
            {
                gestoreMappatura.Id_azienda = gestoreDB.GetAziendaSelezionata();
                foreach (ComponenteMappaturaModel c in mappatura.Elementi!)
                {
                    if (c.Codice != "" && c.Elemento == "MAGAZZINO")
                        gestoreMappatura.Magazzino = c.Codice;

                    if (c.Codice != "" && c.Elemento == "ZONA")
                        gestoreMappatura.setZona(c.Codice, c.Quantita);

                    if (c.Codice != "" && c.Elemento == "CORRIDOIO")
                        gestoreMappatura.setCorridoio(c.Codice, c.Quantita);

                    if (c.Codice != "" && c.Elemento == "MONTANTE")
                        gestoreMappatura.setMontante(c.Codice, c.Quantita);

                    if (c.Codice != "" && c.Elemento == "PIANO")
                        gestoreMappatura.setPiano(c.Codice, c.Quantita);

                    if (c.Codice != "" && c.Elemento == "CELLA")
                        gestoreMappatura.setCella(c.Codice, c.Quantita);


                }

                if (!gestoreMappatura.validate(out errorMessage))
                {
                    res.Error = errorMessage;
                    return res;
                }

                if (gestoreMappatura.esplodiCodici(true))
                {
                    res.SerializedResult = gestoreMappatura.SerializedCodes;
                }

            }
            catch (Exception e)
            {
                //return new HttpStatusCodeResult(HttpStatusCode.BadRequest, "Bad Request");

                res.SerializedResult = "";
                res.Error = e.Message;
            }
            gestoreMappatura.close();

            return res;

        }


        [HttpPost]
        public ResponseAnteprima CreaMappatura(Dictionary<String, String> codici)
        {
            MagazzinoMappaturaExt gestoreMappatura = new MagazzinoMappaturaExt(gestoreDB);
            gestoreMappatura.Id_azienda = gestoreDB.GetAziendaSelezionata();
            ResponseAnteprima res = new ResponseAnteprima();

            MappaturaModel aDescElementi = Newtonsoft.Json.JsonConvert.DeserializeObject<MappaturaModel>(codici["jsonDescs"])!;
            try
            {
                gestoreMappatura.DescMagazzino = "";
                foreach (ComponenteMappaturaModel c in aDescElementi.Elementi!)
                {

                    if (c.Codice != "" && c.Elemento == "ZONA")
                        gestoreMappatura.DescZona = c.Descrizione;

                    if (c.Codice != "" && c.Elemento == "CORRIDOIO")
                        gestoreMappatura.DescCorridoio = c.Descrizione;

                    if (c.Codice != "" && c.Elemento == "MONTANTE")
                        gestoreMappatura.DescMontante = c.Descrizione;

                    if (c.Codice != "" && c.Elemento == "PIANO")
                        gestoreMappatura.DescPiano = c.Descrizione;

                    if (c.Codice != "" && c.Elemento == "CELLA")
                        gestoreMappatura.DescCella = c.Descrizione;


                }

                gestoreMappatura.SerializedCodes = codici["jsonCodes"];

                gestoreMappatura.User = User.Claims.First(c => c.Type == ClaimTypes.NameIdentifier).Value;

                String result = gestoreMappatura.create();

                if (string.IsNullOrEmpty(result))
                {
                    res.Error = resources[Res.MSG_ERRORE_NON_GESTITO_CREAZIONE_CELLE].Value;
                }


            }
            catch (Exception e)
            {
                //return new HttpStatusCodeResult(HttpStatusCode.BadRequest, "Bad Request");

                res.SerializedResult = "";
                res.Error = e.Message;
            }
            gestoreMappatura.close();

            return res;

        }


        [HttpGet]
        public List<CellaModel> GetCelle()
        {
            GestoreMagazzino gestMag = new GestoreMagazzino(gestoreDB, resources);
            return gestMag.GetCelle();

        }


        [HttpPost]
        public ActionResult StampaEtichetteCelle(StampaEtichetteCelleModel param)
        {
            GestoreMagazzino gestMag = new GestoreMagazzino(gestoreDB, resources);
            List<CellaModel> celle = gestMag.GetCelle(param.IdCelle);
            try
            {

                EtichetteCelleReport report = new EtichetteCelleReport(param, celle);


                report.ShowInPreviewer();
                byte[] pdfBytes = report.GeneratePdf();

                if (param.ParametriGeneraliStampa.Id_stampante != null)
                {
                    List<byte[]> pagine = report.GenerateImages().ToList();
                    GestoreStampa gestStampa = new GestoreStampa(resources, gestoreDB, pagine, param.ParametriGeneraliStampa);
                    gestStampa.StampaSuStampante();
                    return new ObjectResult(true);
                }

                return new ObjectResult(Convert.ToBase64String(pdfBytes));

                //MemoryStream ms = new MemoryStream(pdfBytes);
                //return new FileStreamResult(ms, "application/pdf");
            }
            catch (Exception ex)
            {

                ObjectResult err = new ObjectResult(ex.Message);
                err.StatusCode = StatusCodes.Status500InternalServerError;
                return err;
            }

        }
        [HttpPost]
        public ActionResult StampaEtichetteUDC(StampaEtichetteUdcModel param)
        {
            GestoreMagazzino gestMag = new GestoreMagazzino(gestoreDB, resources);
            List<UdcModel> udc = gestMag.GetUdc(param.IdUdc);
            try
            {

                EtichetteUDCReport report = new EtichetteUDCReport(param, udc);


                //report.ShowInPreviewer();
                byte[] pdfBytes = report.GeneratePdf();

                if (param.ParametriGeneraliStampa.Id_stampante != null)
                {
                    List<byte[]> pagine = report.GenerateImages().ToList();
                    GestoreStampa gestStampa = new GestoreStampa(resources, gestoreDB, pagine, param.ParametriGeneraliStampa);
                    gestStampa.StampaSuStampante();
                    return new ObjectResult(true);
                }

                return new ObjectResult(Convert.ToBase64String(pdfBytes));

                //MemoryStream ms = new MemoryStream(pdfBytes);
                //return new FileStreamResult(ms, "application/pdf");
            }
            catch (Exception ex)
            {

                ObjectResult err = new ObjectResult(ex.Message);
                err.StatusCode = StatusCodes.Status500InternalServerError;
                return err;
            }

        }

        [HttpDelete]
        public ActionResult<bool> EliminaCelle(List<CellaModel> celle)
        {
            GestoreMagazzino gestMag = new GestoreMagazzino(gestoreDB, resources);
            return gestMag.EliminaCelle(celle);
        }


        [HttpGet]
        public List<TipoUdcModel> GetTipoUdc()
        {
            GestoreMagazzino gestMag = new GestoreMagazzino(gestoreDB, resources);
            return gestMag.GetTipoUdc();
        }


        [HttpPost]
        public ActionResult<bool> GeneraUdc(GeneraUdcModel param)
        {
            GestoreMagazzino gestMag = new GestoreMagazzino(gestoreDB, resources);
            return gestMag.GeneraUdc(param);
        }


        [HttpGet]
        public List<UdcModel> GetUdc()
        {

            GestoreMagazzino gestMag = new GestoreMagazzino(gestoreDB, resources);
            return gestMag.GetUdc();

        }


    }
}

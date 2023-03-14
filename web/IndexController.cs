using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using web.Autenticazione.Models;

namespace web
{
    [Route("")]
    [ApiController]
    public class IndexController : ControllerBase
    {
        [HttpGet]
        public String Get() {
            return "OWS is running!";
        }
    }
}

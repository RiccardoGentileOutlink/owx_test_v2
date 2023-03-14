using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using web.Autenticazione.Models;
using web.Generale;

public class GestoreBasicAuthentication : AuthenticationHandler<AuthenticationSchemeOptions>
{

    private static string JWT_SECRET = "OWS_secretJwt!2023";


    public GestoreBasicAuthentication(IOptionsMonitor<AuthenticationSchemeOptions> options,ILoggerFactory logger,UrlEncoder encoder,ISystemClock clock): base(options, logger, encoder, clock)
    {

    }


    protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        if (!Request.Headers.ContainsKey("Authorization"))
            return AuthenticateResult.Fail("Missing Authorization Header");
        UtenteModel? user = null;
        try
        {
            AuthenticationHeaderValue authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
          
            string? token = authHeader.Parameter;
            if (token != null)
            {
                GestoreDB db = new GestoreDB(Request.HttpContext.RequestServices.GetService<IHttpContextAccessor>());
                Dictionary<string, object> param = new Dictionary<string, object>();
                param.Add("token", token);
                user = db.GetRecord<UtenteModel>("Select  * from utente where token=@token and coalesce(eliminato,0)=0 and attivo=1", param);
            }
            
            
        }
        catch
        {
            return AuthenticateResult.Fail("Invalid Authorization Header");
        }
        if (user == null)
        {
            return AuthenticateResult.Fail("Invalid user token");
        }
            
        var claims = new Claim[] {
                new Claim(ClaimTypes.NameIdentifier, user.Id_utente.ToString()),
                new Claim(ClaimTypes.Name, user.Username!),
                new Claim(ClaimTypes.Role, user.Tipo_utente.ToString()),
            };
        var identity = new ClaimsIdentity(claims, Scheme.Name);
        var principal = new ClaimsPrincipal(identity);
        var ticket = new AuthenticationTicket(principal, Scheme.Name);
        return AuthenticateResult.Success(ticket);
    }

    public static string CreaTokenJwt(UtenteModel ut)
    {
        JwtSecurityTokenHandler tokenJwt = new JwtSecurityTokenHandler();
        byte[] secret = Encoding.ASCII.GetBytes(JWT_SECRET);
        var claims = new Claim[] {
                        new Claim(ClaimTypes.NameIdentifier, ut.Id_utente.ToString()),
                        new Claim(ClaimTypes.Name, ut.Nome??ut.Username + " " +ut.Cognome??""),
                        new Claim(ClaimTypes.Email, ut.Mail??""),
                        new Claim(ClaimTypes.Role, ut.Tipo_utente.ToString()),
                     };

        SecurityTokenDescriptor desc = new SecurityTokenDescriptor();
        desc.Subject = new ClaimsIdentity(claims);
        desc.Expires = DateTime.Now.AddYears(50);//non lo faccio scadere mai
        desc.SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(secret), SecurityAlgorithms.HmacSha256Signature);
        
        SecurityToken token = tokenJwt.CreateToken(desc);

        return tokenJwt.WriteToken(token);
    }




}

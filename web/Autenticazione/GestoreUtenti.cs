using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using System.Security.Cryptography;
using System.Text;
using System.Transactions;
using web.Autenticazione.Models;
using web.Generale;

namespace web.Autenticazione
{
    public class GestoreUtenti
    {
        private GestoreDB db;
        private IStringLocalizer<Res> resources;

        public GestoreUtenti(GestoreDB db, IStringLocalizer<Res> resources)
        {
            this.db = db;
            this.resources = resources;
        }

        internal ActionResult<UtenteModel> CreaUtente(UtenteModel utente)
        {
            try
            {

                using (TransactionScope scope = db.CreaTransazione())
                {

                    Dictionary<string, object> parametri = new Dictionary<string, object>();
                    parametri.Add("username", utente.Username!);
                    if (db.GetRecord<UtenteModel>("select * from utente where username=@username and coalesce(eliminato,0)=0", parametri) != null)
                    {
                        return new ConflictObjectResult(resources[Res.MSG_USERNAME_GIA_UTILIZZATO].Value);
                    }

                    utente.Data_ins = DateTime.Now;

                    Dictionary<string, object> parametriIns = utente.GetParametriLogInsert(db);
                    parametriIns.Add("nome", utente.Nome!);
                    parametriIns.Add("cognome", utente.Cognome!);
                    parametriIns.Add("mail", utente.Mail!);
                    parametriIns.Add("username", utente.Username!);
                    parametriIns.Add("password", Encryption.Encrypt(utente.Password!));
                    parametriIns.Add("attivo", utente.Attivo);
                    parametriIns.Add("tipo_utente", utente.Tipo_utente!);
                    //parametriIns.Add("data_ins", utente.Data_ins!);
                    //parametriIns.Add("id_utente_ins", db.GetIdUtente());



                    int idUtenteNew = db.Insert(db.CostruisciQueryInsert("utente", parametriIns), parametriIns, "select top 1 id_utente from utente order by data_ins desc");

                    scope.Complete();

                    utente.Id_utente = idUtenteNew;
                    utente.Password = null;
                    return utente;
                }
            }
            catch (Exception ex)
            {
                ObjectResult err = new ObjectResult(ex.Message);
                err.StatusCode = StatusCodes.Status500InternalServerError;
                return err;
            }


        }



        internal ActionResult<UtenteModel> ModificaUtente(UtenteModel utente)
        {
            try
            {

                using (TransactionScope scope = db.CreaTransazione())
                {


                    if (db.GetRecord<UtenteModel>("select * from utente where id_utente=" + utente.Id_utente + " and coalesce(eliminato,0)=0", null) == null)
                    {
                        return new NotFoundObjectResult(resources[Res.MSG_ELEMENTO_NON_TROVATO].Value);
                    }

                    utente.Data_agg = DateTime.Now;

                    Dictionary<string, object> parametriUpd = new Dictionary<string, object>();
                    parametriUpd.Add("nome", utente.Nome!);
                    parametriUpd.Add("cognome", utente.Cognome!);
                    parametriUpd.Add("mail", utente.Mail!);
                    parametriUpd.Add("username", utente.Username!);
                    if (utente.Password != null && utente.Password != "")
                    {
                        parametriUpd.Add("password", Encryption.Encrypt(utente.Password!));
                    }

                    parametriUpd.Add("attivo", utente.Attivo);
                    parametriUpd.Add("tipo_utente", utente.Tipo_utente!);
                    parametriUpd.Add("data_agg", DateTime.Now);
                    parametriUpd.Add("id_utente_agg", db.GetIdUtente());

                    Dictionary<string, object> parametriWhere = new Dictionary<string, object>();
                    parametriWhere.Add("id_utente", utente.Id_utente);



                    db.Update(db.CostruisciQueryUpdate("utente", parametriUpd, parametriWhere), parametriUpd, parametriWhere);

                    scope.Complete();
                    utente.Password = null;
                    return utente;
                }
            }
            catch (Exception ex)
            {
                ObjectResult err = new ObjectResult(ex.Message);
                err.StatusCode = StatusCodes.Status500InternalServerError;
                return err;
            }

        }


        internal UtenteModel? GetUtente(int idUtente)
        {

            UtenteModel? rec = db.GetRecord<UtenteModel>("Select * from utente where coalesce(eliminato,0)=0 and id_utente=" + idUtente);
            if (rec != null)
            {
                rec.Password = null;
            }
            return rec;
        }

        internal List<UtenteModel> GetUtenti()
        {

            List<UtenteModel> lista = db.GetListRecord<UtenteModel>("Select * from utente where coalesce(eliminato,0)=0");

            //rimuovo la password dai risultati
            foreach (UtenteModel ut in lista)
            {
                ut.Password = null;
            }

            return lista;
        }

        internal ActionResult<UtenteModel?> Login(string username, string password)
        {

            Dictionary<string, object> parametri = new Dictionary<string, object>();
            parametri.Add("username", username);
            UtenteModel? ut = db.GetRecord<UtenteModel>("Select * from utente where attivo=1 and username=@username and coalesce(eliminato,0)=0", parametri);
            if (ut != null)
            {
                //controllo che l'utente abbia la passord passata (la password viene passata in chiaro tanto chi tenta la login sa che password ha inserito mentre viene salvata criptata nel db e quind iva fatto il controllo con la password criptata)
                //NB non uso la ddl di Enea perchè la ritengo poco sicura: se qualcuono la prende e la utilizza potrebbe decriptare tutte le password

                string passwordCriptata = Encryption.Encrypt(password);
                if (ut.Password == passwordCriptata)
                {
                    ut.Password = "";

                    ut.Token = GestoreBasicAuthentication.CreaTokenJwt(ut);

                    Dictionary<string, object> parametriUpd = new Dictionary<string, object>();
                    parametriUpd.Add("token", ut.Token);
                    parametriUpd.Add("data_ultimo_accesso", DateTime.Now);

                    Dictionary<string, object> parametrWhere = new Dictionary<string, object>();
                    parametrWhere.Add("id_utente", ut.Id_utente);
                    try
                    {
                        using (TransactionScope scope = db.CreaTransazione())
                        {
                            db.Update(db.CostruisciQueryUpdate("utente", parametriUpd, parametrWhere), parametriUpd, parametrWhere);
                            scope.Complete();
                        }
                    }
                    catch (Exception ex)
                    {
                        ObjectResult err = new ObjectResult(ex.Message);
                        err.StatusCode = StatusCodes.Status500InternalServerError;
                        return err;
                    }

                    return ut;
                }


            }

            ObjectResult err2 = new ObjectResult(resources[Res.MSG_UTENTE_PASSWORD_ERRATI].Value);
            err2.StatusCode = StatusCodes.Status401Unauthorized;
            return err2;
        }

        internal ActionResult<bool> EliminaUtente(UtenteModel utente)
        {
            try
            {

                using (TransactionScope scope = db.CreaTransazione())
                {


                    if (db.GetRecord<UtenteModel>("select * from utente where id_utente=" + utente.Id_utente + " and coalesce(eliminato,0)=0", null) == null)
                    {
                        return new NotFoundObjectResult(resources[Res.MSG_ELEMENTO_NON_TROVATO].Value);
                    }

                    Dictionary<string, object> parametriUpd = new Dictionary<string, object>();
                    parametriUpd.Add("eliminato", true);
                    parametriUpd.Add("data_agg", DateTime.Now);

                    Dictionary<string, object> parametriWhere = new Dictionary<string, object>();
                    parametriWhere.Add("id_utente", utente.Id_utente);

                    db.Update(db.CostruisciQueryUpdate("utente", parametriUpd, parametriWhere), parametriUpd, parametriWhere);

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

        internal List<AziendaModel> GetAziende()
        {
            List<AziendaModel> lista = db.GetListRecord<AziendaModel>("Select * from azienda");
            return lista;
        }
    }


    internal class Encryption
    {
        private static string EncryptionKey = "OWS";
        public static string Encrypt(string clearText)
        {

            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }

        public static string Decrypt(string cipherText)
        {

            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }
    }
}

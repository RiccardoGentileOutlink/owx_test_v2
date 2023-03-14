using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using web.Generale;

namespace web.Autenticazione.Models
{

    public enum TipoUtente { admin=1,responsabileMagazzino=2,operatoreMagazzino=3}

    public class UtenteModel:BasicModel
    {

        public UtenteModel()
        {
            NomeTabella = "utente";
            GestioneAzienda = false;
        }


        public int Id_utente {get; set;}

        public String? Nome { get; set; }

        public String? Cognome { get; set; }

        public String? Mail { get; set; }

        public String? Username{get; set;}

        public String? Password{get; set;}

        public String? Token{get; set;}

        public bool Attivo { get; set; }

        public TipoUtente Tipo_utente { get; set; }

        public DateTime? Data_ultimo_accesso { get;set ; }


        public override void FromReader(SqlDataReader reader)
        {
            FromReaderCommon(reader);
           
            Id_utente = GetIntNonNullable(reader,nameof(Id_utente));
            Nome = GetString(reader,nameof(Nome));
            Cognome = GetString(reader,nameof(Cognome));
            Mail = GetString(reader,nameof(Mail));
            Username = GetString(reader,nameof(Username));
            Password = GetString(reader,nameof(Password));
            Token = GetString(reader,nameof(Token));
            Attivo = GetBoolean(reader, nameof(Attivo))??false;
            Tipo_utente = (TipoUtente)GetInt(reader,nameof(Tipo_utente));
            Data_ultimo_accesso = GetDateTime(reader,nameof(Data_ultimo_accesso));
           
           
           
        }

    
    }
}
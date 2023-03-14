using Microsoft.Extensions.Localization;
using System.Drawing;
using System.Drawing.Printing;
using web.Configurazione.Models;
using web.Generale;
using web.Generale.Reports;

namespace web.Configurazione
{

    public class Stampa
    {
        public static string ETICHETTA_UDC = "ETUDC";
        public static string ETICHETTA_CELLA = "ETCELLA";
    }

    public class GestoreStampa
    {
        public static bool InviaComandoPrint = true;//parametro per evitare che in sviluppo venga eseguita la stampa nella stampante (Per provare a stampare commentare su Program.cs dove viene impostato a false

        private readonly IStringLocalizer<Res> resources;
        private readonly GestoreDB db;
        private readonly List<byte[]> pagine;
        private readonly ParametriGeneraliStampaModel paramStampa;
        private int currentPage = 0;


        public GestoreStampa(IStringLocalizer<Res> resources, GestoreDB db, List<byte[]> pagine, ParametriGeneraliStampaModel paramStampa)
        {
            this.resources = resources;
            this.db = db;
            this.pagine = pagine;
            this.paramStampa = paramStampa;
        }

        public void StampaSuStampante()
        {
            if (OperatingSystem.IsWindows())
            {
                StampanteModel? stampante = db.GetRecord<StampanteModel>("select * from stampante where id_stampante=" + paramStampa.Id_stampante, ignoraAzienda: true);
                if (stampante != null)
                {
                    //eseguo la stampa
                    PrintDocument docStampa = new PrintDocument();
                    PrinterResolution pr = new PrinterResolution();
                    pr.Kind = PrinterResolutionKind.High;
                    docStampa.PrintPage += DocStampa_PrintPage;
                    docStampa.PrinterSettings.PrinterName = stampante!.Nome_stampante!;
                    docStampa.PrinterSettings.Copies = (short)(paramStampa.Quantita ?? 1);
                    //  docStampa.DefaultPageSettings.PaperSize = new PaperSize("A",394, 788);
                    docStampa.DefaultPageSettings.Margins.Left = 0;
                    docStampa.DefaultPageSettings.Margins.Right = 0;
                    docStampa.DefaultPageSettings.Margins.Top = 0;
                    docStampa.DefaultPageSettings.Margins.Bottom = 0;
                    docStampa.DefaultPageSettings.PrinterResolution = pr;
                    docStampa.DefaultPageSettings.Landscape = paramStampa.Orientamento == "O";

                    docStampa.DocumentName = "ASP.NET printer";

                    if (InviaComandoPrint)
                    {
                        docStampa.Print();
                    }


                }
                else
                {
                    throw new Exception(resources[Res.MSG_STAMPANTE_NON_TROVATA].Value);
                }
            }
            else
            {
                throw new Exception(resources[Res.MSG_FUNZIONE_NON_SUPPORTATA].Value);
            }


        }


        /*
        *PER STAMPARE CORRETTAMENTE E' IMPORTANTE CHE LA STAMPANTE SUL SERVER ABBIA LA DIMESNIONE DELLA PAGINA CORRETTA (Dimensione etichette) DI DEFAULT 
        *L'immmagine dell'etichgetta si può ridimensionare calcolando la dimensione in larghezza e altezza a partire da quella delle etichette (ev.MarginBounds.Width,ev.MarginBounds.Height)
        *ATTENZIONE: la dimensione che arriva su e è in centesimi di pollici mentre la dimensione da passare a gfx.DrawImage(img,0,0,200,100) può essere in millimetri ( gfx.PageUnit = GraphicsUnit.Millimeter;) e qundi va fatta l'opportuna conversione
        */
        private void DocStampa_PrintPage(object sender, PrintPageEventArgs e)
        {
            //throw new Exception("per non stampare");
            if (OperatingSystem.IsWindows())
            {
                e.PageSettings.PrinterResolution.X = 300;
                e.PageSettings.PrinterResolution.Y = 300;


                var gfx = e.Graphics;
                gfx!.PageUnit = GraphicsUnit.Millimeter;

                MemoryStream stream = new MemoryStream(pagine[currentPage]);

                Image img = Image.FromStream(stream);
                stream.Close();
                int larghezzaCentesimiPollici = e.MarginBounds.Width;
                int altezzaCentesimiPollici = e.MarginBounds.Height;

                int larghezzaMillimetri = (int)(larghezzaCentesimiPollici * 2.54 / 100) * 10;//da centesimi di pollice a millimetri
                int altezzaMillimetri = (int)(altezzaCentesimiPollici * 2.54 / 100) * 10;//da centesimi di pollice a millimetri

                gfx.DrawImage(img, 0, 0, larghezzaMillimetri, altezzaMillimetri);

                img.Dispose();
                currentPage++;
                if (currentPage < pagine.Count)
                {
                    e.HasMorePages = true;
                }
                else
                {
                    e.HasMorePages = false;
                }
            }


        }
    }
}

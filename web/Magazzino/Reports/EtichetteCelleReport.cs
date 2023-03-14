using BarcodeLib;
using QuestPDF.Fluent;
using QuestPDF.Infrastructure;
using System.Drawing;
using web.Generale.Reports;
using web.Magazzino.Models;
using web.Magazzino.Models.Params;

namespace web.Magazzino.Reports
{
    public class EtichetteCelleReport : BasicReport
    {
        public StampaEtichetteCelleModel modello;
        public List<CellaModel> celle;

        private int fontSizeTesto = 70;


        public EtichetteCelleReport(StampaEtichetteCelleModel modello, List<CellaModel> celle) : base(modello.ParametriGeneraliStampa)
        {
            this.modello = modello;
            this.celle = celle;

            fontSizeTesto = (int)(pageSize.Width * 0.08);

        }

        protected override void ComponiReport(IDocumentContainer container)
        {
            container
           .Page(page =>
           {
               page.Margin(0, Unit.Millimetre);
               page.Size(pageSize);
               // page.Header().Height(50).Background(Colors.Yellow.Medium);
               page.Content().Element(_componiContenuto);
               // page.Footer().Height(50).Background(Colors.Grey.Lighten1);
           });
        }


        private void _componiContenuto(IContainer container)
        {

            float padding = (float)(pageSize.Width * 0.02);
            int altezzaBarcode = (int)(pageSize.Height * 0.5);
            int larghezzaBarcode = (int)(pageSize.Width);

            container.AlignCenter().AlignMiddle().Column(column =>
            {
                bool first = true;
                foreach (CellaModel cella in celle)
                {
                    if (!first)
                    {
                        column.Item().PageBreak();
                    }
                    else
                    {
                        first = false;
                    }
                    // column.Item().AlignCenter().Text(cella.Cod_alias).FontSize(fontSizeTesto);

                    //creo l'immagine del barcode usando una libreria esterna invece di usare i fonts perchè i lettori spesso non riescono a leggere i barcode generati con i font (dimensione linee, checksum ecc...)
                    Barcode b = new Barcode();
                    //b.Width = larghezzaBarcode;
                    b.AspectRatio = 3;


                    Image img = b.Encode(BarcodeLib.TYPE.CODE128A, cella.Cod);
                    column.Item().PaddingLeft(0).PaddingRight(0).Image(b.Encoded_Image_Bytes);
                    img.Dispose();

                    //column.Item().Text("*" + cella.Cod + "*").FontFamily("Libre Barcode 128").FontSize(fontSizeBarcode).LineHeight(0.5f);
                    //column.Item().Text("*" + cella.Cod + "*").FontFamily("Libre Barcode 128").FontSize(fontSizeBarcode).LineHeight(0.5f);
                    //column.Item().Text("*" + cella.Cod + "*").FontFamily("Libre Barcode 128").FontSize(fontSizeBarcode).LineHeight(0.5f);
                    //column.Item().Text("*" + cella.Cod + "*").FontFamily("Libre Barcode 39").FontSize(fontSizeBarcode).LineHeight(0.5f);

                    column.Item().AlignCenter().Text(cella.Cod).FontSize(fontSizeTesto);

                }
            });
        }


    }



}

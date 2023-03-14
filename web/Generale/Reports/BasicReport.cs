using QuestPDF.Drawing;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

namespace web.Generale.Reports
{
    public abstract class BasicReport: IDocument
    {

        protected PageSize pageSize;

        public BasicReport(ParametriGeneraliStampaModel param)
        {
            this.pageSize = GetPageSize(param);
        }

        public void Compose(IDocumentContainer container)
        {
            ComponiReport(container);
        }

        protected abstract void ComponiReport(IDocumentContainer container);

        public DocumentMetadata GetMetadata()
        {
            return DocumentMetadata.Default;
        }

        protected PageSize GetPageSize(ParametriGeneraliStampaModel param)
        {
            if (param.Orientamento == ParametriGeneraliStampaModel.ORIENTAMENTO_ORIZZONTALE)
            {
                if (param.DimensionePagina == ParametriGeneraliStampaModel.DIMENSIONE_A4)
                {
                    return PageSizes.A4.Landscape();

                }
                if (param.DimensionePagina == ParametriGeneraliStampaModel.DIMENSIONE_A5)
                {
                    return PageSizes.A5.Landscape();

                }
                if (param.DimensionePagina == ParametriGeneraliStampaModel.DIMENSIONE_A6)
                {
                    return PageSizes.A6.Landscape();

                }
            }
            else
            {
                if (param.DimensionePagina == ParametriGeneraliStampaModel.DIMENSIONE_A4)
                {
                    return PageSizes.A4;

                }
                if (param.DimensionePagina == ParametriGeneraliStampaModel.DIMENSIONE_A5)
                {
                    return PageSizes.A5;

                }
                if (param.DimensionePagina == ParametriGeneraliStampaModel.DIMENSIONE_A6)
                {
                    return PageSizes.A6;

                }
            }

            return PageSizes.A4;
        }
    }
}

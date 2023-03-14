using web.Generale.Reports;

namespace web.Magazzino.Models.Params
{



    public class StampaEtichetteCelleModel
    {
        public List<string>? IdCelle { get; set; }

        public ParametriGeneraliStampaModel ParametriGeneraliStampa { get; set; }

        public StampaEtichetteCelleModel()
        {
            ParametriGeneraliStampa = new ParametriGeneraliStampaModel();
        }

    }

    public class StampaEtichetteUdcModel
    {
        public List<int>? IdUdc { get; set; }

        public ParametriGeneraliStampaModel ParametriGeneraliStampa { get; set; }

        public StampaEtichetteUdcModel()
        {
            ParametriGeneraliStampa = new ParametriGeneraliStampaModel();
        }

    }
}
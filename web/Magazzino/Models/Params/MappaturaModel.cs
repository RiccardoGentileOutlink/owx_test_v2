namespace web.Magazzino.Models.Params
{
    public class MappaturaModel
    {
        public List<ComponenteMappaturaModel>? Elementi { get; set; }
    }

    public class ComponenteMappaturaModel
    {
        public string? Elemento { get; set; }
        public string? Codice { get; set; }
        public int Quantita { get; set; }
        public string? Descrizione { get; set; }

    }

    public class ResponseAnteprima
    {
        public string? SerializedResult { get; set; }
        public string? Error { get; set; }
    }
}

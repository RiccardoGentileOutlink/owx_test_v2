using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Localization;
using System.Globalization;
using web.Configurazione;
using web.Generale;

namespace web
{
    public class Program
    {
        public static void Main(string[] args)
        {
            AppDomain.CurrentDomain.SetData("root", Environment.CurrentDirectory);

            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddLocalization(options => options.ResourcesPath = "Resources");

            builder.Services.Configure<RequestLocalizationOptions>(options =>
            {
                var supportedCultures = new List<CultureInfo>
                    {
                        new CultureInfo("it-IT"),
                        new CultureInfo("en-US")
                    };

                options.DefaultRequestCulture = new RequestCulture("it-IT");
                options.SupportedCultures = supportedCultures;
                options.SupportedUICultures = supportedCultures;
            });

            builder.Services.AddControllers();
            builder.Services.AddHttpContextAccessor();
            builder.Services.AddScoped<GestoreDB>();

            builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, GestoreBasicAuthentication>("BasicAuthentication", null);

            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var MyAllowSpecificOrigins = "_myAllowSpecificOrigins";
            builder.Services.AddCors(options =>
            {
                options.AddPolicy(name: MyAllowSpecificOrigins,
                                  policy =>
                                  {
                                      policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();

                                  });
            });

            var app = builder.Build();

            var supportedCultures = new[] { "it-IT", "en-US" };
            var localizationOptions = new RequestLocalizationOptions().SetDefaultCulture(supportedCultures[0]).AddSupportedCultures(supportedCultures).AddSupportedUICultures(supportedCultures);

            app.UseRequestLocalization(localizationOptions);

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
                GestoreStampa.InviaComandoPrint = false;
            }


            app.UseCors(MyAllowSpecificOrigins);
            app.UseAuthentication();
            app.UseAuthorization();

            //imposto la stringa di Connessione sul GestoreDB
            GestoreDB.ConnectionString = app.Configuration.GetConnectionString("OWS");
            GestoreDB.tipoPlaceHolderParametri = GestoreDB.TipoPlaceHolderParametri.Chiocciola;//per ora di default chiocciola perchè il db è SQL SERVER

            app.MapControllers();
            // FontManager.RegisterFont(File.OpenRead("Resources\\Fonts\\LibreBarcode128-Regular.ttf"));
            // FontManager.RegisterFont(File.OpenRead("Resources\\Fonts\\LibreBarcode39-Regular.ttf"));
            QuestPDF.Settings.DocumentLayoutExceptionThreshold = 10000;
            app.Run();


        }
    }
}
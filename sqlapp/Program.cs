using sqlapp.Services;

var builder = WebApplication.CreateBuilder(
    
    new WebApplicationOptions()
    {
        EnvironmentName =
        Microsoft.Extensions.Hosting.Environments.Development
    }
    
  );

builder.Services.AddTransient<IProductService, ProductService>();

builder.Services.AddRazorPages();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();

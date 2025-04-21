using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;
using RedirectService.Services;
using System;
using System.Net.Http;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Redirect Service API", Version = "v1" });
});

// Configure HttpClient for URL Service
builder.Services.AddHttpClient("UrlService", client =>
{
    client.BaseAddress = new Uri(builder.Configuration["Services:UrlService"]);
});

// Configure HttpClient for Analytics Service
builder.Services.AddHttpClient("AnalyticsService", client =>
{
    client.BaseAddress = new Uri(builder.Configuration["Services:AnalyticsService"]);
});

// Register services
builder.Services.AddScoped<IRedirectService, RedirectService.Services.RedirectService>();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();
using Microsoft.EntityFrameworkCore; // Ensure this is included
using Microsoft.OpenApi.Models;
using UrlService.Data; // Add this using directive for AddSqlServer extension method
using Microsoft.Extensions.DependencyInjection;
using UrlService.Services;
using UrlService.DTOs;
using UrlService.Models;
using System;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "URL Service API", Version = "v1" });
});

// Add SQL Server
builder.Services.AddDbContext<UrlDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"))); // Ensure Microsoft.EntityFrameworkCore.SqlServer package is installed

// Register services
builder.Services.AddScoped<IUrlService, UrlManagementService>();

// Add CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowAll");
app.UseAuthorization();
app.MapControllers();

app.Run();
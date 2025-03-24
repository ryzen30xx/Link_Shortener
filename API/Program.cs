using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using API.Models;

var builder = WebApplication.CreateBuilder(args);

// ✅ Load configuration settings
var configuration = builder.Configuration;

// ✅ Enable CORS to allow Flutter to connect
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins",
        policy => policy.AllowAnyOrigin()  // Allows requests from any origin
                        .AllowAnyMethod()  // Allows GET, POST, PUT, DELETE, etc.
                        .AllowAnyHeader()); // Allows any headers (like Authorization)
});

// ✅ Register controllers
builder.Services.AddControllers();

// ✅ Enable Swagger for API documentation
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<ApiDbContext>(options =>
    options.UseSqlServer(
        configuration.GetConnectionString("DefaultConnection"),
        sqlServerOptions => sqlServerOptions.ExecutionStrategy(c => new SqlServerRetryingExecutionStrategy(c))
    )
);


var app = builder.Build();

// ✅ Enable CORS before routing
app.UseCors("AllowAllOrigins");

// ✅ Enable Swagger UI in Development Mode
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// ✅ Force HTTPS Redirection
app.UseHttpsRedirection();

// ✅ Authentication & Authorization
app.UseAuthorization();

// ✅ Map API Controllers
app.MapControllers();

// ✅ Run the API
app.Run();

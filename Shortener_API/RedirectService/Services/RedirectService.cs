using System;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace RedirectService.Services
{
    public class RedirectService : IRedirectService
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly ILogger<RedirectService> _logger;

        public RedirectService(IHttpClientFactory httpClientFactory, ILogger<RedirectService> logger)
        {
            _httpClientFactory = httpClientFactory;
            _logger = logger;
        }

        public async Task<string> GetOriginalUrlAsync(string shortCode)
        {
            try
            {
                var client = _httpClientFactory.CreateClient("UrlService");
                var response = await client.GetAsync($"api/urls/{shortCode}");

                if (!response.IsSuccessStatusCode)
                    return null;

                var urlData = await response.Content.ReadFromJsonAsync<UrlDto>();
                return urlData?.OriginalUrl;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting original URL for short code {ShortCode}", shortCode);
                return null;
            }
        }

        public async Task RecordRedirectAsync(string shortCode, string userAgent, string ipAddress)
        {
            try
            {
                var client = _httpClientFactory.CreateClient("AnalyticsService");

                var redirectData = new
                {
                    ShortCode = shortCode,
                    UserAgent = userAgent,
                    IpAddress = ipAddress,
                    Timestamp = DateTime.UtcNow
                };

                var content = new StringContent(
                    JsonSerializer.Serialize(redirectData),
                    Encoding.UTF8,
                    "application/json");

                await client.PostAsync("api/analytics/record", content);
            }
            catch (Exception ex)
            {
                // Log but don't fail the redirect if analytics recording fails
                _logger.LogError(ex, "Error recording redirect for short code {ShortCode}", shortCode);
            }
        }

        private class UrlDto
        {
            public int Id { get; set; }
            public string ShortCode { get; set; }
            public string OriginalUrl { get; set; }
            public DateTime CreatedAt { get; set; }
            public string ShortUrl { get; set; }
        }
    }
}
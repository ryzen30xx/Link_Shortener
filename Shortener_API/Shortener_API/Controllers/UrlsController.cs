using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using UrlService.DTOs;
using UrlService.Services;

namespace UrlService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UrlsController : ControllerBase
    {
        private readonly IUrlService _urlService;
        private readonly IConfiguration _configuration;

        public UrlsController(IUrlService urlService, IConfiguration configuration)
        {
            _urlService = urlService;
            _configuration = configuration;
        }

        [HttpPost]
        public async Task<IActionResult> CreateShortUrl([FromBody] CreateUrlDto createUrlDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Check if custom code already exists
            if (!string.IsNullOrEmpty(createUrlDto.CustomCode))
            {
                bool exists = await _urlService.ShortCodeExistsAsync(createUrlDto.CustomCode);
                if (exists)
                    return Conflict(new { error = "Custom code already in use" });
            }

            var result = await _urlService.CreateShortUrlAsync(createUrlDto);

            // Add the full short URL
            string baseUrl = _configuration["BaseUrl"] ?? $"{Request.Scheme}://{Request.Host}";
            result.ShortUrl = $"{baseUrl}/{result.ShortCode}";

            return CreatedAtAction(nameof(GetUrl), new { shortCode = result.ShortCode }, result);
        }

        [HttpGet("{shortCode}")]
        public async Task<IActionResult> GetUrl(string shortCode)
        {
            var url = await _urlService.GetUrlByShortCodeAsync(shortCode);
            if (url == null)
                return NotFound(new { error = "URL not found" });

            // Add the full short URL
            string baseUrl = _configuration["BaseUrl"] ?? $"{Request.Scheme}://{Request.Host}";
            url.ShortUrl = $"{baseUrl}/{url.ShortCode}";

            return Ok(url);
        }

        [HttpGet]
        public async Task<IActionResult> GetAllUrls([FromQuery] int page = 1, [FromQuery] int pageSize = 10)
        {
            if (page < 1 || pageSize < 1 || pageSize > 100)
                return BadRequest(new { error = "Invalid pagination parameters" });

            var result = await _urlService.GetAllUrlsAsync(page, pageSize);

            // Add the full short URL to each item
            string baseUrl = _configuration["BaseUrl"] ?? $"{Request.Scheme}://{Request.Host}";
            foreach (var url in result.Items)
            {
                url.ShortUrl = $"{baseUrl}/{url.ShortCode}";
            }

            return Ok(result);
        }

        [HttpDelete("{shortCode}")]
        public async Task<IActionResult> DeleteUrl(string shortCode)
        {
            bool deleted = await _urlService.DeleteUrlAsync(shortCode);
            if (!deleted)
                return NotFound(new { error = "URL not found" });

            return Ok(new { message = "URL deleted successfully", shortCode });
        }
    }
}
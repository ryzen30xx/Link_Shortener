using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using RedirectService.Services;

namespace RedirectService.Controllers
{
    [ApiController]
    [Route("")]
    public class RedirectController : ControllerBase
    {
        private readonly IRedirectService _redirectService;

        public RedirectController(IRedirectService redirectService)
        {
            _redirectService = redirectService;
        }

        [HttpGet("{shortCode}")]
        public async Task<IActionResult> Redirect(string shortCode)
        {
            var originalUrl = await _redirectService.GetOriginalUrlAsync(shortCode);

            if (string.IsNullOrEmpty(originalUrl))
                return NotFound(new { error = "Short URL not found" });

            // Record the redirect (fire and forget)
            _ = _redirectService.RecordRedirectAsync(
                shortCode,
                Request.Headers["User-Agent"].ToString(),
                HttpContext.Connection.RemoteIpAddress?.ToString());

            return await Redirect(originalUrl);
        }
    }
}
using Microsoft.AspNetCore.Mvc;
using LinkService.Models;
using Microsoft.EntityFrameworkCore;

namespace LinkService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LinkController : ControllerBase
    {
        private readonly LinkDbContext _context;
        private readonly string _baseShortUrl = "http://localhost:5000/l/";

        public LinkController(LinkDbContext context)
        {
            _context = context;
        }

        // POST: api/link/shorten
        [HttpPost("shorten")]
        public async Task<IActionResult> ShortenLink([FromBody] LinkDto dto)
        {
            if (string.IsNullOrEmpty(dto.OriginalUrl))
            {
                return BadRequest(new { message = "originalUrl is required" });
            }

            var code = Guid.NewGuid().ToString().Substring(0, 8);
            var link = new Link
            {
                OriginalUrl = dto.OriginalUrl,
                ShortenedUrl = code,
                CreatedAt = DateTime.UtcNow
            };

            _context.Links.Add(link);
            await _context.SaveChangesAsync();

            return Ok(new { shortUrl = _baseShortUrl + code });
        }

        // GET: /l/{code}
        [HttpGet("/l/{code}")]
        public async Task<IActionResult> RedirectToOriginal(string code)
        {
            var link = await _context.Links.FirstOrDefaultAsync(l => l.ShortenedUrl == code);
            if (link == null)
            {
                return NotFound(new { message = "Short link not found." });
            }

            return Redirect(link.OriginalUrl);
        }
    }
}

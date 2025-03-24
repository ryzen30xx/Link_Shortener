using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using API.Models;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class URLsController : ControllerBase
    {
        private readonly ApiDbContext _context;

        public URLsController(ApiDbContext context)
        {
            _context = context;
        }

        // Hàm tạo Short_URL ngẫu nhiên
        private string GenerateShortUrl()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            Random random = new Random();
            return new string(Enumerable.Repeat(chars, 6)
                .Select(s => s[random.Next(s.Length)]).ToArray());
        }

        // GET: api/URLs
        [HttpGet]
        public async Task<ActionResult<IEnumerable<URLs>>> GetURLs()
        {
            return await _context.URLs.ToListAsync();
        }

        // GET: api/URLs/5
        // GET: api/URLs/{Origin_URL}
        [HttpGet("{*Origin_URL}")]
        public async Task<ActionResult<URLs>> GetURLs([FromRoute] string Origin_URL)
        {
            var urlEntry = await _context.URLs
                .Where(e => e.Origin_URL == Origin_URL)
                .FirstOrDefaultAsync();

            if (urlEntry == null)
            {
                return NotFound();
            }

            return urlEntry;
        }


        // PUT: api/URLs/5
        [HttpPut("{*Origin_URL}")]
        public async Task<IActionResult> PutURLs([FromRoute] string Origin_URL, URLs uRLs)
        {
            if (Origin_URL != uRLs.Origin_URL)
            {
                return BadRequest();
            }

            var existingUrl = await _context.URLs
                .Where(e => e.Origin_URL == Origin_URL)
                .FirstOrDefaultAsync();

            if (existingUrl == null)
            {
                return NotFound();
            }

            // Cập nhật thông tin
            existingUrl.Short_URL = uRLs.Short_URL;
            existingUrl.UserName = uRLs.UserName;
            existingUrl.Create_date = uRLs.Create_date;
            existingUrl.Expired_date = DateTime.Now.AddDays(7);

            _context.Entry(existingUrl).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!URLsExists(Origin_URL))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }


        // POST: api/URLs
        [HttpPost]
        public async Task<ActionResult<URLs>> PostURLs(URLs uRLs)
        {
            // Nếu Short_URL chưa có, tự động tạo
            if (string.IsNullOrEmpty(uRLs.Short_URL))
            {
                uRLs.Short_URL = GenerateShortUrl();
            }

            // Kiểm tra nếu Short_URL đã tồn tại, tạo lại đến khi có mã duy nhất
            while (_context.URLs.Any(e => e.Short_URL == uRLs.Short_URL))
            {
                uRLs.Short_URL = GenerateShortUrl();
            }

            _context.URLs.Add(uRLs);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (URLsExists(uRLs.Origin_URL))
                {
                    return Conflict(new { message = "Original URL already exists" });
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetURLs", new { id = uRLs.Origin_URL }, uRLs);
        }

        // DELETE: api/URLs/5
        // DELETE: api/URLs/{Origin_URL}
        [HttpDelete("{*Origin_URL}")]
        public async Task<IActionResult> DeleteURLs([FromRoute] string Origin_URL)
        {
            var urlEntry = await _context.URLs
                .Where(e => e.Origin_URL == Origin_URL)
                .FirstOrDefaultAsync();

            if (urlEntry == null)
            {
                return NotFound();
            }

            _context.URLs.Remove(urlEntry);
            await _context.SaveChangesAsync();

            return NoContent(); // 204 No Content
        }




        private bool URLsExists(string id)
        {
            return _context.URLs.Any(e => e.Origin_URL == id);
        }
    }
}

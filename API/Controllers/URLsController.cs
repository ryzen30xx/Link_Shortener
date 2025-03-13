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

        // GET: api/URLs
        [HttpGet]
        public async Task<ActionResult<IEnumerable<URLs>>> GetURLs()
        {
            return await _context.URLs.ToListAsync();
        }

        // GET: api/URLs/5
        [HttpGet("{id}")]
        public async Task<ActionResult<URLs>> GetURLs(int id)
        {
            var uRLs = await _context.URLs.FindAsync(id);

            if (uRLs == null)
            {
                return NotFound();
            }

            return uRLs;
        }

        // PUT: api/URLs/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutURLs(int id, URLs uRLs)
        {
            if (id != uRLs.URLId)
            {
                return BadRequest();
            }

            _context.Entry(uRLs).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!URLsExists(id))
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
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<URLs>> PostURLs(URLs uRLs)
        {
            _context.URLs.Add(uRLs);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetURLs", new { id = uRLs.URLId }, uRLs);
        }

        // DELETE: api/URLs/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteURLs(int id)
        {
            var uRLs = await _context.URLs.FindAsync(id);
            if (uRLs == null)
            {
                return NotFound();
            }

            _context.URLs.Remove(uRLs);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool URLsExists(int id)
        {
            return _context.URLs.Any(e => e.URLId == id);
        }
    }
}

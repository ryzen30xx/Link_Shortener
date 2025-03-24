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
    public class UsersController : ControllerBase
    {
        private readonly ApiDbContext _context;

        public UsersController(ApiDbContext context)
        {
            _context = context;
        }

        // GET: api/Users
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Users>>> GetUsers()
        {
            return await _context.Users.ToListAsync();
        }

        // GET: api/Users/{UserName}
        [HttpGet("{*UserName}")]
        public async Task<ActionResult<Users>> GetUsers(string UserName)
        {
            var users = await _context.Users.FindAsync(UserName);

            if (users == null)
            {
                return NotFound();
            }

            return users;
        }

        // PUT: api/Users/{UserName}
        [HttpPut("{*UserName}")]
        public async Task<IActionResult> PutUsers(string UserName, Users users)
        {
            if (UserName != users.UserName)
            {
                return BadRequest();
            }

            _context.Entry(users).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UsersExists(UserName))
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

        // POST: api/Users
        [HttpPost]
        public async Task<ActionResult<Users>> PostUsers(Users users)
        {
            _context.Users.Add(users);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (UsersExists(users.UserName))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetUsers", new { UserName = users.UserName }, users);
        }

        // DELETE: api/Users/{UserName}
        [HttpDelete("{*UserName}")]
        public async Task<IActionResult> DeleteUsers(string UserName)
        {
            var users = await _context.Users.FindAsync(UserName);
            if (users == null)
            {
                return NotFound();
            }

            _context.Users.Remove(users);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UsersExists(string UserName)
        {
            return _context.Users.Any(e => e.UserName == UserName);
        }
    }
}
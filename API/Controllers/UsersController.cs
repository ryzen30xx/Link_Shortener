using System.Linq;
using System.Threading.Tasks;
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

        // ✅ LOGIN ENDPOINT
        [HttpPost("login")]
        public async Task<ActionResult> Login([FromBody] LoginRequest model)
        {
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.UserName == model.Username && u.Password == model.Password);

            if (user == null)
            {
                return Unauthorized(new { message = "Invalid username or password" });
            }

            return Ok(new { message = "Login successful", user.UserName, user.Email });
        }

        // ✅ REGISTER ENDPOINT
        [HttpPost]
        public async Task<ActionResult<Users>> RegisterUser([FromBody] Users users)
        {
            // 🔹 Check if username or email already exists
            var existingUser = await _context.Users
                .FirstOrDefaultAsync(u => u.UserName == users.UserName || u.Email == users.Email);

            if (existingUser != null)
            {
                return Conflict(new { message = "Username or Email already exists!" });
            }

            _context.Users.Add(users);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUsers", new { UserName = users.UserName }, new
            {
                message = "User registered successfully",
                users.UserName,
                users.Email
            });
        }

        // ✅ GET ALL USERS
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Users>>> GetUsers()
        {
            return await _context.Users.ToListAsync();
        }

        // ✅ GET USER BY USERNAME
        [HttpGet("{UserName}")]
        public async Task<ActionResult<Users>> GetUsers(string UserName)
        {
            var users = await _context.Users.FirstOrDefaultAsync(u => u.UserName == UserName);

            if (users == null)
            {
                return NotFound(new { message = "User not found" });
            }

            return users;
        }

        // ✅ UPDATE USER
        [HttpPut("{UserName}")]
        public async Task<IActionResult> PutUsers(string UserName, Users users)
        {
            if (UserName != users.UserName)
            {
                return BadRequest(new { message = "Username mismatch" });
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
                    return NotFound(new { message = "User not found" });
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // ✅ DELETE USER
        [HttpDelete("{UserName}")]
        public async Task<IActionResult> DeleteUsers(string UserName)
        {
            var users = await _context.Users.FirstOrDefaultAsync(u => u.UserName == UserName);
            if (users == null)
            {
                return NotFound(new { message = "User not found" });
            }

            _context.Users.Remove(users);
            await _context.SaveChangesAsync();

            return Ok(new { message = "User deleted successfully" });
        }

        private bool UsersExists(string UserName)
        {
            return _context.Users.Any(e => e.UserName == UserName);
        }

        // ✅ LOGIN REQUEST MODEL
        public class LoginRequest
        {
            public string Username { get; set; }
            public string Password { get; set; }
        }
    }
}

using Microsoft.EntityFrameworkCore;

namespace API.Models
{
    public class ApiDbContext: DbContext
    {
        public ApiDbContext(DbContextOptions<ApiDbContext> options) : base(options)
        {
        }
        public DbSet<URLs> URLs { get; set; }
        public DbSet<Users> Users { get; set; }
    }
}

using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace FlutterWebAPI.Models
{
    public class ApiDbContext :DbContext
    {
        public ApiDbContext(DbContextOptions option) : base(option)
        {

        }
        public DbSet<Users> Users { get; set; }
    }
}

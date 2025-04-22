using LinkService.Models;
using Microsoft.EntityFrameworkCore;

namespace LinkService
{
    public class LinkDbContext : DbContext
    {
        public LinkDbContext(DbContextOptions<LinkDbContext> options) : base(options) { }

        public DbSet<Link> Links { get; set; }
    }
}

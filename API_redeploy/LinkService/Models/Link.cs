using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using AuthenticationService.Models;

namespace LinkService.Models
{
    public class Link
    {
        [Key]
        public string OriginalUrl { get; set; }  // Primary Key

        [Required]
        public string ShortenedUrl { get; set; }

        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [Required]
        public string UserName { get; set; }  // Foreign Key referencing User

        [ForeignKey("UserName")]
        public User User { get; set; }
    }
}

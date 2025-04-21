using System;
using System.ComponentModel.DataAnnotations;

namespace UrlService.Models
{
    public class ShortenedUrl
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(10)]
        public string ShortCode { get; set; }

        [Required]
        [StringLength(2000)]
        public string OriginalUrl { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
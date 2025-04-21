using System.ComponentModel.DataAnnotations;

namespace UrlService.DTOs
{
    public class CreateUrlDto
    {
        [Required]
        [Url]
        public string Url { get; set; }

        [StringLength(10, MinimumLength = 3)]
        public string CustomCode { get; set; }
    }
}
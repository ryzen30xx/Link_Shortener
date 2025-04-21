using System;

namespace UrlService.DTOs
{
    public class ShortenedUrlDto
    {
        public int Id { get; set; }
        public string ShortCode { get; set; }
        public string OriginalUrl { get; set; }
        public DateTime CreatedAt { get; set; }
        public string ShortUrl { get; set; }
    }
}
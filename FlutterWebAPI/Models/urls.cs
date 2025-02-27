using System.ComponentModel.DataAnnotations;

namespace FlutterWebAPI.Models
{
    public class urls
    {
        [Key, Required]
        public string origin_url { get; set; } = "";
        [Required]
        public string short_url { get; set; } = "";
        [Required]
        public string author { get; set; } = "";
        [Required]
        public DateTime created_date { get; set; }
        [Required]
        public DateTime end_date { get; set; }
    }
}

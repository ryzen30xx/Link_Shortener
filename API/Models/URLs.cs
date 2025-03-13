using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace API.Models
{
    public class URLs
    {
        [Key]
        public int URLId { get; set; }
        [Required]
        public string Origin_URL { get; set; } = "";
        public string Short_URL { get; set; } = "";
        [Required]
        public DateTime Create_date { get; set; } = DateTime.Now;
        public DateTime Expired_date { get; set; }
    }
}

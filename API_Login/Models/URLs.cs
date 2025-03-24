using System.ComponentModel.DataAnnotations;

namespace API_Login.Models
{
    public class URLs
    {
        [Key]
        public string URL { get; set; }
        //public int Id { get; set; }
        public string ShortURL { get; set; }
        public DateTime Created_date { get; set; }
        public DateTime Expiry_date { get; set; }


    }
}

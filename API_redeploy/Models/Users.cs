using System.ComponentModel.DataAnnotations;

namespace API.Models
{
    public class Users
    {
        [Required, Key]
        public string UserName { get; set; } = "";
        [Required]
        public string Password { get; set; } = "";
        public string Email { get; set; } = "";

    }
}

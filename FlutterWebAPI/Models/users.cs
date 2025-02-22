using System.ComponentModel.DataAnnotations;

namespace FlutterWebAPI.Models
{
    public class Users
    {
        [Key]
        public int UserId { get; set; }
        [Required]
        public string UserName { get; set; } = "";
        [Required]
        public string Password { get; set; } = "";

        public string Email { get; set; } = "";


    }
}

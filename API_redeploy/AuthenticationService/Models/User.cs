using System.ComponentModel.DataAnnotations;

namespace AuthenticationService.Models
{
    public class User
    {
        [Key]
        public string UserName { get; set; } 

        [Required]
        public string PasswordHash { get; set; } 
        [Required]
        public string Email { get; set; } 
    }
}

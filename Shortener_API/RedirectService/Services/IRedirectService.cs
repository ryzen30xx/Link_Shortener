using System.Threading.Tasks;

namespace RedirectService.Services
{
    public interface IRedirectService
    {
        Task<string> GetOriginalUrlAsync(string shortCode);
        Task RecordRedirectAsync(string shortCode, string userAgent, string ipAddress);
    }
}
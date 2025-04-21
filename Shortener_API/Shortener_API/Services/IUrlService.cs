using System.Collections.Generic;
using System.Threading.Tasks;
using UrlService.Models;
using UrlService.DTOs;

namespace UrlService.Services
{
    public interface IUrlService
    {
        Task<ShortenedUrlDto> CreateShortUrlAsync(CreateUrlDto createUrlDto);
        Task<ShortenedUrlDto> GetUrlByShortCodeAsync(string shortCode);
        Task<PagedResultDto<ShortenedUrlDto>> GetAllUrlsAsync(int page, int pageSize);
        Task<bool> DeleteUrlAsync(string shortCode);
        Task<bool> ShortCodeExistsAsync(string shortCode);
    }
}

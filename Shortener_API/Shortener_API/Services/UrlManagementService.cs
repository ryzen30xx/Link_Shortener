using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using UrlService.Data;
using UrlService.Models;
using UrlService.DTOs;
// To fix the error CS0246, you need to ensure that the Nanoid library is installed and properly referenced in your project.  
// Step 1: Install the Nanoid NuGet package.  
// Run the following command in the Package Manager Console or use the NuGet Package Manager in Visual Studio:  
// Install-Package Nanoid  

// Step 2: Ensure the Nanoid namespace is correctly imported.  
using static NanoidDotNet.Nanoid;
using NanoidDotNet;

namespace UrlService.Services
{
    public class UrlManagementService : IUrlService
    {
        private readonly UrlDbContext _dbContext;

        public UrlManagementService(UrlDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<ShortenedUrlDto> CreateShortUrlAsync(CreateUrlDto createUrlDto)
        {
            string shortCode = createUrlDto.CustomCode ?? Nanoid.Generate(size: 6);

            var shortenedUrl = new ShortenedUrl
            {
                ShortCode = shortCode,
                OriginalUrl = createUrlDto.Url,
                CreatedAt = DateTime.UtcNow
            };

            _dbContext.ShortenedUrls.Add(shortenedUrl);
            await _dbContext.SaveChangesAsync();

            return new ShortenedUrlDto
            {
                Id = shortenedUrl.Id,
                ShortCode = shortenedUrl.ShortCode,
                OriginalUrl = shortenedUrl.OriginalUrl,
                CreatedAt = shortenedUrl.CreatedAt
            };
        }

        public async Task<ShortenedUrlDto> GetUrlByShortCodeAsync(string shortCode)
        {
            var shortenedUrl = await _dbContext.ShortenedUrls
                .FirstOrDefaultAsync(u => u.ShortCode == shortCode);

            if (shortenedUrl == null)
                return null;

            return new ShortenedUrlDto
            {
                Id = shortenedUrl.Id,
                ShortCode = shortenedUrl.ShortCode,
                OriginalUrl = shortenedUrl.OriginalUrl,
                CreatedAt = shortenedUrl.CreatedAt
            };
        }

        public async Task<PagedResultDto<ShortenedUrlDto>> GetAllUrlsAsync(int page, int pageSize)
        {
            var totalCount = await _dbContext.ShortenedUrls.CountAsync();

            var urls = await _dbContext.ShortenedUrls
                .OrderByDescending(u => u.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(u => new ShortenedUrlDto
                {
                    Id = u.Id,
                    ShortCode = u.ShortCode,
                    OriginalUrl = u.OriginalUrl,
                    CreatedAt = u.CreatedAt
                })
                .ToListAsync();

            return new PagedResultDto<ShortenedUrlDto>
            {
                Items = urls,
                TotalCount = totalCount,
                Page = page,
                PageSize = pageSize,
                TotalPages = (int)Math.Ceiling(totalCount / (double)pageSize)
            };
        }

        public async Task<bool> DeleteUrlAsync(string shortCode)
        {
            var shortenedUrl = await _dbContext.ShortenedUrls
                .FirstOrDefaultAsync(u => u.ShortCode == shortCode);

            if (shortenedUrl == null)
                return false;

            _dbContext.ShortenedUrls.Remove(shortenedUrl);
            await _dbContext.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ShortCodeExistsAsync(string shortCode)
        {
            return await _dbContext.ShortenedUrls
                .AnyAsync(u => u.ShortCode == shortCode);
        }
    }
}
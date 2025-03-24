using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using API.Models;

namespace API.Controllers
{
    // Định tuyến API, Controller này sẽ được truy cập qua đường dẫn: api/URLs
    [Route("api/[controller]")]
    [ApiController]
    public class URLsController : ControllerBase
    {
        private readonly ApiDbContext _context;

        // Constructor nhận một instance của ApiDbContext để tương tác với cơ sở dữ liệu
        public URLsController(ApiDbContext context)
        {
            _context = context;
        }

        // GET: api/URLs
        // Phương thức này lấy danh sách tất cả URL trong cơ sở dữ liệu
        [HttpGet]
        public async Task<ActionResult<IEnumerable<URLs>>> GetURLs()
        {
            return await _context.URLs.ToListAsync();
        }

        // GET: api/URLs/5
        // Phương thức này lấy một URL cụ thể dựa trên khóa chính (Origin_URL)
        [HttpGet("{id}")]
        public async Task<ActionResult<URLs>> GetURLs(string id)
        {
            var uRLs = await _context.URLs.FindAsync(id);

            // Nếu không tìm thấy URL, trả về mã lỗi 404 Not Found
            if (uRLs == null)
            {
                return NotFound();
            }

            return uRLs;
        }

        // PUT: api/URLs/5
        // Cập nhật một URL hiện có dựa trên id (Origin_URL)
        [HttpPut("{id}")]
        public async Task<IActionResult> PutURLs(string id, URLs uRLs)
        {
            // Kiểm tra nếu id trong request không khớp với id của đối tượng
            if (id != uRLs.Origin_URL)
            {
                return BadRequest();
            }

            // Đánh dấu entity là đã bị chỉnh sửa
            _context.Entry(uRLs).State = EntityState.Modified;

            try
            {
                // Lưu các thay đổi vào database
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                // Kiểm tra nếu URL không tồn tại thì trả về NotFound
                if (!URLsExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw; // Nếu có lỗi khác, ném ngoại lệ
                }
            }

            return NoContent(); // Trả về 204 No Content khi thành công
        }

        // POST: api/URLs
        // Thêm một URL mới vào cơ sở dữ liệu
        [HttpPost]
        public async Task<ActionResult<URLs>> PostURLs(URLs uRLs)
        {
            _context.URLs.Add(uRLs);
            
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                // Kiểm tra nếu URL đã tồn tại trong database
                if (URLsExists(uRLs.Origin_URL))
                {
                    return Conflict(); // Trả về lỗi 409 Conflict
                }
                else
                {
                    throw; // Nếu lỗi khác, ném ngoại lệ
                }
            }

            // Trả về HTTP 201 Created và đường dẫn của tài nguyên vừa tạo
            return CreatedAtAction("GetURLs", new { id = uRLs.Origin_URL }, uRLs);
        }

        // DELETE: api/URLs/5
        // Xóa một URL dựa trên id (Origin_URL)
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteURLs(string id)
        {
            var uRLs = await _context.URLs.FindAsync(id);
            if (uRLs == null)
            {
                return NotFound(); // Trả về 404 nếu không tìm thấy URL
            }

            _context.URLs.Remove(uRLs);
            await _context.SaveChangesAsync();

            return NoContent(); // Trả về 204 No Content khi xóa thành công
        }

        // Kiểm tra xem URL có tồn tại trong database không
        private bool URLsExists(string id)
        {
            return _context.URLs.Any(e => e.Origin_URL == id);
        }
    }
}

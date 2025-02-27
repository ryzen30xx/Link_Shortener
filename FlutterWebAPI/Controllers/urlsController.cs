 using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using FlutterWebAPI.Models;

namespace FlutterWebAPI.Controllers
{
    public class urlsController : Controller
    {
        private readonly ApiDbContext _context;

        public urlsController(ApiDbContext context)
        {
            _context = context;
        }

        // GET: urls
        public async Task<IActionResult> Index()
        {
            return View(await _context.urls.ToListAsync());
        }

        // GET: urls/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var urls = await _context.urls
                .FirstOrDefaultAsync(m => m.origin_url == id);
            if (urls == null)
            {
                return NotFound();
            }

            return View(urls);
        }

        // GET: urls/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: urls/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("origin_url,short_url,author,created_date,end_date")] urls urls)
        {
            if (ModelState.IsValid)
            {
                _context.Add(urls);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(urls);
        }

        // GET: urls/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var urls = await _context.urls.FindAsync(id);
            if (urls == null)
            {
                return NotFound();
            }
            return View(urls);
        }

        // POST: urls/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("origin_url,short_url,author,created_date,end_date")] urls urls)
        {
            if (id != urls.origin_url)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(urls);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!urlsExists(urls.origin_url))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(urls);
        }

        // GET: urls/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var urls = await _context.urls
                .FirstOrDefaultAsync(m => m.origin_url == id);
            if (urls == null)
            {
                return NotFound();
            }

            return View(urls);
        }

        // POST: urls/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var urls = await _context.urls.FindAsync(id);
            if (urls != null)
            {
                _context.urls.Remove(urls);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool urlsExists(string id)
        {
            return _context.urls.Any(e => e.origin_url == id);
        }
    }
}

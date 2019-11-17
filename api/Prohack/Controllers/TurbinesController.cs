using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Prohack.Core;
using Prohack.Core.Models;

namespace Prohack.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TurbinesController : ControllerBase
    {

        private readonly ILogger<TurbinesController> _logger;

        private readonly DatabaseContext _context;

        public TurbinesController(ILogger<TurbinesController> logger, DatabaseContext context)
        {
            _logger = logger;
            _context = context;
        }

        [HttpGet]
        public IEnumerable<Turbine> Get(int mineId)
        {
            return _context.Turbines.Where(i => i.MineId == mineId).ToList();
        }

        [HttpPost]
        public bool Post(int turbineId, int status, bool useManual = false)
        {
            var turbine = _context.Turbines.FirstOrDefault(i => i.Id == turbineId);
            if (turbine != null)
            {
                turbine.Status = status;
                turbine.UseManual = useManual;
                _context.Update(turbine);
                _context.SaveChanges();
                return true;
            }
            return false;
        }    }
}

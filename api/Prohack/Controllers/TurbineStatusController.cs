using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Prohack.Core;
using Prohack.Core.Models;

namespace Prohack.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TurbineStatusController : ControllerBase
    {

        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<MinesController> _logger;

        private readonly DatabaseContext _context;

        public TurbineStatusController(ILogger<MinesController> logger, DatabaseContext context)
        {
            _logger = logger;
            _context = context;
        }

        [HttpGet]
        public int Get(int turbineId)
        {
            var turbine = _context.Turbines.Include(i => i.Device).Include(i => i.Device.Datas).FirstOrDefault(i => i.Id == turbineId);
            if (turbine != null)
            {
                
                if (!turbine.UseManual)
                {
                    turbine.Status = TurbineLogic.GetStatus(turbine);
                }
                _context.Update(turbine);
                _context.SaveChanges();
                return turbine.Status;
            }
            return -1;
        }
    }
}

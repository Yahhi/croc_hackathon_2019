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
    public class TooltipTurbineController : ControllerBase
    {


        private readonly ILogger<TooltipTurbineController> _logger;

        private readonly DatabaseContext _context;

        public TooltipTurbineController(ILogger<TooltipTurbineController> logger, DatabaseContext context)
        {
            _logger = logger;
            _context = context;
        }

        [HttpGet]
        public Turbine Get(int turbineId)
        {
            var turbine = _context.Turbines.FirstOrDefault(d => d.Id == turbineId);
            if (turbine != null)
            {
                return turbine;
            }
            return null;
        }
    }
}

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
    public class DevicesController : ControllerBase
    {


        private readonly ILogger<DevicesController> _logger;

        private readonly DatabaseContext _context;

        public DevicesController(ILogger<DevicesController> logger, DatabaseContext context)
        {
            _logger = logger;
            _context = context;
        }

        [HttpGet]
        public IEnumerable<DeviceViewModel> Get(int mineId)
        {
            return _context.Devices.Include(d => d.Datas).Where(d => d.MineId == mineId).ToList().Select(i => new DeviceViewModel(i));
        }
    }
}

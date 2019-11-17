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
    public class TooltipController : ControllerBase
    {


        private readonly ILogger<DevicesController> _logger;

        private readonly DatabaseContext _context;

        public TooltipController(ILogger<DevicesController> logger, DatabaseContext context)
        {
            _logger = logger;
            _context = context;
        }

        [HttpGet]
        public DeviceDataSummary Get(int deviceId)
        {
            var device = _context.Devices.Include(d => d.Datas).FirstOrDefault(d => d.Id == deviceId);
            if (device != null)
            {
                var data = DataLogic.GetSummaryForDevice(device);
                return data;
            }
            return null;
        }
    }
}
